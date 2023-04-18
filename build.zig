const std = @import("std");

const Build = std.Build;
const Module = Build.Module;
const CompileStep = Build.CompileStep;
const RunStep = Build.RunStep;
const FileSource = Build.FileSource;
const InstallDir = Build.InstallDir;
const OptimizeMode = std.builtin.OptimizeMode;
const CrossTarget = std.zig.CrossTarget;
const SemanticVersion = std.SemanticVersion;
const ArrayList = std.ArrayList;
const FieldEnum = std.meta.FieldEnum;
const fieldNames = std.meta.fieldNames;
const comptimePrint = std.fmt.comptimePrint;
const fmtId = std.zig.fmtId;
const fmtEscapes = std.zig.fmtEscapes;

pub const flecs_version = SemanticVersion.parse("3.2.1") catch unreachable;

pub fn build(builder: *Build) void {
    const invoked_by_zls = if (builder.user_input_options.contains("invoked-by-zls"))
        builder.option(bool, "invoked-by-zls", "").?
    else
        false;

    const target = builder.standardTargetOptions(.{});
    const optimize = builder.standardOptimizeOption(.{});
    const test_filter = builder.option([]const u8, "test-filter", "Filter the tests to be executed");
    const nontrivial_asserts = builder.option(
        PackageOptions.NontrivialAsserts,
        "nontrivial-asserts",
        "Control the modes in which assert statements that rely on extern fn are allowed",
    ) orelse .debug;

    const package = Package.configure(builder, .{
        .package_root = "",
        .target = target,
        .optimize = optimize,
        .addons = FlecsAddons.fromBuildOptions(builder),
        .types = FlecsTypes.fromBuildOptions(builder),
        .constants = FlecsConstants.fromBuildOptions(builder),
        .nontrivial_asserts = nontrivial_asserts,
        ._invoked_by_zls = invoked_by_zls,
    });
    builder.modules.put("lzflecs", package.module) catch @panic("OOM");
    builder.installArtifact(package.static_library);

    const main_tests = package.testStep(builder, test_filter);

    builder.top_level_steps.clearRetainingCapacity();
    const test_step = builder.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
    builder.default_step = test_step;
}

