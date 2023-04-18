const std = @import("std");
const builtin = @import("builtin");

pub const c = @import("c.zig");
pub const Id = @import("entity.zig").Id;
pub const Entity = @import("entity.zig").Entity;
pub const EntityView = @import("entity.zig").EntityView;
pub const EntityTypeMeta = @import("entity.zig").EntityTypeMeta;
pub const World = @import("world.zig").World;
pub const testing = @import("testing.zig");

pub const entities = @import("entities.zig");
pub usingnamespace entities;

/// The set of Flecs addons enabled for this build.
pub const enabled_addons = struct {
    pub usingnamespace @import("package_options").enabled_addons;
};

pub const flecs_version = @import("package_options").metadata.flecs_version;

test {
    comptime std.testing.refAllDecls(@This());
    comptime std.testing.refAllDecls(enabled_addons);
}
