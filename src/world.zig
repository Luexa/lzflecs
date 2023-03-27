const std = @import("std");

const flecs = @import("lzflecs.zig");
const c = flecs.c;
const Id = flecs.Id;
const Entity = flecs.Entity;
const EntityView = flecs.EntityView;

pub const World = opaque {
    /// Create the ECS `World`, optionally initialized with process arguments.
    ///
    /// If provided, Flecs may parse and copy the contents of `argv` for use with
    /// the Flecs explorer.
    ///
    /// Returns `null` if world creation was unsuccessful.
    /// The world can be cleaned up with `deinit()`.
    pub inline fn init(argv: ?[]const [*:0]const u8) *World {
        if (argv) |argv_| {
            return @ptrCast(*World, c.ecs_init_w_args(
                @intCast(c_int, argv_.len),
                argv_.ptr,
            ).?);
        } else {
            return @ptrCast(*World, c.ecs_init().?);
        }
    }

    /// Deinitialize the world and free any resources associated with it.
    pub inline fn deinit(world: *World) void {
        _ = c.ecs_fini(@ptrCast(*c.ecs_world_t, world));
    }

    /// If this world object is actually a stage, return the world from which
    /// the stage was created. Otherwise, return self.
    pub inline fn getWorld(world: *const World) *const World {
        return @ptrCast(*const World, c.ecs_get_world(world));
    }

    /// Create a new entity.
    ///
    /// `InitialComponent` can optionally be set to a component type, in which
    /// case the entity will be created with that component already present.
    pub inline fn new(world: *World, comptime InitialComponent: ?type) Entity {
        if (InitialComponent) |T| {
            return world.newWithId(Id.of(T));
        }

        return Entity.init(world, @intToEnum(Id, c.ecs_new(
            @ptrCast(*c.ecs_world_t, world),
        )));
    }

    /// Create a new entity with the specified initial component ID.
    pub inline fn newWithId(world: *World, initial_component: Id) Entity {
        return Entity.init(world, @intToEnum(Id, c.ecs_new_w_id(
            @ptrCast(*c.ecs_world_t, world),
            @enumToInt(initial_component),
        )));
    }

    /// Create a new entity with the specified `name`.
    pub inline fn newWithName(world: *World, name: [*:0]const u8) Entity {
        const entity_desc = std.mem.zeroInit(c.ecs_entity_desc_t, .{
            .name = name,
        });

        return Entity.init(world, @intToEnum(Id, c.ecs_entity_init(
            @ptrCast(*c.ecs_world_t, world),
            &entity_desc,
        )));
    }

    /// Create a new prefab with the given `name`.
    pub inline fn newPrefab(world: *World, name: [*:0]const u8) Entity {
        var entity_desc = std.mem.zeroInit(c.ecs_entity_desc_t, .{
            .name = name,
        });
        entity_desc.add[0] = c.EcsPrefab;

        return Entity.init(world, @intToEnum(Id, c.ecs_entity_init(
            @ptrCast(*c.ecs_world_t, world),
            &entity_desc,
        )));
    }

    /// Create N new entities.
    ///
    /// `InitialComponent` can optionally be set to a component type, in which
    /// case the entities will be created with that component already present.
    ///
    /// The returned slice is not guaranteed to be valid indefinitely; it should
    /// be copied to caller-owned memory.
    pub inline fn bulkNew(world: *World, count: i32, comptime InitialComponent: ?type) ?[]const Id {
        return world.bulkNewWithId(
            count,
            if (InitialComponent) |T| Id.of(T) else Id.null_id,
        );
    }

    /// Create N new entities with the specified initial component ID.
    ///
    /// The returned slice is not guaranteed to be valid indefinitely; it should
    /// be copied to caller-owned memory.
    pub inline fn bulkNewWithId(world: *World, count: i32, initial_component: Id) ?[]const Id {
        if (c.ecs_bulk_new_w_id(
            @ptrCast(*c.ecs_world_t, world),
            @enumToInt(initial_component),
            count,
        )) |new_entities| {
            return @ptrCast([*]const Id, new_entities)[0..@intCast(usize, count)];
        }
        return null;
    }

    /// Delete the entity with the ID `entity_id`.
    ///
    /// This operation will delete an entity and all of its components.
    ///
    /// The entity ID will be recycled. Repeatedly calling this function without
    /// creating a new entity will cause a memory leak, as the list of IDs to be
    /// recycled will grow indefinitely.
    pub inline fn delete(world: *World, entity_id: Id) void {
        c.ecs_delete(
            @ptrCast(*c.ecs_world_t, world),
            @enumToInt(entity_id),
        );
    }

    /// Register the component type `Component` with the world.
    ///
    /// The component will be assigned an entity ID and registered with the
    /// correct size and alignment parameters.
    ///
    /// In multi-world setups, components and modules should be registered in
    /// the same order for each world, as the entity ID assigned for a given
    /// component will be used across all worlds.
    pub inline fn component(world: *World, comptime Component: type) void {
        world.componentImpl(Component, true);
    }

    /// Register the component type `Component` using the regular entity ID range.
    ///
    /// Same as `component` but without using the special ID range reserved for
    /// components.
    pub inline fn componentHi(world: *World, comptime Component: type) void {
        world.componentImpl(Component, false);
    }

    /// Assign an entity ID to an arbitrary type `GlobalEntity` without assigning
    /// it component-specific metadata.
    ///
    /// Using this function is discouraged; entity IDs should be used locally
    /// and passed around for the most part. It only exists to allow user code
    /// to replicate the behavior of builtin global entities like `WorldEntity`.
    pub inline fn globalEntity(world: *World, comptime GlobalEntity: type) void {
        const c_world = @ptrCast(*c.ecs_world_t, world);
        const id_handle = @import("entity.zig").IdStorage(GlobalEntity);

        switch (id_handle.permitted_registrations) {
            .any, .global_entity => {},
            .component => return world.componentImpl(GlobalEntity, true),
            .none => return,
        }

        const entity_desc = std.mem.zeroInit(c.ecs_entity_desc_t, .{
            .name = if (id_handle.type_name) |type_name| type_name.ptr else null,
            .id = id_handle.get(),
        });

        id_handle.set(c.ecs_entity_init(c_world, &entity_desc));
    }

    /// Shared implementation for `component` and `componentHi`.
    inline fn componentImpl(world: *World, comptime Component: type, use_low_id: bool) void {
        const c_world = @ptrCast(*c.ecs_world_t, world);
        const id_handle = @import("entity.zig").IdStorage(Component);

        switch (id_handle.permitted_registrations) {
            .any, .component => {},
            .global_entity => return world.globalEntity(Component),
            .none => return,
        }

        const entity_desc = std.mem.zeroInit(c.ecs_entity_desc_t, .{
            .name = if (id_handle.type_name) |type_name| type_name.ptr else null,
            .id = id_handle.get(),
            .use_low_id = use_low_id,
        });

        const component_desc = std.mem.zeroInit(c.ecs_component_desc_t, .{
            .entity = c.ecs_entity_init(c_world, &entity_desc),
            .type = .{
                .alignment = @alignOf(Component),
                .size = @sizeOf(Component),
            },
        });

        id_handle.set(c.ecs_component_init(c_world, &component_desc));
    }

    // Include an `entity` method that would shadow identifiers if defined in this scope.
    pub usingnamespace entity_fn;

    /// Return an `EntityView` for `id_or_type` and associate it with a read-only
    /// view into this world. If `world` is a stage, the resulting `EntityView`
    /// will be associated with the original world, not the stage.
    ///
    /// If a `type` is passed that has not been registered as a component or global
    /// entity, the result is unspecified. Make sure to register the entity with a
    /// method like `component` or `globalEntity` ahead of time.
    pub inline fn entityView(world: *const World, id_or_type: anytype) EntityView {
        return EntityView.init(world, id_or_type);
    }

    /// Test whether an entity ID is valid.
    ///
    /// Entity IDs that are valid can be used with API functions.
    ///
    /// An entity ID is valid if it is not 0 and is alive.
    ///
    /// This function will return for IDs that do not exist (alive or not alive).
    /// This allows for using IDs that have never been created by `World.new` or
    /// similar. In this the function differs from `isAlive`, which will return
    /// false for entities that do not yet exist.
    ///
    /// The operation will return false for an ID that exists and is not alive, as
    /// using this ID with an API operation would cause it to assert.
    pub inline fn isValid(world: *const World, id: Id) bool {
        return c.ecs_is_valid(
            @ptrCast(*const c.ecs_world_t, world),
            @enumToInt(id),
        );
    }

    /// Test whether an entity ID is alive.
    ///
    /// An entity ID is alive when it has been returned by `World.new` (or similar)
    /// or if it is not empty (components have been explicitly added to the ID).
    pub inline fn isAlive(world: *const World, id: Id) bool {
        return c.ecs_is_alive(
            @ptrCast(*const c.ecs_world_t, world),
            @enumToInt(id),
        );
    }
};

