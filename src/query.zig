const std = @import("std");

const StructField = std.builtin.Type.StructField;
const ArgsTuple = std.meta.ArgsTuple;
const isSingleItemPtr = std.meta.trait.isSingleItemPtr;

const flecs = @import("lzflecs.zig");
const World = flecs.World;
const c = flecs.c;

/// Populate a slice with bools for each iterator term in `[1..(is_shared.len + 1)]`.
/// Useful to determine whether a term in an instanced iterator is multi-item or
/// single-item.
///
/// Each item in `is_shared` is set to the value of `!ecs_iter_is_self(it, index + 1)`.
/// The return value indicates whether any of the indices are actually shared.
fn populateIsShared(it: *const c.ecs_iter_t, is_shared: []bool) bool {
    std.debug.assert(it.field_count > @intCast(i32, is_shared.len));

    var any_shared = false;
    var index: u31 = 1;
    for (is_shared) |*out| {
        defer index += 1;
        out.* = !c.ecs_field_is_self(it, index);
        any_shared = any_shared or out.*;
    }
    return any_shared;
}

fn readSingleItem(
    it: *const c.ecs_iter_t,
    comptime ColumnT: type,
    comptime MatchT: type,
    field_index: usize,
    item_index: usize,
) MatchT {
    std.debug.assert(it.field_count > @intCast(i32, field_index));
    std.debug.assert(item_index == 0 or it.count > @intCast(i32, item_index));
    const Ptr = ColumnPtr(ColumnT);
    
    _ = Ptr;
}

fn validateSingleItemColumnMatch(comptime ColumnT: type, comptime MatchT: type) void {
    comptime validateColumnMatch(ColumnT, MatchT);
    switch (@typeInfo(MatchT)) {
        .Pointer => |pointer| switch (pointer.size) {
            .One, .C => {},
            .Many, .Slice => @compileError(
                "Invalid use of multi-item pointer " ++ @typeName(MatchT) ++
                " during single-item iteration",
            ),
        },
        .Optional => |optional| switch (@typeInfo(optional.child)) {
            .Pointer => |pointer| switch (pointer.size) {
                .One => {},
                .C => comptime unreachable,
                .Many, .Slice => @compileError(
                    "Invalid use of multi-item pointer" ++ @typeName(MatchT) ++
                    " during single-item iteration",
                ),
            },
            else => {},
        },
        else => {},
    }
}

fn validateColumnMatch(comptime ColumnT: type, comptime MatchT: type) void {
    // Allow matching on component/relationship IDs.
    if (MatchT == flecs.Id or MatchT == ?flecs.Id) return;

    // If the column is actually a virtual `PairMarker` component, use its
    // validator function instead.
    if (comptime isPairMarker(ColumnT)) {
        return comptime ColumnT.validatePairMatch(MatchT);
    }

    // Allow types to be matched by value.
    if (MatchT == ColumnT or MatchT == ?ColumnT) return;

    switch (@typeInfo(MatchT)) {
        // Opt out of capturing the component value.
        .Void => {},

        // Do not capture the component value; only detect whether the column is
        // present or not.
        .Bool => {},

        // Accept pointers to `ColumnT`.
        .Pointer => |pointer| if (pointer.child != ColumnT) @compileError(
            "Cannot match " ++ @typeName(ColumnT) ++ " with " ++
            @typeName(MatchT) ++ "; use a matching pointer type or ignore value with void",
        ) else if (pointer.sentinel != null) @compileError(
            "Cannot match " ++ @typeName(ColumnT) ++ " with " ++
            @typeName(MatchT) ++ "; remove sentinel from the pointer type",
        ),

        // Capture the component value if present; otherwise, pass `null` to
        // the iteration callback.
        .Optional => |optional| switch (@typeInfo(optional.child)) {
            // Opt out of capturing the component value, but retain ability to
            // detect whether the component was actually set.
            .Void => {},

            // `?bool` has three states but only two states would actually be
            // used, so `?void` or `bool` is more appropriate.
            .Bool => @compileError(
                "Cannot match " ++ @typeName(ColumnT) ++ " with ?bool; use bool or ?void",
            ),

            // Accept optional pointers to `ColumnT`.
            .Pointer => |pointer| {
                comptime std.debug.assert(pointer.size != .C);
                comptime validateColumnMatch(ColumnT, optional.child);
            },

            // Cannot match `MatchT` to `ColumnT`.
            else => @compileError(
                "Cannot match " ++ @typeName(ColumnT) ++ " with " ++
                @typeName(MatchT) ++ "; use a matching pointer type or ignore value with void",
            ),
        },

        // Cannot match `MatchT` to `ColumnT`.
        else => @compileError(
            "Cannot match " ++ @typeName(ColumnT) ++ " with " ++
            @typeName(MatchT) ++ "; use a matching pointer type or ignore value with void",
        ),
    }
}

