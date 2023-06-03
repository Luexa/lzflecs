const std = @import("std");

const flecs = @import("lzflecs.zig");
const World = flecs.World;
const c = flecs.c;

fn functionInfo(comptime Function: type) std.builtin.Type.Fn {
    return switch (@typeInfo(Function)) {
        .Pointer => |pointer_info| switch (pointer_info.child) {
            .Fn => |function_info| function_info,
            else => @compileError("Expected function or function pointer, found " ++ @typeName(Function)),
        },
        .Fn => |function_info| function_info,
        else => @compileError("Expected function or function pointer, found " ++ @typeName(Function)),
    };
}

pub fn Filter(comptime Components: anytype) type {
    if (@TypeOf(Components) != [Components.len]type) {
        return Filter(@as([Components.len]type, Components));
    }
    return struct {
        filter: c.ecs_filter_t,
        world: *const World,

        pub fn deinit(filter: *@This()) void {
            c.ecs_filter_fini(&filter.filter);
        }

        pub fn each(filter: *const @This(), function: anytype) void {
            const Function = @TypeOf(function);
            const function_info = comptime functionInfo(Function);
            _ = function_info;

            var iter = c.ecs_filter_iter(filter.world, &filter.filter);
            iter.flags |= c.EcsIterIsInstanced;

            while (c.ecs_filter_next_instanced(iter)) {
            }
        }
    };
}

test "filter type equivalence" {
    const A = struct { a: i32 };
    const B = struct { b: i32 };

    try std.testing.expectEqual(Filter([_]type{ A, B }), Filter([_]type{ A, B }));
    try std.testing.expectEqual(Filter([_]type{ A, B }), Filter(.{ A, B }));
    try std.testing.expectEqual(Filter(.{ A, B }), Filter(.{ A, B }));
    try std.testing.expect(Filter(.{ B, A }) != Filter(.{ A, B }));

    try std.testing.expectEqual(Filter([_]type{}), Filter(.{}));
    try std.testing.expectEqual(Filter(.{}), Filter(.{}));
}
