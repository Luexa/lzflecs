const std = @import("std");
const builtin = @import("builtin");

const flecs = @import("../lzflecs.zig");
const c = flecs.c;
const enabled_addons = flecs.enabled_addons;
const Id = flecs.Id;
const EntityTypeMeta = flecs.EntityTypeMeta;

/// Internal container that provides a global variable that can hold dynamically
/// assigned component IDs and global entity IDs.
///
/// Builtin Flecs types are automatically resolved to their corresponding entity
/// ID rather than being assigned an ID through this scheme.
pub fn IdStorage(comptime T: type) type {
    comptime validateGlobalEntityType(T);
    if (T != CanonicalizePointer(T)) {
        return IdStorage(CanonicalizePointer(T));
    }
    return struct {
        var reset_count: u64 = 0;
        var value: c.ecs_entity_t = 0;

        const storage_info = StorageInfo.of(T);

        /// The intended context in which the entity ID for this type should be
        /// registered, if any.
        ///
        /// See the documentation of `IntendedUse` for more information.
        pub const intended_use: IntendedUse = storage_info.intended_use;

        /// The name that should be assigned to the entity.
        ///
        /// For builtin entities, the name is consistent with what Flecs expects.
        ///
        /// For user-defined types, the default is `@typeName(T)` with a generated
        /// suffix to make the type name less likely to collide across packages.
        ///
        /// The name can be customized if `T.flecs_meta.name` is defined.
        pub const name: ?[:0]const u8 = storage_info.name;

        /// The symbol that should be assigned to the entity.
        ///
        /// Never defined for builtin entities, and not defined by default for
        /// user-defined types (as the default would be the same as the entity
        /// name).
        ///
        /// The symbol can be customized if `T.flecs_meta.symbol` is defined.
        pub const symbol: ?[:0]const u8 = storage_info.symbol;

        /// Retrieve the entity ID for this type.
        ///
        /// Uses `extern` storage for builtin types and the `value` global for
        /// user-defined types.
        pub inline fn get() c.ecs_entity_t {
            if (storage_info.extern_decl) |extern_decl| {
                return @field(c, @tagName(extern_decl));
            } else if (!builtin.is_test or reset_count == id_tracker.reset_count) {
                return value;
            } else {
                return 0;
            }
        }

        /// Overwrite the entity ID for this type.
        ///
        /// Uses `extern` storage for builtin types and the `value` global for
        /// user-defined types.
        pub inline fn set(new_value: c.ecs_entity_t) void {
            if (storage_info.extern_decl) |extern_decl| {
                @field(c, @tagName(extern_decl)) = new_value;
            } else {
                value = new_value;
                if (builtin.is_test) {
                    reset_count = id_tracker.reset_count;
                }
            }
        }
    };
}

/// Enum with a variant for each declaration in `c.zig`.
const ExternDecl = blk: {
    @setEvalBranchQuota(@typeInfo(c).Struct.decls.len * 2);
    break :blk std.meta.DeclEnum(c);
};

/// The intended context in which an entity ID should be registered, if any.
///
/// Specifies whether the type should be assigned an ID at runtime, and if so
/// whether it is flexible or restricted to being a component or global entity.
///
/// Used to bridge the gap between builtin and user-defined types.
pub const IntendedUse = enum {
    /// Register the type as a component or global entity depending on which
    /// method is used to assign a type ID.
    ///
    /// Used for user-defined types with no `flecs_trivial` decl.
    any,

    /// Do not attempt to register or update the ID of this type.
    ///
    /// Used for `extern const` entity or component IDs.
    none,

    /// Always register the type as a component, even if the user attempts to
    /// register it as a global entity.
    ///
    /// Used for `extern var` component IDs or user-defined types with
    /// `flecs_trivial == false`.
    component,

    /// Always register the type as a global entity, even if the user attempts to
    /// register it as a component.
    ///
    /// Used for `extern var` entity IDs or user-defined types with
    /// `flecs_trivial == true`.
    global_entity,
};

/// Return the base type of an optional/pointer chain.
fn BaseType(comptime T: type) type {
    return switch (@typeInfo(T)) {
        .Optional => |optional| BaseType(optional.child),
        .Pointer => |pointer| BaseType(pointer.child),
        else => T,
    };
}

/// Given a pointer type, strip all `const`/`volatile`/etc. modifiers.
/// Given an optional type, return the non-null payload type.
///
/// Useful to assign the same entity ID for differing pointer types that have
/// the same representation.
///
/// Example:
///  - `*T` == `*const T` == `*volatile T` == `?*T` == `[*]T` == `[*:x]T`
///  - `[]T` == `[]const T` == `[]volatile T` == `?[]T` == `[:x]T`
fn CanonicalizePointer(comptime T: type) type {
    return comptime switch (@typeInfo(T)) {
        .Optional => |optional| CanonicalizePointer(optional.child),
        .Pointer => |pointer| switch (pointer.size) {
            .One, .Many, .C => *CanonicalizePointer(pointer.child),
            .Slice => []CanonicalizePointer(pointer.child),
        },
        else => T,
    };
}