/// Return whether the type is a `PairMarker` by detecting whether we can access
/// the private declaration `validatePairMatch`.
fn isPairMarker(comptime T: type) bool {
    return comptime switch (@typeInfo(T)) {
        .Struct => |info| (
            @hasDecl(T, "validatePairMatch") and
            @hasDecl(T, "First") and
            @hasDecl(T, "Second") and
            info.decls.len == 7 and
            !info.decls[6].is_pub and
            std.mem.eql(u8, "validatePairMatch", info.decls[6].name) and
            T == PairMarker(T.First, T.Second)
        ),
        else => false,
    };
}

fn PairMarker(comptime First_: type, comptime Second_: type) type {
    return struct {
        pub const First = First_;
        pub const Second = Second_;

        const FirstBase = switch (@typeInfo(First)) {
            .Pointer => |pointer| pointer.child,
            .Optional => |optional| @typeInfo(optional.child).Pointer.child,
            else => First,
        };

        const SecondBase = switch (@typeInfo(Second)) {
            .Pointer => |pointer| pointer.child,
            .Optional => |optional| @typeInfo(optional.child).Pointer.child,
            else => Second,
        };

        const allow_first_by_value = switch (@typeInfo(First)) {
            .Pointer, .Optional, .Opaque => false,
            else => true,
        } and switch (@typeInfo(Second)) {
            .Pointer, .Optional => FirstBase != SecondBase,
            else => true,
        };

        const allow_second_by_value = switch (@typeInfo(Second)) {
            .Pointer, .Optional, .Opaque => false,
            else => true,
        } and switch (@typeInfo(First)) {
            .Pointer, .Optional => SecondBase != FirstBase,
            else => true,
        };

        fn validatePairMatch(comptime MatchT: type) void {
            // Allow types to be matched by value.
            if (allow_first_by_value and (MatchT == FirstBase or MatchT == ?FirstBase)) {
                return comptime validatePairMatch(*FirstBase);
            }
            if (allow_second_by_value and (MatchT == SecondBase or MatchT == ?SecondBase)) {
                return comptime validatePairMatch(*SecondBase);
            }

            switch (@typeInfo(MatchT)) {
                // Opt out of capturing the component value.
                .Void => {},

                // Do not capture the component value; only detect whether the
                // column is present or not.
                .Bool => {},

                // Accept pointers to `First` or `Second`.
                .Pointer => |pointer| if (
                    pointer.child == First or
                    pointer.child == Second
                ) {
                    if (First == flecs.Any or First == flecs.Wildcard) @compileError(
                        "Capturing value of a relationship between Any/Wildcard " ++
                        "and another component (in this case, " ++ @typeName(Second) ++
                        ") is unsupported; ignore the value with void",
                    );
                    if (pointer.child == flecs.Any or pointer.child == flecs.Wildcard) @compileError(
                        "Values of type " ++ @typeName(pointer.child) ++
                        " not meant to be captured; capture " ++ @typeName(First) ++
                        " or ignore value with void",
                    );

                    if (pointer.child != First and @typeInfo(First) != .Opaque) {
                        if (@sizeOf(First) > 0) @compileError(
                            "Cannot capture value of type " ++ @typeName(pointer.child) ++
                            " due to the first element of the relationship (" ++
                            @typeName(First) ++ ") having nonzero size",
                        );
                    } else if (pointer.child != Second and @typeInfo(Second) != .Opaque) {
                        if (
                            @typeInfo(First) != .Opaque and
                            @sizeOf(First) == 0 and
                            @sizeOf(Second) > 0
                        ) @compileError(
                            "Cannot capture value of type " ++ @typeName(pointer.child) ++
                            " due to the second element of the relationship (" ++
                            @typeName(Second) ++ ") having nonzero size",
                        );
                    }

                    if (pointer.sentinel != null) @compileError(
                        "Cannot match " ++ @typeName(pointer.child) ++
                        " with " ++ @typeName(MatchT) ++
                        "; remove sentinel from the pointer type",
                    );
                } else {
                    @compileError(
                        "Cannot match " ++ @typeName(First) ++ " or " ++
                        @typeName(Second) ++ " with " ++ @typeName(MatchT) ++
                        "; use a pointer to one of those types or ignore value with void",
                    );
                },

                // Capture the component value if present; otherwise, pass `null`
                // to the iteration callback.
                .Optional => |optional| switch (@typeInfo(optional.child)) {
                    // Opt out of capturing the component value, but retain ability
                    // to detect whether the component was actually set.
                    .Void => {},

                    // `?bool` has three states but only two states would actually
                    // be used, so `?void` or `bool` is more appropriate.
                    .Bool => @compileError(
                        "Cannot match " ++ @typeName(@This()) ++ " with ?bool; use bool or ?void",
                    ),

                    // Accept optional pointers to `First` or `Second`.
                    .Pointer => comptime validatePairMatch(optional.child),

                    // Cannot match this type to `First` or `Second`.
                    else => @compileError(
                        "Cannot match " ++ @typeName(First) ++ " or " ++
                        @typeName(Second) ++ " with " ++ @typeName(MatchT) ++
                        "; use a pointer to one of those types or ignore value with void",
                    ),
                },

                // Cannot match this type to `First` or `Second`.
                else => @compileError(
                    "Cannot match " ++ @typeName(First) ++ " or " ++
                    @typeName(Second) ++ " with " ++ @typeName(MatchT) ++
                    "; use a pointer to one of those types or ignore value with void",
                ),
            }
        }
    };
}