const entity_fn = struct {
    /// Return an `Entity` for `id_or_type` and associate it with this world.
    ///
    /// If a `type` that has not been registered as a component or global entity,
    /// the result is unspecified. Make sure to register the entity with a method
    /// like `component` or `globalEntity` ahead of time.
    pub inline fn entity(world: *World, id_or_type: anytype) Entity {
        return Entity.init(world, id_or_type);
    }
};

test "world init/deinit" {
    defer flecs.testing.reset();

    const world = World.init(null);
    defer world.deinit();
}

test "world init/deinit args" {
    defer flecs.testing.reset();

    const world = World.init(&.{ "lzflecs-test", "some", "arguments" });
    defer world.deinit();
}

test "world component registration" {
    defer flecs.testing.reset();

    const world_1 = World.init(null);
    defer world_1.deinit();

    const Foo = struct {};
    const Bar = struct {};
    try std.testing.expect(Id.of(Foo) == Id.null_id);
    try std.testing.expect(Id.of(Bar) == Id.null_id);

    world_1.component(Foo);
    world_1.component(Bar);

    const foo_id = Id.of(Foo);
    const bar_id = Id.of(Bar);
    try std.testing.expect(foo_id != Id.null_id);
    try std.testing.expect(bar_id != Id.null_id);
    try std.testing.expect(foo_id != bar_id);

    const world_2 = World.init(null);
    defer world_2.deinit();

    world_2.component(Bar);
    world_2.component(Foo);

    try std.testing.expect(Id.of(Foo) == foo_id);
    try std.testing.expect(Id.of(Bar) == bar_id);

    world_2.componentHi(Bar);
    world_2.componentHi(Foo);

    try std.testing.expect(Id.of(Foo) == foo_id);
    try std.testing.expect(Id.of(Bar) == bar_id);
}

test "prefab" {
    defer flecs.testing.reset();

    const world = World.init(null);
    defer world.deinit();

    const prefab = world.newPrefab("Foo");
    const entity_with_prefab = prefab.instantiate();
    _ = entity_with_prefab;
}