/// Memomize an unsplit name given `prefix` and `suffix`.
///
/// If prefix is an empty string, `suffix` is returned directly. In all other
/// cases, the contents of the string are turned into array values and the
/// function recurses to ensure that the resulting string does not depend on the
/// pointer address of the input strings.
///
/// Example:
///  - `unsplitName("abc.", "xyz")` == `"abc.xyz"`
///  - `unsplitName("", "xyz")` == `"xyz"`
fn unsplitName(
    comptime prefix: anytype,
    comptime suffix: anytype,
) [:0]const u8 {
    if (prefix.len == 0) {
        if (@TypeOf(prefix) != [0]u8) {
            return struct {
                const result = unsplitName([_]u8{}, suffix);
            }.result;
        }
        switch (@typeInfo(@TypeOf(suffix))) {
            .Array => return &suffix,
            .Pointer => return suffix,
            else => comptime unreachable,
        }
    }

    switch (@typeInfo(@TypeOf(prefix))) {
        .Array => switch (@TypeOf(prefix)) {
            [prefix.len]u8 => {},
            [prefix.len:0]u8 => return struct {
                const result = unsplitName(
                    @as([prefix.len]u8, prefix),
                    suffix,
                );
            }.result,
            else => comptime unreachable,
        },
        .Pointer => return struct {
            const result = unsplitName(prefix[0..prefix.len].*, suffix);
        }.result,
        else => comptime unreachable,
    }

    switch (@typeInfo(@TypeOf(suffix))) {
        .Array => switch (@TypeOf(suffix)) {
            [suffix.len:0]u8 => {},
            [suffix.len]u8 => return struct {
                const result = blk: {
                    var buf = ([_]u8{ undefined } ** suffix.len) ++ [_]u8{ 0 };
                    buf[0..suffix.len].* = suffix;
                    break :blk unsplitName(prefix, buf[0..suffix.len :0].*);
                };
            }.result,
            else => comptime unreachable,
        },
        .Pointer => return struct {
            const result = unsplitName(prefix, suffix[0..suffix.len].*);
        }.result,
        else => comptime unreachable,
    }

    comptime std.debug.assert(@TypeOf(prefix) == [prefix.len]u8);
    comptime std.debug.assert(@TypeOf(suffix) == [suffix.len:0]u8);

    return struct {
        const result = blk: {
            var buf = ([_]u8{ undefined } ** (prefix.len + suffix.len)) ++ [_]u8{ 0 };
            buf[0..prefix.len].* = prefix;
            buf[prefix.len..(buf.len - 1)].* = suffix;
            break :blk unsplitName([_]u8{}, ("" ++ buf[0..(buf.len - 1) :0]).*);
        };
    }.result;
}

/// Generate a name for the type based on the base type's name configuration and
/// type info (namely, whether the type `T` is equal to base type or is a pointer
/// to the base type).
fn generatedName(
    comptime T: type,
    comptime name_config: EntityTypeMeta.NameConfig,
) ?[:0]const u8 {
    if (T != CanonicalizePointer(T)) return comptime generatedName(
        CanonicalizePointer(T),
        name_config,
    );
    return struct {
        const result = switch (@typeInfo(T)) {
            .Optional, .Pointer => switch (name_config) {
                .auto => blk: {
                    const base_type_name = @typeName(BaseType(T));
                    if (std.mem.endsWith(u8, base_type_name, ")")) {
                        break :blk null;
                    }
                    const split_name = splitName(base_type_name);
                    break :blk unsplitName(
                        split_name[0],
                        generatedSuffix(T, split_name[1]),
                    );
                },
                .override => |name| blk: {
                    const split_name = splitName(name);
                    break :blk unsplitName(
                        split_name[0],
                        generatedSuffix(T, split_name[1]),
                    );
                },
                .override_split => |split_name| unsplitName(
                    split_name[0],
                    generatedSuffix(T, split_name[1]),
                ),
                .disable => null,
            },
            else => switch (name_config) {
                .auto => @typeName(T),
                .override => |name| name,
                .override_split => |split_name| unsplitName(
                    split_name[0],
                    split_name[1],
                ),
                .disable => null,
            },
        };
    }.result;
}