fn ColumnPtr(comptime T: type) type {
    if (comptime isPairMarker(T)) {
        const is_opaque = @typeInfo(T.First) == .Opaque or (
            @sizeOf(T.First) == 0 and
            @typeInfo(T.Second) == .Opaque
        );
        const zero_sized = (
            T.First == flecs.Any or
            T.First == flecs.Wildcard or (
                !is_opaque and
                @sizeOf(T.First) == 0 and
                @sizeOf(T.Second) == 0
            )
        );
        return if (zero_sized)
            void
        else if (is_opaque)
            ?*anyopaque
        else if (@sizeOf(T.First) > 0)
            ?[*]T.First
        else if (@sizeOf(T.Second) > 0)
            ?[*]T.Second
        else
            comptime unreachable;
    }
    return if (@typeInfo(T) == .Opaque)
        ?*T
    else if (@sizeOf(T) > 0)
        ?[*]T
    else
        void;
}

fn tupleFieldName(comptime index: comptime_int) [:0]const u8 {
    return comptime std.fmt.comptimePrint("{d}", .{ index });
}

fn tupleField(
    comptime index: comptime_int,
    comptime Type: type,
    comptime default_value: Type,
    comptime is_comptime: bool,
) StructField {
    return .{
        .name = comptime tupleFieldName(index),
        .type = Type,
        .default_value = @ptrCast(*const anyopaque, @alignCast(1, &default_value)),
        .is_comptime = is_comptime,
        .alignment = if (is_comptime) 0 else @alignOf(Type),
    };
}

fn ColumnTuple(comptime types: anytype) type {
    comptime std.debug.assert(@TypeOf(types) == [types.len]type);
    comptime var fields: [types.len]StructField = undefined;
    inline for (types, 0..) |Type, index| {
        @setEvalBranchQuota(10_000);
        const zero_sized = @sizeOf(ColumnPtr(Type)) == 0;
        const default_value = if (zero_sized) {} else null;
        fields[index] = comptime tupleField(index, ColumnPtr(Type), default_value, zero_sized);
    }
    return @Type(.{
        .Struct = .{
            .layout = .Auto,
            .fields = &fields,
            .decls = &.{},
            .is_tuple = true,
        },
    });
}

fn SharedInstanceTuple(comptime types: anytype) type {
    comptime std.debug.assert(@TypeOf(types) == [types.len]type);
    comptime var fields: [types.len]StructField = undefined;
    inline for (types, 0..) |Type, index| {
        @setEvalBranchQuota(10_000);
        const zero_sized = @sizeOf(ColumnPtr(Type)) == 0;
        fields[index] = comptime tupleField(index, bool, false, zero_sized);
    }
    return @Type(.{
        .Struct = .{
            .layout = .Auto,
            .fields = &fields,
            .decls = &.{},
            .is_tuple = true,
        },
    });
}

