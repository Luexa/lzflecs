const std = @import("std");
const builtin = @import("builtin");

const id_tracker = @import("entity.zig").id_tracker;

/// Reset dynamic global data such as component IDs that might otherwise persist
/// between tests and cause non-deterministic results.
///
/// Usage example:
///
/// ```zig
/// const flecs = @import("lzflecs");
/// test "example" {
///     defer flecs.testing.reset();
///     const world = try flecs.World.init(null);
///     defer world.deinit();
///     // ...
/// }
/// ```
pub fn reset() void {
    if (builtin.is_test) {
        id_tracker.reset();
    }
}