/// For pointer types, prefix the unqualified name with `*` and `[]` as appropriate
/// to distinguish their name from the base type.
///
/// Example:
///  - `generatedSuffix(*Foo, "Foo")` == `"*Foo"`
///  - `generatedSuffix([]Foo, "Foo")` == `"[]Foo"`
///  - `generatedSuffix([][]Foo, "Foo")` == `"[][]Foo"`
fn generatedSuffix(
    comptime T: type,
    comptime suffix: [:0]const u8,
) [:0]const u8 {
    if (T != CanonicalizePointer(T)) return comptime generatedSuffix(T, suffix);
    return struct {
        const result = switch (@typeInfo(T)) {
            .Optional => |optional| generatedSuffix(optional.child, suffix),
            .Pointer => |pointer| switch (pointer.size) {
                .One, .Many, .C => "*" ++ generatedSuffix(pointer.child, suffix),
                .Slice => "[]" ++ generatedSuffix(pointer.child, suffix),
            },
            else => suffix,
        };
    }.result;
}

/// Given a qualified type name, return the `OverrideSplit` variant for it.
fn splitName(comptime qualified_name: [:0]const u8) EntityTypeMeta.NameConfig.OverrideSplit {
    return struct {
        const result = blk: {
            if (!std.mem.endsWith(u8, qualified_name, ")")) {
                if (std.mem.lastIndexOfScalar(u8, qualified_name, '.')) |last_separator| {
                    break :blk .{
                        qualified_name[0..(last_separator + 1)],
                        qualified_name[(last_separator + 1).. :0],
                    };
                }
            }
            break :blk .{ "", qualified_name };
        };
    }.result;
}

/// Extract the type meta for a type `T` if the type or type being pointed to
/// contains a `flecs_meta` declaration.
fn typeMeta(comptime T: type) EntityTypeMeta {
    if (T != BaseType(T)) return comptime typeMeta(BaseType(T));
    if (!@hasDecl(T, "flecs_meta")) return .{};

    const ValueType = @TypeOf(T.flecs_meta);
    if (ValueType == EntityTypeMeta) return T.flecs_meta;

    return struct {
        const value = blk: {
            var result: EntityTypeMeta = .{};

            const field_names = std.meta.fieldNames(ValueType);
            const FieldEnum = std.meta.FieldEnum(EntityTypeMeta);
            inline for (field_names) |field_name| {
                const field = @field(FieldEnum, field_name);
                switch (field) {
                    .name, .symbol => {
                        const FieldType = @TypeOf(@field(T.flecs_meta, field_name));
                        switch (@typeInfo(FieldType)) {
                            .Struct => |struct_info| {
                                if (struct_info.is_tuple) {
                                    @field(result, field_name) = .{
                                        .override_split = @field(T.flecs_meta, field_name),
                                    };
                                } else {
                                    @field(result, field_name) = @field(T.flecs_meta, field_name);
                                }
                            },
                            .Union, .Enum, .EnumLiteral => {
                                @field(result, field_name) = @field(T.flecs_meta, field_name);
                            },
                            .Pointer => {
                                @field(result, field_name) = .{
                                    .override = @field(T.flecs_meta, field_name),
                                };
                            },
                            .Optional => |optional_info| switch (@typeInfo(optional_info.child)) {
                                .Struct, .Union, .Enum, .EnumLiteral => {
                                    if (@field(T.flecs_meta, field_name)) |field_value| {
                                        @field(result, field_name) = field_value;
                                    } else {
                                        @field(result, field_name) = .disable;
                                    }
                                },
                                .Pointer => {
                                    if (@field(T.flecs_meta, field_name)) |field_value| {
                                        @field(result, field_name) = .{
                                            .override = field_value,
                                        };
                                    } else {
                                        @field(result, field_name) = .disable;
                                    }
                                },
                            else => unreachable,
                            },
                            .Null => {
                                @field(result, field_name) = .disable;
                            },
                            else => unreachable,
                        }
                    },
                    .intended_use, .pointer_only => {
                        @field(result, field_name) = @field(T.flecs_meta, field_name);
                    },
                }
            }

            break :blk result;
        };
    }.value;
}