pub fn IterInvoker(comptime components: anytype) type {
    if (@TypeOf(components) != [components.len]type) {
        return IterInvoker(@as([components.len]type, components));
    }
    return struct {
        pub fn iter(
            it: *c.ecs_iter_t,
            comptime nextFn: fn (*c.ecs_iter_t) callconv(.C) bool,
            function: anytype,
            comptime Context: ?type,
            ctx: if (Context == null) void else Context.?,
        ) void {
            const FunctionOrPtr = @TypeOf(function);
            const Function = switch (@typeInfo(FunctionOrPtr)) {
                .Fn => FunctionOrPtr,
                .Pointer => |pointer_info| switch (@typeInfo(pointer_info.child)) {
                    .Fn => pointer_info.child,
                    else => @compileError(
                        "Expected function or function pointer, found " ++ @typeName(FunctionOrPtr),
                    ),
                },
                else => @compileError(
                    "Expected function or function pointer, found " ++ @typeName(FunctionOrPtr),
                ),
            };

            const has_context = Context != null;
            const function_info = @typeInfo(Function).Fn;
            const params = function_info.params;

            if (has_context and params.len < 2) @compileError(
                "Iterator callback with context requires a minimum of two parameters",
            );
            if (!has_context and params.len < 1) @compileError(
                "Iterator callback requires a minimum of one parameter",
            );

            const start_index: comptime_int = @boolToInt(has_context);
            var function_args: ArgsTuple(Function) = undefined;
            if (has_context) function_args[0] = ctx;

            const iter_only = (
                params.len == (start_index + 1) and
                switch (@typeInfo(params[start_index].type)) {
                    .Pointer => |pointer| pointer.child == c.ecs_iter_t,
                    else => false,
                }
            );
            const pass_iter = iter_only or params.len == start_index + components.len + 1;
            if (pass_iter) function_args[start_index] = @as(*const c.ecs_iter_t, it);

            if (params.len > start_index + components.len + 1) @compileError(
                "Iterator callback " ++ @typeName(FunctionOrPtr) ++ " takes more parameters than expected",
            );
            if (!iter_only and params.len < start_index + components.len) @compileError(
                "Iterator callback " ++ @typeName(FunctionOrPtr) ++ " takes fewer parameters than expected",
            );

            const match_index = start_index + @boolToInt(pass_iter);
            while (nextFn(it)) {
            }
            _ = match_index;
        }

        pub fn each(it: *c.ecs_iter_t) void {
            _ = it;
        }

        // pub fn init(iter: *const c.ecs_iter_t) @This() {
        //     var invoker: @This() = undefined;
        //     std.debug.assert(iter.field_count >= components.len);
        //     inline for (
        //         components,
        //         iter.ptrs.?[0..components.len],
        //         &invoker.columns,
        //     ) |T, iter_ptr, *column_ptr| {
        //         @setEvalBranchQuota(10_000);
        //         if (@sizeOf(ColumnPtr(T)) == 0) continue;
        //         column_ptr.* = @ptrCast(ColumnPtr(T), iter_ptr);
        //     }
        //     return invoker;
        // }
    };
}

pub fn EachInvoker(comptime components: anytype) type {
    if (@TypeOf(components) != [components.len]type) {
        return EachInvoker(@as([components.len]type, components));
    }
    return struct {
        pub const Columns = ColumnTuple(components);
        pub const SharedInstances = SharedInstanceTuple(components);

        columns: Columns,
        shared_instances: SharedInstances = .{},

        pub fn init(iter: *const c.ecs_iter_t) @This() {
            var shared_instances: SharedInstances = .{};
            _ = shared_instances;
            var invoker: @This() = .{
                .columns = IterInvoker(components).init(iter).columns,
            };
            if (iter.flags & c.EcsIterIsInstanced != 0) {
                inline for (
                    components,
                    &invoker.shared_instances,
                    1..,
                ) |T, *shared_instance, index| {
                    @setEvalBranchQuota(10_000);
                    if (@sizeOf(ColumnPtr(T)) == 0) continue;
                    shared_instance.* = !c.ecs_field_is_self(iter, index);
                }
            }
            return invoker;
        }
    };
}