/// Options to control the behavior of `Package.configure`.
pub const PackageOptions = struct {
    /// The directory containing this file, `build.zig`.
    ///
    /// Should be an absolute path or a path relative to the build root of the
    /// builder passed to `Package.configure`. This field is optional when the
    /// build process takes place on a system that supports absolute paths and
    /// is not relevant when using the Zig package manager.
    package_root: ?[]const u8 = default_package_root,

    /// Target for which the Flecs source files should be compiled.
    target: CrossTarget,

    /// Optimization level for which the Flecs source files should be compiled.
    optimize: OptimizeMode,

    /// Addons to enable when compiling Flecs.
    addons: FlecsAddons = .{},

    /// Types used for certain measurements and stored values.
    types: FlecsTypes = .{},

    /// Configurable constants to build Flecs with.
    constants: FlecsConstants = .{},

    /// Control which optimization modes will contain nontrivial asserts (asserts
    /// that rely on the result of `extern fn` calls). By default, only the `Debug`
    /// mode will contain these assert statements.
    nontrivial_asserts: NontrivialAsserts = .debug,

    /// Internal option that makes `WriteFileStep` run early so ZLS can analyze
    /// the generated `package_options` module.
    _invoked_by_zls: bool = false,

    pub const NontrivialAsserts = enum {
        /// Emit nontrivial asserts in `Debug` and `ReleaseSafe` modes.
        @"debug-and-safe",

        /// Emit nontrivial asserts in `Debug` mode only.
        debug,

        /// Always emit nontrivial asserts, even outside of safe modes.
        always,

        /// Never emit nontrivial asserts, even in safe modes.
        never,

        fn enableForMode(assert_config: NontrivialAsserts, optimize: OptimizeMode) bool {
            return switch (assert_config) {
                .always => true,
                .never => false,
                .debug => optimize == .Debug,
                .@"debug-and-safe" => optimize == .Debug or optimize == .ReleaseSafe,
            };
        }
    };

    /// Create a generated module based on the configured `package_options` to
    /// allow introspection of the configured options within the library.
    ///
    /// Unlike the module created through `OptionsStep`, the module returned
    /// here is separated into multiple files via `WriteFileStep`.
    fn createModule(options: PackageOptions, builder: *Build) *Module {
        const root_file_contents: []const u8 = blk: {
            var buf = ArrayList(u8).init(builder.allocator);
            const writer = buf.writer();

            writer.print(
                \\pub const metadata = @import("metadata.zig");
                \\pub const enabled_addons = @import("enabled_addons.zig");
                \\pub const types = @import("types.zig");
                \\pub const constants = @import("constants.zig");
                \\
                \\/// Whether to emit assert statements that rely on `extern fn`.
                \\pub const nontrivial_asserts: bool = {};
                \\
            , .{
                options.nontrivial_asserts.enableForMode(options.optimize),
            }) catch @panic("OOM");

            break :blk buf.toOwnedSlice() catch @panic("OOM");
        };

        const metadata_file_contents: []const u8 = comptime blk: {
            var buf: []const u8 = comptimePrint(
                \\/// Version of Flecs shipped with `lzflecs`.
                \\///
                \\/// Between tagged releases, the value of this constant is generated by `lzflecs`
                \\/// in a similar format to nightly Zig versions (`X.Y.Z-dev.123+commithash`).
                \\pub const flecs_version: @import("std").SemanticVersion = .{{
                \\    .major = {d},
                \\    .minor = {d},
                \\    .patch = {d},
                \\
            , .{
                flecs_version.major,
                flecs_version.minor,
                flecs_version.patch,
            });
            if (flecs_version.pre) |prerelease| {
                buf = buf ++ comptimePrint(
                    "    .pre = \"{}\",\n",
                    .{ fmtEscapes(prerelease) },
                );
            }
            if (flecs_version.build) |build_metadata| {
                buf = buf ++ comptimePrint(
                    "    .build = \"{}\",\n",
                    .{ fmtEscapes(build_metadata) },
                );
            }
            break :blk buf ++ "};\n";
        };

        const enabled_addons_file_contents: []const u8 = blk: {
            var buf = ArrayList(u8).init(builder.allocator);
            const writer = buf.writer();

            inline for (comptime FlecsAddons.fields(), 0..) |field, index| {
                const field_name = @tagName(field);
                const macro_name = comptime FlecsAddons.macroName(field);

                if (index > 0) {
                    writer.writeAll("\n") catch @panic("OOM");
                }

                writer.print(
                    "/// Whether the {} addon is enabled or not.\npub const {}: bool = {};\n",
                    .{
                        fmtId(macro_name),
                        fmtId(field_name),
                        @field(options.addons, field_name),
                    },
                ) catch @panic("OOM");
            }

            break :blk buf.toOwnedSlice() catch @panic("OOM");
        };

        const types_file_contents: []const u8 = blk: {
            var buf = ArrayList(u8).init(builder.allocator);
            const writer = buf.writer();

            inline for (comptime FlecsTypes.fields(), 0..) |field, index| {
                const field_name = @tagName(field);

                if (index > 0) {
                    writer.writeAll("\n") catch @panic("OOM");
                }

                writer.print(
                    "/// {s}.\npub const {}: type = {s};\n",
                    .{
                        comptime FlecsTypes.optionDescription(field),
                        fmtId(field_name),
                        @tagName(@field(options.types, field_name)),
                    },
                ) catch @panic("OOM");
            }

            break :blk buf.toOwnedSlice() catch @panic("OOM");
        };

        const constants_file_contents: []const u8 = blk: {
            var buf = ArrayList(u8).init(builder.allocator);
            const writer = buf.writer();

            inline for (comptime FlecsConstants.fields()) |field| {
                writer.print("pub const {} = {};\n", .{
                    fmtId(@tagName(field)),
                    options.constants.value(field),
                }) catch @panic("OOM");
            }

            break :blk buf.toOwnedSlice() catch @panic("OOM");
        };

        const generated_directory = builder.addWriteFiles();
        generated_directory.add("package_options.zig", root_file_contents);
        generated_directory.add("metadata.zig", metadata_file_contents);
        generated_directory.add("enabled_addons.zig", enabled_addons_file_contents);
        generated_directory.add("types.zig", types_file_contents);
        generated_directory.add("constants.zig", constants_file_contents);

        if (options._invoked_by_zls) {
            var progress = std.Progress{};
            const node = progress.start("package-options", 1);
            generated_directory.step.make(node) catch {};
            node.end();
        }

        return builder.createModule(.{
            .source_file = generated_directory.getFileSource("package_options.zig").?,
        });
    }
};

/// Configure which Flecs addons should be enabled.
pub const FlecsAddons = struct {
    /// Organize logic into reusable modules.
    module: bool = true,

    /// Create and run systems.
    system: bool = true,

    /// Automatically schedule and multithread systems.
    pipeline: bool = true,

    /// Run systems at time intervals or at a rate.
    timer: bool = true,

    /// Flecs reflection system.
    meta: bool = true,

    /// Builtin unit types.
    units: bool = true,

    /// String format optimized for ECS data.
    expr: bool = true,

    /// JSON format.
    json: bool = true,

    /// Add documentation to components, systems, and more.
    doc: bool = true,

    /// Documentation for builtin components and modules.
    coredoc: bool = true,

    /// Tiny HTTP server for processing simple requests.
    http: bool = true,

    /// REST API for showing entities in the browser.
    rest: bool = true,

    /// Create entities and queries from strings.
    parser: bool = true,

    /// Small utility language for asset/scene loading.
    plecs: bool = true,

    /// Powerful prolog-like query language.
    rules: bool = true,

    /// Take snapshots of the world and restore them.
    snapshot: bool = true,

    /// See what is happening in a world with statistics.
    stats: bool = true,

    /// Periodically collect and store statistics.
    monitor: bool = true,

    /// Expose component data as statistics.
    metrics: bool = true,

    /// Extended tracing and error logging.
    log: bool = true,

    /// Journaling of API functions.
    journal: bool = false,

    /// Optional addon for running the main application loop.
    app: bool = true,

    /// Default OS API implementation for POSIX/Win32.
    os_api_impl: bool = true,

    fn fields() *const [fieldNames(FlecsAddons).len]FieldEnum(FlecsAddons) {
        const buf = comptime blk: {
            const field_names = fieldNames(FlecsAddons);
            var buf: [field_names.len]FieldEnum(FlecsAddons) = undefined;
            for (field_names, &buf) |field_name, *buf_entry| {
                buf_entry.* = @field(FieldEnum(FlecsAddons), field_name);
            }
            break :blk &buf;
        };
        return buf;
    }

    fn macroName(comptime field: FieldEnum(FlecsAddons)) [:0]const u8 {
        const buf = comptime blk: {
            const field_name = @tagName(field);
            var buf = [_:0]u8{ undefined } ** field_name.len;
            _ = std.ascii.upperString(&buf, field_name);
            break :blk "FLECS_" ++ &buf;
        };
        return buf;
    }

    fn blacklistMacroName(comptime field: FieldEnum(FlecsAddons)) [:0]const u8 {
        return comptime ("FLECS_NO_" ++ macroName(field)["FLECS_".len..]);
    }

    fn optionName(comptime field: FieldEnum(FlecsAddons)) [:0]const u8 {
        const buf = comptime blk: {
            const field_name = @tagName(field);
            var buf = field_name[0..field_name.len :0].*;
            std.mem.replaceScalar(u8, &buf, '_', '-');
            break :blk &buf ++ "-addon";
        };
        return buf;
    }

    fn fromBuildOptions(builder: *Build) FlecsAddons {
        var addons = FlecsAddons{};
        inline for (comptime fields()) |field| {
            const field_name = @tagName(field);
            const macro_name = comptime macroName(field);
            const option_name = comptime optionName(field);
            const option_description = "Enable the " ++ macro_name ++ " addon";
            if (builder.option(bool, option_name, option_description)) |option_value| {
                @field(addons, field_name) = option_value;
            }
        }
        return addons;
    }

    fn dependencies(comptime field: FieldEnum(FlecsAddons)) []const FieldEnum(FlecsAddons) {
        return switch (field) {
            .module => &.{},
            .system => &.{ .module },
            .pipeline => &.{ .module, .system },
            .timer => &.{ .module, .pipeline },
            .meta => &.{ .module },
            .units => &.{ .module, .meta },
            .expr => &.{ .meta, .parser },
            .json => &.{ .expr },
            .doc => &.{ .module },
            .coredoc => &.{ .doc, .meta },
            .http => &.{},
            .rest => &.{ .http, .json, .pipeline, .rules },
            .parser => &.{},
            .plecs => &.{ .parser },
            .rules => &.{},
            .snapshot => &.{},
            .stats => &.{},
            .monitor => &.{ .stats, .system, .timer },
            .metrics => &.{ .meta, .units, .pipeline },
            .log => &.{},
            .journal => &.{ .log },
            .app => &.{ .pipeline },
            .os_api_impl => &.{},
        };
    }

    fn enableDependencies(addons: *FlecsAddons, comptime field: FieldEnum(FlecsAddons)) void {
        inline for (comptime dependencies(field)) |dependency| {
            addons.enableDependencies(dependency);
            @field(addons, @tagName(dependency)) = true;
        }
    }

    fn applyTransitiveDependencies(addons: *FlecsAddons) void {
        inline for (comptime fields()) |field| {
            const field_name = @tagName(field);
            if (@field(addons, field_name)) {
                addons.enableDependencies(field);
            }
        }
    }
};

/// Configure the types to be used for certain measurements and stored values.
pub const FlecsTypes = struct {
    pub const Float = enum { f32, f64 };

    ecs_float_t: Float = .f32,
    ecs_ftime_t: Float = .f32,

    fn fields() *const [fieldNames(FlecsTypes).len]FieldEnum(FlecsTypes) {
        const buf = comptime blk: {
            const field_names = fieldNames(FlecsTypes);
            var buf: [field_names.len]FieldEnum(FlecsTypes) = undefined;
            for (field_names, &buf) |field_name, *buf_entry| {
                buf_entry.* = @field(FieldEnum(FlecsTypes), field_name);
            }
            break :blk &buf;
        };
        return buf;
    }

    fn fromBuildOptions(builder: *Build) FlecsTypes {
        var types = FlecsTypes{};
        inline for (comptime fields()) |field| {
            const field_name = @tagName(field);
            const FieldType = @TypeOf(@field(types, field_name));
            const option_description = comptime optionDescription(field);
            if (builder.option(FieldType, field_name, option_description)) |option_value| {
                @field(types, field_name) = option_value;
            } else if (field == .ecs_ftime_t) {
                types.ecs_ftime_t = types.ecs_float_t;
            }
        }
        return types;
    }

    fn optionDescription(comptime field: FieldEnum(FlecsTypes)) [:0]const u8 {
        return switch (field) {
            .ecs_float_t => "Customizable precision for floating point operations",
            .ecs_ftime_t => "Customizable precision for scalar time values",
        };
    }

    fn macroValue(types: FlecsTypes, comptime field: FieldEnum(FlecsTypes)) [:0]const u8 {
        const field_name = @tagName(field);
        const field_value = @field(types, field_name);
        return switch (@TypeOf(field_value)) {
            Float => switch (field_value) {
                .f32 => "float",
                .f64 => "double",
            },
            else => comptime unreachable,
        };
    }
};

/// Configure the values of certain macro definitions.
pub const FlecsConstants = struct {
    /// Whether the "low footprint" preset is enabled or not.
    ///
    /// When true, the defaults for each numeric constant are lowered
    /// significantly. This decreases memory footprint at the cost of
    /// decreased performance.
    ///
    /// The defaults for each constant with and without the option are
    /// specified in the respective constant's documentation comment.
    low_footprint: bool = false,

    /// Number of reserved entity IDs for components.
    ///
    /// This constant can be used to balance between performance and memory
    /// utilization. The constant is used in two ways:
    ///
    ///  - Entity IDs `0..hi_component_id` are reserved for component IDs.
    ///  - Used as lookup array size in table edges.
    ///
    /// Increasing this value increases the size of the lookup, which allows
    /// fast table traversal. This improves the perofmrance of ECS add/remove
    /// operations at the cost of (significantly) higher memory usage.
    ///
    /// Component IDs that fall outside of this range use a regular map lookup,
    /// which is slower but more memory efficient.
    ///
    /// Default: 256
    /// Low Footprint: 16
    hi_component_id: ?u16 = null,

    /// Number of elements in the ID record lookup array.
    ///
    /// This constant can be used to balance between performance and memory
    /// utilization. The value is used to determine the size of the ID record
    /// lookup array.
    ///
    /// ID values that fall outside of this range use a regular map lookup,
    /// which is slower but more memory efficient.
    ///
    /// Default: 1024
    /// Low Footprint: 16
    hi_id_record_id: ?u16 = null,

    /// Number of bits in an ID that are used to determine the page index when
    /// used with a sparse set.
    ///
    /// The number of bits determines the page size, which is `(1 << bits)`.
    ///
    /// Lower values decrease memory utilization at the cost of requiring more
    /// individual allocations.
    ///
    /// Default: 12
    /// Low Footprint: 6
    sparse_page_bits: ?u16 = null,

    /// Whether to use the OS allocator specified in the OS API directly, as
    /// opposed to using the builtin block allocator.
    ///
    /// This can decrease memory utilization as memory will be freed more
    /// often, at the cost of decreased performance. However, using this
    /// option may be required to work around alignment issues with the block
    /// allocator. See <https://github.com/SanderMertens/flecs/issues/478>.
    ///
    /// Default: false
    /// Low Footprint: true
    use_os_alloc: ?bool = null,

    fn fields() *const [fieldNames(FlecsConstants).len]FieldEnum(FlecsConstants) {
        const buf = comptime blk: {
            const field_names = fieldNames(FlecsConstants);
            var buf: [field_names.len]FieldEnum(FlecsConstants) = undefined;
            for (field_names, &buf) |field_name, *buf_entry| {
                buf_entry.* = @field(FieldEnum(FlecsConstants), field_name);
            }
            break :blk &buf;
        };
        return buf;
    }

    fn fromBuildOptions(builder: *Build) FlecsConstants {
        var constants = FlecsConstants{};
        inline for (comptime fields()) |field| {
            const FieldType = @TypeOf(constants.value(field));
            const option_name = comptime optionName(field);
            const option_description = comptime optionDescription(field);
            if (builder.option(FieldType, option_name, option_description)) |option_value| {
                @field(constants, @tagName(field)) = option_value;
            }
        }
        return constants;
    }

    fn optionDescription(comptime field: FieldEnum(FlecsConstants)) [:0]const u8 {
        return switch (field) {
            .low_footprint => "Decrease memory utilization at the cost of performance",
            .hi_component_id => "Number of reserved component IDs",
            .hi_id_record_id => "Number of reserved ID record IDs",
            .sparse_page_bits => "Number of bits used to determine sparse page size",
            .use_os_alloc => "Whether to use OS allocator directly or not",
        };
    }

    fn macroName(comptime field: FieldEnum(FlecsConstants)) [:0]const u8 {
        const buf = comptime blk: {
            const field_name = @tagName(field);
            var buf = [_:0]u8{ undefined } ** field_name.len;
            _ = std.ascii.upperString(&buf, field_name);
            break :blk "FLECS_" ++ &buf;
        };
        return buf;
    }

    fn optionName(comptime field: FieldEnum(FlecsConstants)) [:0]const u8 {
        const buf = comptime blk: {
            const field_name = @tagName(field);
            var buf = field_name[0..field_name.len :0].*;
            std.mem.replaceScalar(u8, &buf, '_', '-');
            break :blk &buf;
        };
        return buf;
    }

    pub fn value(
        constants: FlecsConstants,
        comptime field: FieldEnum(FlecsConstants),
    ) switch (field) {
        .low_footprint, .use_os_alloc => bool,
        .hi_component_id, .hi_id_record_id, .sparse_page_bits => u16,
    } {
        return switch (field) {
            .low_footprint => constants.low_footprint,
            else => @field(constants, @tagName(field)) orelse switch (field) {
                .low_footprint => comptime unreachable,
                .hi_component_id => if (constants.low_footprint) 16 else 256,
                .hi_id_record_id => if (constants.low_footprint) 16 else 1024,
                .sparse_page_bits => if (constants.low_footprint) 6 else 12,
                .use_os_alloc => constants.low_footprint,
            },
        };
    }
};

/// Configured `lzflecs` module and Flecs compilation step.
pub const Package = struct {
    module: *Module,
    static_library: *CompileStep,

    /// Configure and return the `lzflecs` module and Flecs compilation step.
    pub fn configure(builder: *Build, options_: PackageOptions) Package {
        var options = options_;
        options.addons.applyTransitiveDependencies();

        const package_root = options.package_root orelse @panic(
            "Could not infer a value for `package_root`; please specify an explicit value for this option.",
        );

        const module = builder.createModule(.{
            .source_file = .{
                .path = packagePath(builder, package_root, "src/lzflecs.zig"),
            },
            .dependencies = &.{
                .{
                    .name = "package_options",
                    .module = options.createModule(builder),
                },
            },
        });

        const include_dir = packagePath(builder, package_root, "deps/flecs");
        const flecs_c = packagePath(builder, package_root, "deps/flecs/flecs.c");

        const static_library = builder.addStaticLibrary(.{
            .name = "flecs",
            .target = options.target,
            .optimize = options.optimize,
        });

        static_library.linkLibC();
        static_library.addIncludePath(include_dir);
        static_library.addCSourceFile(flecs_c, &.{
            "-std=gnu99",
        });

        static_library.defineCMacroRaw("FLECS_CUSTOM_BUILD");
        inline for (comptime FlecsAddons.fields()) |field| {
            const field_name = @tagName(field);
            const enabled = @field(options.addons, field_name);

            const macro_name = if (enabled)
                comptime FlecsAddons.macroName(field)
            else
                comptime FlecsAddons.blacklistMacroName(field);

            static_library.defineCMacroRaw(macro_name);
        }

        inline for (comptime FlecsTypes.fields()) |field| {
            const macro_name = @tagName(field);
            const macro_value = options.types.macroValue(field);

            static_library.defineCMacro(macro_name, macro_value);
        }

        inline for (comptime FlecsConstants.fields()[1..]) |field| {
            var buf: [5]u8 = undefined;
            const macro_name = comptime FlecsConstants.macroName(field);
            const macro_value = std.fmt.bufPrint(&buf, "{}", .{
                options.constants.value(field),
            }) catch unreachable;

            static_library.defineCMacro(macro_name, macro_value);
        }

        if (options.target.isWindows()) {
            static_library.linkSystemLibrary("ws2_32");
        }

        return .{
            .module = module,
            .static_library = static_library,
        };
    }

    /// Expose `package.module` as `lzflecs` and link `package.static_library`
    /// to the provided `compile_step`.
    pub fn link(package: Package, compile_step: *CompileStep) void {
        compile_step.addModule("lzflecs", package.module);
        compile_step.linkLibrary(package.static_library);
    }

    /// Derive a test step based on the module and static library held by `package`.
    fn testStep(package: Package, builder: *Build, test_filter: ?[]const u8) *RunStep {
        const test_compile_step = builder.addTest(.{
            .root_source_file = package.module.source_file,
            .target = package.static_library.target,
            .optimize = package.static_library.optimize,
            .filter = test_filter,
        });
        test_compile_step.linkLibrary(package.static_library);

        const dependencies = &package.module.dependencies;
        for (dependencies.keys(), dependencies.values()) |dependency_name, dependency_module| {
            test_compile_step.addModule(dependency_name, dependency_module);
        }

        return builder.addRunArtifact(test_compile_step);
    }
};

const default_package_root: ?[]const u8 = struct {
    fn packageRoot() ?[]const u8 {
        if (std.fs.path.dirname(@src().file)) |package_root| {
            if (std.fs.path.isAbsolute(package_root)) {
                return package_root;
            }
        }
        return null;
    }
}.packageRoot();

fn packagePath(builder: *Build, package_root: []const u8, relative_path: []const u8) []const u8 {
    std.debug.assert(!std.fs.path.isAbsolute(relative_path));
    if (package_root.len == 0) {
        return relative_path;
    }
    return builder.pathJoin(&.{ package_root, relative_path });
}