const StorageInfo = struct {
    name: ?[:0]const u8 = null,
    symbol: ?[:0]const u8 = null,
    extern_decl: ?ExternDecl = null,
    intended_use: IntendedUse = .any,

    fn of(comptime T: type) StorageInfo {
        return comptime ret: {
            // Special casing: some entities are renamed to avoid collisions,
            // and others simply do not follow the expected naming convention.
            if (@as(?ExternDecl, switch (T) {
                flecs.QueryTag => .EcsQuery,
                flecs.ObserverTag => .EcsObserver,
                flecs.SystemTag => .EcsSystem,
                flecs.WorldEntity => .EcsWorld,

                // `FLECS_MONITOR` addon.
                flecs.FlecsMonitor => .FLECS__EFlecsMonitor,

                // `FLECS_METRICS` addon.
                flecs.FlecsMetrics => .FLECS__EFlecsMetrics,

                // `FLECS_META` addon.
                Id => .FLECS__Eecs_entity_t,
                flecs.bool => .FLECS__Eecs_bool_t,
                flecs.char => .FLECS__Eecs_char_t,
                flecs.byte => .FLECS__Eecs_byte_t,
                flecs.string => .FLECS__Eecs_string_t,
                flecs.u8 => .FLECS__Eecs_u8_t,
                flecs.u16 => .FLECS_Eecs_u16_t,
                flecs.u32 => .FLECS_Eecs_u32_t,
                flecs.u64 => .FLECS_Eecs_u64_t,
                flecs.uptr => .FLECS_Eecs_uptr_t,
                flecs.i8 => .FLECS__Eecs_i8_t,
                flecs.i16 => .FLECS_Eecs_i16_t,
                flecs.i32 => .FLECS_Eecs_i32_t,
                flecs.i64 => .FLECS_Eecs_i64_t,
                flecs.iptr => .FLECS_Eecs_iptr_t,
                flecs.f32 => .FLECS_Eecs_f32_t,
                flecs.f64 => .FLECS_Eecs_f64_t,

                else => null,
            })) |special_extern_decl| {
                break :ret .{
                    .extern_decl = special_extern_decl,
                    .intended_use = .none,
                };
            }

            // Determine the type name and unqualified identifier of this type.
            const type_name: [:0]const u8 = @typeName(BaseType(T));
            const base_name: ?[:0]const u8 = blk: {
                // Avoid returning `.Foo)` given `Generic(x.Foo)`.
                if (std.mem.endsWith(u8, type_name, ")")) {
                    break :blk null;
                }

                // Return everything after the last separator, if any.
                if (std.mem.lastIndexOfScalar(u8, type_name, '.')) |last_separator| {
                    break :blk type_name[(last_separator + 1).. :0];
                }
                break :blk type_name;
            };

            // Check for membership in the `entities` or `c` namespaces, then
            // guess the corresponding declaration name.
            if (base_name) |base_name_| blk: {
                if (@hasDecl(flecs.entities, base_name_)) {
                    if (@field(flecs.entities, base_name_) != T) {
                        break :blk;
                    }

                    const ecs_base_name: [:0]const u8 = "Ecs" ++ base_name_;
                    const extern_decl = if (@hasDecl(c, ecs_base_name))
                        @field(ExternDecl, ecs_base_name)
                    else
                        @field(ExternDecl, "FLECS__E" ++ ecs_base_name);

                    break :ret .{
                        .name = ecs_base_name,
                        .extern_decl = extern_decl,
                        .intended_use = .none,
                    };
                }

                if (@hasDecl(c, base_name_) and @TypeOf(@field(c, base_name_)) == type) {
                    if (@field(c, base_name_) != T) {
                        break :blk;
                    }

                    break :ret .{
                        .name = base_name_,
                        .extern_decl = @field(ExternDecl, "FLECS__E" ++ base_name_),
                        .intended_use = switch (T) {
                            flecs.WorldStats,
                            flecs.PipelineStats,
                            flecs.Script,
                            => .component,

                            else => .none,
                        },
                    };
                }
            }

            // Collect user configuration for name, symbol, and intended use.
            const type_meta = typeMeta(T);

            // Ensure that we are not using the base type for a pointer-only type.
            if (type_meta.pointer_only and T == BaseType(T)) {
                @compileError("Component " ++ @typeName(T) ++ " is configured to be pointer-only");
            }

            // Determine the type used to generate the component name.
            const NameT = if (type_meta.pointer_only and T == *BaseType(T))
                BaseType(T)
            else
                T;

            // Use the user-configured name or generate one automatically.
            const configured_name: ?[:0]const u8 = generatedName(
                NameT,
                type_meta.name,
            );

            // Use the user-configured symbol, if any.
            const configured_symbol: ?[:0]const u8 = generatedName(
                NameT,
                type_meta.symbol,
            );

            // Account for the user-configured intended use, if any.
            const intended_use: IntendedUse = switch (type_meta.intended_use) {
                .any => .any,
                .component => .component,
                .global_entity => .global_entity,
            };

            break :ret .{
                .name = configured_name,
                .symbol = configured_symbol,
                .intended_use = intended_use,
            };
        };
    }
};

/// Interface used in test builds to invalidate entity IDs between tests.
pub const id_tracker = struct {
    /// Incremented when tests call `flecs.testing.reset()`.
    var reset_count: u64 = 0;

    /// Called by `flecs.testing.reset()` to increment the `reset_count` variable
    /// and reset certain builtin entities that have dynamically assigned IDs.
    pub fn reset() void {
        reset_count += 1;

        if (enabled_addons.monitor) {
            c.EcsPeriod1s = 0;
            c.EcsPeriod1m = 0;
            c.EcsPeriod1h = 0;
            c.EcsPeriod1d = 0;
            c.EcsPeriod1w = 0;

            c.FLECS__EFlecsMonitor = 0;

            c.FLECS__EEcsWorldStats = 0;
            c.FLECS__EEcsPipelineStats = 0;
        }

        if (enabled_addons.plecs) {
            c.FLECS__EEcsScript = 0;
        }
    }
};