test "column match" {
    const A = struct {};
    const B = struct { b: u8 };

    comptime validateColumnMatch(A, A);
    comptime validateColumnMatch(A, ?A);
    comptime validateColumnMatch(A, *A);
    comptime validateColumnMatch(A, [*]A);
    comptime validateColumnMatch(A, []A);
    comptime validateColumnMatch(A, ?*A);
    comptime validateColumnMatch(A, ?[*]A);
    comptime validateColumnMatch(A, ?[]A);
    comptime validateColumnMatch(A, void);
    comptime validateColumnMatch(A, ?void);
    comptime validateColumnMatch(A, bool);

    comptime validateColumnMatch(B, *B);
    comptime validateColumnMatch(B, [*]B);
    comptime validateColumnMatch(B, []B);
    comptime validateColumnMatch(B, ?*B);
    comptime validateColumnMatch(B, ?[*]B);
    comptime validateColumnMatch(B, ?[]B);
    comptime validateColumnMatch(B, void);
    comptime validateColumnMatch(B, ?void);
    comptime validateColumnMatch(B, bool);
}

test "sized pair match" {
    const A = struct {};
    const B = struct { b: u8 };
    const C = struct { c: u8 };

    const A_B = PairMarker(A, B);
    comptime validateColumnMatch(A_B, B);
    comptime validateColumnMatch(A_B, ?B);
    comptime validateColumnMatch(A_B, *B);
    comptime validateColumnMatch(A_B, [*]B);
    comptime validateColumnMatch(A_B, []B);
    comptime validateColumnMatch(A_B, ?*B);
    comptime validateColumnMatch(A_B, ?[*]B);
    comptime validateColumnMatch(A_B, ?[]B);
    comptime validateColumnMatch(A_B, void);
    comptime validateColumnMatch(A_B, ?void);
    comptime validateColumnMatch(A_B, bool);

    const B_A = PairMarker(B, A);
    comptime validateColumnMatch(B_A, B);
    comptime validateColumnMatch(B_A, ?B);
    comptime validateColumnMatch(B_A, *B);
    comptime validateColumnMatch(B_A, [*]B);
    comptime validateColumnMatch(B_A, []B);
    comptime validateColumnMatch(B_A, ?*B);
    comptime validateColumnMatch(B_A, ?[*]B);
    comptime validateColumnMatch(B_A, ?[]B);
    comptime validateColumnMatch(B_A, void);
    comptime validateColumnMatch(B_A, ?void);
    comptime validateColumnMatch(B_A, bool);

    const B_B = PairMarker(B, B);
    comptime validateColumnMatch(B_B, B);
    comptime validateColumnMatch(B_B, ?B);
    comptime validateColumnMatch(B_B, *B);
    comptime validateColumnMatch(B_B, [*]B);
    comptime validateColumnMatch(B_B, []B);
    comptime validateColumnMatch(B_B, ?*B);
    comptime validateColumnMatch(B_B, ?[*]B);
    comptime validateColumnMatch(B_B, ?[]B);
    comptime validateColumnMatch(B_B, void);
    comptime validateColumnMatch(B_B, ?void);
    comptime validateColumnMatch(B_B, bool);

    const B_C = PairMarker(B, C);
    comptime validateColumnMatch(B_C, B);
    comptime validateColumnMatch(B_C, ?B);
    comptime validateColumnMatch(B_C, *B);
    comptime validateColumnMatch(B_C, [*]B);
    comptime validateColumnMatch(B_C, []B);
    comptime validateColumnMatch(B_C, ?*B);
    comptime validateColumnMatch(B_C, ?[*]B);
    comptime validateColumnMatch(B_C, ?[]B);
    comptime validateColumnMatch(B_C, void);
    comptime validateColumnMatch(B_C, ?void);
    comptime validateColumnMatch(B_C, bool);

    const C_B = PairMarker(C, B);
    comptime validateColumnMatch(C_B, C);
    comptime validateColumnMatch(C_B, ?C);
    comptime validateColumnMatch(C_B, *C);
    comptime validateColumnMatch(C_B, [*]C);
    comptime validateColumnMatch(C_B, []C);
    comptime validateColumnMatch(C_B, ?*C);
    comptime validateColumnMatch(C_B, ?[*]C);
    comptime validateColumnMatch(C_B, ?[]C);
    comptime validateColumnMatch(C_B, void);
    comptime validateColumnMatch(C_B, ?void);
    comptime validateColumnMatch(C_B, bool);
}