/// Make sure components are user-defined or wrappers of builtin components.
///
/// The goal of this function is to prevent mistakes like using primitive types
/// as components, as unlike with the Flecs C API we cannot create separate IDs
/// for the same primitive type. For instance, `ecs_u8_t` would be indistinguishable
/// from `ecs_char_t` if the component ID was associated with `u8`.
///
/// Additionally, arrays are forbidden because it could easily cause unexpected
/// mistakes due to slightly differing length or sentinel. User-defined types that
/// wrap an array value should be used instead.
fn validateGlobalEntityType(comptime T: type) void {
    _ = struct {
        const result = switch (@typeInfo(T)) {
            .Struct, .Union, .Enum => {},

            .Type, .Void, .NoReturn, .Array, .ComptimeFloat, .ComptimeInt,
            .Undefined, .Null, .ErrorUnion, .ErrorSet, .Fn, .Opaque, .Frame,
            .AnyFrame, .Vector, .EnumLiteral => @compileError(
                "Cannot use " ++ @typeName(T) ++ " as a component",
            ),

            .Bool => @compileError(
                "Cannot use bool as a component: try flecs.bool",
            ),

            .Int, .Float => switch (T) {
                u8 => @compileError(
                    "Cannot use u8 as a component: try flecs.char, flecs.byte, or flecs.u8",
                ),
                c_char => @compileError(
                    "Cannot use c_char as a component: try flecs.char",
                ),
                usize => @compileError(
                    "Cannot use usize as a component: try flecs.uptr",
                ),
                isize => @compileError(
                    "Cannot use isize as a component: try flecs.iptr",
                ),
                u16, u32, u64, i8, i16, i32, i64, f32, f64 => @compileError(
                    "Cannot use " ++ @typeName(T) ++ " as a component: try flecs." ++ @typeName(T),
                ),
                else => @compileError(
                    "Cannot use " ++ @typeName(T) ++ " as a component",
                ),
            },

            .Optional => |optional| {
                switch (@typeInfo(optional.child)) {
                    .Pointer => {
                        // Forbid `?[*c]T` and `?*allowzero T`.
                        if (@sizeOf(T) != @sizeOf(optional.child)) {
                            @compileError(
                                "Cannot use " ++ @typeName(T) ++ " as a component: representation is incompatible with non-optional pointer",
                            );
                        }
                        validateGlobalEntityType(optional.child);
                    },
                    else => @compileError(
                        "Cannot use " ++ @typeName(T) ++ " as a component",
                    ),
                }
            },

            .Pointer => |ptr| {
                const Child = ptr.child;
                const child_info = @typeInfo(Child);
                if (
                    (ptr.size != .One and Child == u8) or
                        (ptr.size == .One and child_info == .Array and child_info.Array.child == u8)
                ) @compileError(
                    "Cannot use " ++ @typeName(T) ++ " as a component: try flecs.string",
                );
                if (ptr.child == anyopaque) {
                    @compileError("Cannot use " ++ @typeName(T) ++ " as a component");
                }
                if (@typeInfo(ptr.child) != .Opaque) {
                    validateGlobalEntityType(ptr.child);
                }
            },
        };
    }.result;
}