test "zero-sized pair match" {
    const A = struct {};
    const B = struct {};

    const A_B = PairMarker(A, B);
    comptime validateColumnMatch(A_B, A);
    comptime validateColumnMatch(A_B, ?A);
    comptime validateColumnMatch(A_B, *A);
    comptime validateColumnMatch(A_B, [*]A);
    comptime validateColumnMatch(A_B, []A);
    comptime validateColumnMatch(A_B, ?*A);
    comptime validateColumnMatch(A_B, ?[*]A);
    comptime validateColumnMatch(A_B, ?[]A);
    comptime validateColumnMatch(A_B, B);
    comptime validateColumnMatch(A_B, ?B);
    comptime validateColumnMatch(A_B, *B);
    comptime validateColumnMatch(A_B, [*]B);
    comptime validateColumnMatch(A_B, []B);
    comptime validateColumnMatch(A_B, ?*B);
    comptime validateColumnMatch(A_B, ?[*]B);
    comptime validateColumnMatch(A_B, ?[]B);
    comptime validateColumnMatch(A_B, void);
    comptime validateColumnMatch(A_B, ?void);
    comptime validateColumnMatch(A_B, bool);

    const A_A = PairMarker(A, A);
    comptime validateColumnMatch(A_A, A);
    comptime validateColumnMatch(A_A, ?A);
    comptime validateColumnMatch(A_A, *A);
    comptime validateColumnMatch(A_A, [*]A);
    comptime validateColumnMatch(A_A, []A);
    comptime validateColumnMatch(A_A, ?*A);
    comptime validateColumnMatch(A_A, ?[*]A);
    comptime validateColumnMatch(A_A, ?[]A);
    comptime validateColumnMatch(A_A, void);
    comptime validateColumnMatch(A_A, ?void);
    comptime validateColumnMatch(A_A, bool);
}

test "opaque pair match" {
    const A = struct {};
    const B = struct { b: u8 };

    const A_anyopaque = PairMarker(A, anyopaque);
    comptime validateColumnMatch(A_anyopaque, A);
    comptime validateColumnMatch(A_anyopaque, ?A);
    comptime validateColumnMatch(A_anyopaque, *A);
    comptime validateColumnMatch(A_anyopaque, [*]A);
    comptime validateColumnMatch(A_anyopaque, []A);
    comptime validateColumnMatch(A_anyopaque, ?*A);
    comptime validateColumnMatch(A_anyopaque, ?[*]A);
    comptime validateColumnMatch(A_anyopaque, ?[]A);
    comptime validateColumnMatch(A_anyopaque, *anyopaque);
    comptime validateColumnMatch(A_anyopaque, ?*anyopaque);
    comptime validateColumnMatch(A_anyopaque, void);
    comptime validateColumnMatch(A_anyopaque, ?void);
    comptime validateColumnMatch(A_anyopaque, bool);

    const anyopaque_A = PairMarker(anyopaque, A);
    comptime validateColumnMatch(anyopaque_A, *anyopaque);
    comptime validateColumnMatch(anyopaque_A, ?*anyopaque);
    comptime validateColumnMatch(anyopaque_A, A);
    comptime validateColumnMatch(anyopaque_A, ?A);
    comptime validateColumnMatch(anyopaque_A, *A);
    comptime validateColumnMatch(anyopaque_A, [*]A);
    comptime validateColumnMatch(anyopaque_A, []A);
    comptime validateColumnMatch(anyopaque_A, ?*A);
    comptime validateColumnMatch(anyopaque_A, ?[*]A);
    comptime validateColumnMatch(anyopaque_A, ?[]A);
    comptime validateColumnMatch(anyopaque_A, void);
    comptime validateColumnMatch(anyopaque_A, ?void);
    comptime validateColumnMatch(anyopaque_A, bool);

    const B_anyopaque = PairMarker(B, anyopaque);
    comptime validateColumnMatch(B_anyopaque, B);
    comptime validateColumnMatch(B_anyopaque, ?B);
    comptime validateColumnMatch(B_anyopaque, *B);
    comptime validateColumnMatch(B_anyopaque, [*]B);
    comptime validateColumnMatch(B_anyopaque, []B);
    comptime validateColumnMatch(B_anyopaque, ?*B);
    comptime validateColumnMatch(B_anyopaque, ?[*]B);
    comptime validateColumnMatch(B_anyopaque, ?[]B);
    comptime validateColumnMatch(B_anyopaque, void);
    comptime validateColumnMatch(B_anyopaque, ?void);
    comptime validateColumnMatch(B_anyopaque, bool);

    const anyopaque_B = PairMarker(anyopaque, B);
    comptime validateColumnMatch(anyopaque_B, *anyopaque);
    comptime validateColumnMatch(anyopaque_B, ?*anyopaque);
    comptime validateColumnMatch(anyopaque_B, B);
    comptime validateColumnMatch(anyopaque_B, ?B);
    comptime validateColumnMatch(anyopaque_B, *B);
    comptime validateColumnMatch(anyopaque_B, [*]B);
    comptime validateColumnMatch(anyopaque_B, []B);
    comptime validateColumnMatch(anyopaque_B, ?*B);
    comptime validateColumnMatch(anyopaque_B, ?[*]B);
    comptime validateColumnMatch(anyopaque_B, ?[]B);
    comptime validateColumnMatch(anyopaque_B, void);
    comptime validateColumnMatch(anyopaque_B, ?void);
    comptime validateColumnMatch(anyopaque_B, bool);

    const anyopaque_anyopaque = PairMarker(anyopaque, anyopaque);
    comptime validateColumnMatch(anyopaque_anyopaque, *anyopaque);
    comptime validateColumnMatch(anyopaque_anyopaque, ?*anyopaque);
    comptime validateColumnMatch(anyopaque_anyopaque, void);
    comptime validateColumnMatch(anyopaque_anyopaque, ?void);
    comptime validateColumnMatch(anyopaque_anyopaque, bool);
}

test "any/wildcard pair match" {
    const A = struct {};
    const B = struct { b: u8 };

    inline for (.{ flecs.Any, flecs.Wildcard }) |X| {
        const A_X = PairMarker(A, X);
        comptime validateColumnMatch(A_X, A);
        comptime validateColumnMatch(A_X, ?A);
        comptime validateColumnMatch(A_X, *A);
        comptime validateColumnMatch(A_X, [*]A);
        comptime validateColumnMatch(A_X, []A);
        comptime validateColumnMatch(A_X, ?*A);
        comptime validateColumnMatch(A_X, ?[*]A);
        comptime validateColumnMatch(A_X, ?[]A);
        comptime validateColumnMatch(A_X, void);
        comptime validateColumnMatch(A_X, ?void);
        comptime validateColumnMatch(A_X, bool);

        const X_A = PairMarker(X, A);
        comptime validateColumnMatch(X_A, void);
        comptime validateColumnMatch(X_A, ?void);
        comptime validateColumnMatch(X_A, bool);

        const B_X = PairMarker(B, X);
        comptime validateColumnMatch(B_X, B);
        comptime validateColumnMatch(B_X, ?B);
        comptime validateColumnMatch(B_X, *B);
        comptime validateColumnMatch(B_X, [*]B);
        comptime validateColumnMatch(B_X, []B);
        comptime validateColumnMatch(B_X, ?*B);
        comptime validateColumnMatch(B_X, ?[*]B);
        comptime validateColumnMatch(B_X, ?[]B);
        comptime validateColumnMatch(B_X, void);
        comptime validateColumnMatch(B_X, ?void);
        comptime validateColumnMatch(B_X, bool);

        const X_B = PairMarker(X, B);
        comptime validateColumnMatch(X_B, void);
        comptime validateColumnMatch(X_B, ?void);
        comptime validateColumnMatch(X_B, bool);

        const anyopaque_X = PairMarker(anyopaque, X);
        comptime validateColumnMatch(anyopaque_X, *anyopaque);
        comptime validateColumnMatch(anyopaque_X, ?*anyopaque);
        comptime validateColumnMatch(anyopaque_X, void);
        comptime validateColumnMatch(anyopaque_X, ?void);
        comptime validateColumnMatch(anyopaque_X, bool);

        const X_anyopaque = PairMarker(X, anyopaque);
        comptime validateColumnMatch(X_anyopaque, void);
        comptime validateColumnMatch(X_anyopaque, ?void);
        comptime validateColumnMatch(X_anyopaque, bool);
    }
}