test "component pointer equivalence" {
    const Foo = extern struct { u8 = 0 };
    const foo = Foo{};

    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(*const Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(*volatile Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(*allowzero Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(*align(4) Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage([*]Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage([*:foo]Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage([*c]Foo));

    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(?*Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(?*const Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(?*volatile Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(?*align(4) Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(?[*]Foo));
    try std.testing.expectEqual(IdStorage(*Foo), IdStorage(?[*:foo]Foo));

    try std.testing.expect(IdStorage(*Foo) != IdStorage(**Foo));
    try std.testing.expectEqual(IdStorage(**Foo), IdStorage(*const *Foo));
    try std.testing.expectEqual(IdStorage(**Foo), IdStorage(**const Foo));
    try std.testing.expectEqual(IdStorage(**Foo), IdStorage(*const *const Foo));

    try std.testing.expect(IdStorage(*Foo) != IdStorage([]Foo));
    try std.testing.expectEqual(IdStorage([]Foo), IdStorage([]const Foo));
    try std.testing.expectEqual(IdStorage([]Foo), IdStorage([]volatile Foo));
    try std.testing.expectEqual(IdStorage([]Foo), IdStorage([]allowzero Foo));
    try std.testing.expectEqual(IdStorage([]Foo), IdStorage([:foo]Foo));

    try std.testing.expectEqual(IdStorage([]Foo), IdStorage(?[]Foo));
    try std.testing.expectEqual(IdStorage([]Foo), IdStorage(?[]const Foo));
    try std.testing.expectEqual(IdStorage([]Foo), IdStorage(?[]volatile Foo));
    try std.testing.expectEqual(IdStorage([]Foo), IdStorage(?[:foo]Foo));

    try std.testing.expect(IdStorage(*Foo) != IdStorage(*[]Foo));
    try std.testing.expect(IdStorage(*Foo) != IdStorage([]*Foo));
    try std.testing.expect(IdStorage(*Foo) != IdStorage([][]Foo));

    try std.testing.expect(IdStorage(**Foo) != IdStorage(*[]Foo));
    try std.testing.expect(IdStorage(**Foo) != IdStorage([]*Foo));
    try std.testing.expect(IdStorage(**Foo) != IdStorage([][]Foo));

    try std.testing.expect(IdStorage([]Foo) != IdStorage(**Foo));
    try std.testing.expect(IdStorage([]Foo) != IdStorage(*[]Foo));
    try std.testing.expect(IdStorage([]Foo) != IdStorage([]*Foo));
    try std.testing.expect(IdStorage([]Foo) != IdStorage([][]Foo));

    try std.testing.expectEqual(IdStorage([]*Foo), IdStorage([]const *Foo));
    try std.testing.expectEqual(IdStorage([]*Foo), IdStorage([]*const Foo));
    try std.testing.expectEqual(IdStorage([]*Foo), IdStorage([]const *const Foo));

    try std.testing.expectEqual(IdStorage([]*Foo), IdStorage(?[]*Foo));
    try std.testing.expectEqual(IdStorage([]*Foo), IdStorage([]?*Foo));
    try std.testing.expectEqual(IdStorage([]*Foo), IdStorage(?[]?*Foo));

    try std.testing.expectEqual(IdStorage(*[]Foo), IdStorage(*const []Foo));
    try std.testing.expectEqual(IdStorage(*[]Foo), IdStorage(*[]const Foo));
    try std.testing.expectEqual(IdStorage(*[]Foo), IdStorage(*const []const Foo));

    try std.testing.expectEqual(IdStorage(*[]Foo), IdStorage(?*[]Foo));
    try std.testing.expectEqual(IdStorage(*[]Foo), IdStorage(*?[]Foo));
    try std.testing.expectEqual(IdStorage(*[]Foo), IdStorage(?*?[]Foo));

    try std.testing.expectEqual(IdStorage([][]Foo), IdStorage([]const []Foo));
    try std.testing.expectEqual(IdStorage([][]Foo), IdStorage([][]const Foo));
    try std.testing.expectEqual(IdStorage([][]Foo), IdStorage([]const []const Foo));

    try std.testing.expectEqual(IdStorage([][]Foo), IdStorage(?[][]Foo));
    try std.testing.expectEqual(IdStorage([][]Foo), IdStorage([]?[]Foo));
    try std.testing.expectEqual(IdStorage([][]Foo), IdStorage(?[]?[]Foo));
}

fn expectEqualOptionalStrings(expected: ?[]const u8, actual: ?[]const u8) !void {
    if (expected == null) return std.testing.expect(actual == null);
    if (expected != null) return std.testing.expect(actual != null);
    return std.testing.expectEqualStrings(expected.?, actual.?);
}

test "component name generation" {
    const A = struct {
        pub const flecs_meta = .{
            .name = "A",
        };
    };

    try expectEqualOptionalStrings("A", IdStorage(A).name);
    try expectEqualOptionalStrings("*A", IdStorage(*A).name);
    try expectEqualOptionalStrings("[]A", IdStorage([]A).name);
    try expectEqualOptionalStrings("**A", IdStorage(**A).name);
    try expectEqualOptionalStrings("[]*A", IdStorage([]*A).name);
    try expectEqualOptionalStrings("*[]A", IdStorage(*[]A).name);
    try expectEqualOptionalStrings("[][]A", IdStorage([][]A).name);

    try expectEqualOptionalStrings(null, IdStorage(A).symbol);
    try expectEqualOptionalStrings(null, IdStorage(*A).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]A).symbol);
    try expectEqualOptionalStrings(null, IdStorage(**A).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]*A).symbol);
    try expectEqualOptionalStrings(null, IdStorage(*[]A).symbol);
    try expectEqualOptionalStrings(null, IdStorage([][]A).symbol);

    const B = struct {
        pub const flecs_meta = .{
            .name = "component_name_test.B",
        };
    };

    try expectEqualOptionalStrings("component_name_test.B", IdStorage(B).name);

    try expectEqualOptionalStrings("component_name_test.*B", IdStorage(*B).name);
    try expectEqualOptionalStrings("component_name_test.[]B", IdStorage([]B).name);
    try expectEqualOptionalStrings("component_name_test.**B", IdStorage(**B).name);
    try expectEqualOptionalStrings("component_name_test.[]*B", IdStorage([]*B).name);
    try expectEqualOptionalStrings("component_name_test.*[]B", IdStorage(*[]B).name);
    try expectEqualOptionalStrings("component_name_test.[][]B", IdStorage([][]B).name);

    try expectEqualOptionalStrings(null, IdStorage(B).symbol);
    try expectEqualOptionalStrings(null, IdStorage(*B).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]B).symbol);
    try expectEqualOptionalStrings(null, IdStorage(**B).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]*B).symbol);
    try expectEqualOptionalStrings(null, IdStorage(*[]B).symbol);
    try expectEqualOptionalStrings(null, IdStorage([][]B).symbol);

    const C = struct {
        pub const flecs_meta = .{
            .name = .{ "component_name_test.", "C" },
        };
    };

    try expectEqualOptionalStrings("component_name_test.C", IdStorage(C).name);
    try expectEqualOptionalStrings("component_name_test.*C", IdStorage(*C).name);
    try expectEqualOptionalStrings("component_name_test.[]C", IdStorage([]C).name);
    try expectEqualOptionalStrings("component_name_test.**C", IdStorage(**C).name);
    try expectEqualOptionalStrings("component_name_test.[]*C", IdStorage([]*C).name);
    try expectEqualOptionalStrings("component_name_test.*[]C", IdStorage(*[]C).name);
    try expectEqualOptionalStrings("component_name_test.[][]C", IdStorage([][]C).name);

    try expectEqualOptionalStrings(null, IdStorage(C).symbol);
    try expectEqualOptionalStrings(null, IdStorage(*C).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]C).symbol);
    try expectEqualOptionalStrings(null, IdStorage(**C).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]*C).symbol);
    try expectEqualOptionalStrings(null, IdStorage(*[]C).symbol);
    try expectEqualOptionalStrings(null, IdStorage([][]C).symbol);

    const D = struct {
        pub const flecs_meta = .{
            .name = "component_name_test.D",
            .pointer_only = true,
        };
    };

    try expectEqualOptionalStrings("component_name_test.D", IdStorage(*D).name);
    try expectEqualOptionalStrings("component_name_test.[]D", IdStorage([]D).name);
    try expectEqualOptionalStrings("component_name_test.**D", IdStorage(**D).name);
    try expectEqualOptionalStrings("component_name_test.[]*D", IdStorage([]*D).name);
    try expectEqualOptionalStrings("component_name_test.*[]D", IdStorage(*[]D).name);
    try expectEqualOptionalStrings("component_name_test.[][]D", IdStorage([][]D).name);

    try expectEqualOptionalStrings(null, IdStorage(*D).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]D).symbol);
    try expectEqualOptionalStrings(null, IdStorage(**D).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]*D).symbol);
    try expectEqualOptionalStrings(null, IdStorage(*[]D).symbol);
    try expectEqualOptionalStrings(null, IdStorage([][]D).symbol);

    const E = struct {
        pub const flecs_meta = .{
            .symbol = "E",
        };
    };

    try expectEqualOptionalStrings(@typeName(E), IdStorage(E).name);

    try expectEqualOptionalStrings("E", IdStorage(E).symbol);
    try expectEqualOptionalStrings("*E", IdStorage(*E).symbol);
    try expectEqualOptionalStrings("[]E", IdStorage([]E).symbol);
    try expectEqualOptionalStrings("**E", IdStorage(**E).symbol);
    try expectEqualOptionalStrings("[]*E", IdStorage([]*E).symbol);
    try expectEqualOptionalStrings("*[]E", IdStorage(*[]E).symbol);
    try expectEqualOptionalStrings("[][]E", IdStorage([][]E).symbol);

    const F = struct {
        pub const flecs_meta = .{
            .name = "component_name_test.F",
            .symbol = "component_name_foo.F",
        };
    };

    try expectEqualOptionalStrings("component_name_test.F", IdStorage(F).name);
    try expectEqualOptionalStrings("component_name_test.*F", IdStorage(*F).name);
    try expectEqualOptionalStrings("component_name_test.[]F", IdStorage([]F).name);
    try expectEqualOptionalStrings("component_name_test.**F", IdStorage(**F).name);
    try expectEqualOptionalStrings("component_name_test.[]*F", IdStorage([]*F).name);
    try expectEqualOptionalStrings("component_name_test.*[]F", IdStorage(*[]F).name);
    try expectEqualOptionalStrings("component_name_test.[][]F", IdStorage([][]F).name);

    try expectEqualOptionalStrings("component_name_foo.F", IdStorage(F).symbol);
    try expectEqualOptionalStrings("component_name_foo.*F", IdStorage(*F).symbol);
    try expectEqualOptionalStrings("component_name_foo.[]F", IdStorage([]F).symbol);
    try expectEqualOptionalStrings("component_name_foo.**F", IdStorage(**F).symbol);
    try expectEqualOptionalStrings("component_name_foo.[]*F", IdStorage([]*F).symbol);
    try expectEqualOptionalStrings("component_name_foo.*[]F", IdStorage(*[]F).symbol);
    try expectEqualOptionalStrings("component_name_foo.[][]F", IdStorage([][]F).symbol);

    const G = struct {
        pub const flecs_meta = .{
            .name = "component_name_test.G",
            .symbol = "component_name_foo.G",
            .pointer_only = true,
        };
    };

    try expectEqualOptionalStrings("component_name_test.G", IdStorage(*G).name);
    try expectEqualOptionalStrings("component_name_test.[]G", IdStorage([]G).name);
    try expectEqualOptionalStrings("component_name_test.**G", IdStorage(**G).name);
    try expectEqualOptionalStrings("component_name_test.[]*G", IdStorage([]*G).name);
    try expectEqualOptionalStrings("component_name_test.*[]G", IdStorage(*[]G).name);
    try expectEqualOptionalStrings("component_name_test.[][]G", IdStorage([][]G).name);

    try expectEqualOptionalStrings("component_name_foo.G", IdStorage(*G).symbol);
    try expectEqualOptionalStrings("component_name_foo.[]G", IdStorage([]G).symbol);
    try expectEqualOptionalStrings("component_name_foo.**G", IdStorage(**G).symbol);
    try expectEqualOptionalStrings("component_name_foo.[]*G", IdStorage([]*G).symbol);
    try expectEqualOptionalStrings("component_name_foo.*[]G", IdStorage(*[]G).symbol);
    try expectEqualOptionalStrings("component_name_foo.[][]G", IdStorage([][]G).symbol);

    const H = struct {
        pub const flecs_meta = .{
            .name = .disable,
        };
    };

    try expectEqualOptionalStrings(null, IdStorage(H).name);
    try expectEqualOptionalStrings(null, IdStorage(*H).name);
    try expectEqualOptionalStrings(null, IdStorage([]H).name);
    try expectEqualOptionalStrings(null, IdStorage(**H).name);
    try expectEqualOptionalStrings(null, IdStorage([]*H).name);
    try expectEqualOptionalStrings(null, IdStorage(*[]H).name);
    try expectEqualOptionalStrings(null, IdStorage([][]H).name);

    try expectEqualOptionalStrings(null, IdStorage(H).symbol);
    try expectEqualOptionalStrings(null, IdStorage(*H).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]H).symbol);
    try expectEqualOptionalStrings(null, IdStorage(**H).symbol);
    try expectEqualOptionalStrings(null, IdStorage([]*H).symbol);
    try expectEqualOptionalStrings(null, IdStorage(*[]H).symbol);
    try expectEqualOptionalStrings(null, IdStorage([][]H).symbol);

    const I = struct {
        pub const flecs_meta = .{
            .name = .{ .override = "component_name_test.I" },
            .symbol = .{ .override_split = .{ "component_name_foo.", "I" } },
        };
    };

    try expectEqualOptionalStrings("component_name_test.I", IdStorage(I).name);
    try expectEqualOptionalStrings("component_name_test.*I", IdStorage(*I).name);
    try expectEqualOptionalStrings("component_name_test.[]I", IdStorage([]I).name);
    try expectEqualOptionalStrings("component_name_test.**I", IdStorage(**I).name);
    try expectEqualOptionalStrings("component_name_test.[]*I", IdStorage([]*I).name);
    try expectEqualOptionalStrings("component_name_test.*[]I", IdStorage(*[]I).name);
    try expectEqualOptionalStrings("component_name_test.[][]I", IdStorage([][]I).name);

    try expectEqualOptionalStrings("component_name_foo.I", IdStorage(I).symbol);
    try expectEqualOptionalStrings("component_name_foo.*I", IdStorage(*I).symbol);
    try expectEqualOptionalStrings("component_name_foo.[]I", IdStorage([]I).symbol);
    try expectEqualOptionalStrings("component_name_foo.**I", IdStorage(**I).symbol);
    try expectEqualOptionalStrings("component_name_foo.[]*I", IdStorage([]*I).symbol);
    try expectEqualOptionalStrings("component_name_foo.*[]I", IdStorage(*[]I).symbol);
    try expectEqualOptionalStrings("component_name_foo.[][]I", IdStorage([][]I).symbol);
}
