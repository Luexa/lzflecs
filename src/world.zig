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

        switch (id_handle.intended_use) {
            .any, .global_entity => {},
            .component => return world.componentImpl(GlobalEntity, true),
            .none => return,
        }

        const entity_desc = std.mem.zeroInit(c.ecs_entity_desc_t, .{
            .name = if (id_handle.name) |name| name.ptr else null,
            .symbol = if (id_handle.symbol) |symbol| symbol.ptr else null,
            .id = id_handle.get(),
        });

        id_handle.set(c.ecs_entity_init(c_world, &entity_desc));
    }

    /// Shared implementation for `component` and `componentHi`.
    inline fn componentImpl(world: *World, comptime Component: type, use_low_id: bool) void {
        const c_world = @ptrCast(*c.ecs_world_t, world);
        const id_handle = @import("entity.zig").IdStorage(Component);

        switch (id_handle.intended_use) {
            .any, .component => {},
            .global_entity => return world.globalEntity(Component),
            .none => return,
        }

        const entity_desc = std.mem.zeroInit(c.ecs_entity_desc_t, .{
            .name = if (id_handle.name) |name| name.ptr else null,
            .symbol = if (id_handle.symbol) |symbol| symbol.ptr else null,
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

    /// Look up an entity by name.
    ///
    /// Returns an `Entity` that matches the specified name.
    ///
    /// Only looks for entities in the provided parent. If no parent is provided,
    /// look in the current scope (root if no scope is provided).
    pub inline fn lookup(
        world: *World,
        parent: anytype,
        name: [*:0]const u8,
    ) Entity {
        return world.entity(world.lookupId(parent, name));
    }

    /// Look up an entity by name.
    ///
    /// Returns an `EntityView` that matches the specified name.
    ///
    /// Only looks for entities in the provided parent. If no parent is provided,
    /// look in the current scope (root if no scope is provided).
    pub inline fn lookupView(
        world: *const World,
        parent: anytype,
        name: [*:0]const u8,
    ) EntityView {
        return world.entityView(world.lookupId(parent, name));
    }

    /// Look up an entity by name.
    ///
    /// Returns an entity ID that matches the specified name.
    ///
    /// Only looks for entities in the provided parent. If no parent is provided,
    /// look in the current scope (root if no scope is provided).
    pub inline fn lookupId(world: *const World, parent: anytype, name: [*:0]const u8) Id {
        const ParentType = @TypeOf(parent);
        const parent_id = switch (ParentType) {
            Entity, EntityView => parent.id,
            type => Id.of(parent),
            Id => parent,

            ?Id => parent orelse Id.null_id,
            ?Entity, ?EntityView => if (parent) |e| e.id else Id.null_id,
            @TypeOf(null) => Id.null_id,

            else => @compileError("Cannot derive entity ID from " ++ @typeName(ParentType)),
        };
        return @intToEnum(Id, c.ecs_lookup_child(
            @ptrCast(*const c.ecs_world_t, world),
            @enumToInt(parent_id),
            name,
        ));
    }

    /// Advanced options for `lookupPath()` and related functions.
    pub const LookupPathOptions = struct {
        sep: ?[*:0]const u8 = null,
        prefix: ?[*:0]const u8 = null,
        recursive: bool = true,
    };

    /// Look up an entity from a path.
    ///
    /// Returns an `Entity` that matches the provided path, relative to the
    /// provided parent. The operation will use the provided separator to tokenize
    /// the path expression. If the provided path contains the prefix, the search
    /// will start from the root.
    ///
    /// If the entity is not found in the provided parent, the operation will
    /// continue to search in the parent of the parent, until the root is reached.
    /// If the entity is still not found, the lookup will search in the `flecs.core`
    /// scope. If the entity is not found there either, the function returns the
    /// null ID.
    pub inline fn lookupPath(
        world: *World,
        parent: anytype,
        path: [*:0]const u8,
        options: LookupPathOptions,
    ) Entity {
        return world.entity(world.lookupPathId(parent, path, options));
    }

    /// Look up an entity from a path.
    ///
    /// Returns an `EntityView` that matches the provided path, relative to the
    /// provided parent. The operation will use the provided separator to tokenize
    /// the path expression. If the provided path contains the prefix, the search
    /// will start from the root.
    ///
    /// If the entity is not found in the provided parent, the operation will
    /// continue to search in the parent of the parent, until the root is reached.
    /// If the entity is still not found, the lookup will search in the `flecs.core`
    /// scope. If the entity is not found there either, the function returns the
    /// null ID.
    pub inline fn lookupPathView(
        world: *const World,
        parent: anytype,
        path: [*:0]const u8,
        options: LookupPathOptions,
    ) EntityView {
        return world.entityView(world.lookupPathId(parent, path, options));
    }

    /// Look up an entity from a path.
    ///
    /// Returns an entity ID that matches the provided path, relative to the
    /// provided parent. The operation will use the provided separator to tokenize
    /// the path expression. If the provided path contains the prefix, the search
    /// will start from the root.
    ///
    /// If the entity is not found in the provided parent, the operation will
    /// continue to search in the parent of the parent, until the root is reached.
    /// If the entity is still not found, the lookup will search in the `flecs.core`
    /// scope. If the entity is not found there either, the function returns the
    /// null ID.
    pub inline fn lookupPathId(
        world: *const World,
        parent: anytype,
        path: [*:0]const u8,
        options: LookupPathOptions,
    ) Id {
        const ParentType = @TypeOf(parent);
        const parent_id = switch (ParentType) {
            Id => parent,
            Entity, EntityView => parent.id,
            type => Id.of(parent),

            ?Id => parent orelse Id.null_id,
            ?Entity, ?EntityView => if (parent) |e| e.id else Id.null_id,
            @TypeOf(null) => Id.null_id,

            else => @compileError("Cannot derive entity ID from " ++ @typeName(ParentType)),
        };
        return @intToEnum(Id, c.ecs_lookup_path_w_sep(
            @ptrCast(*const c.ecs_world_t, world),
            @enumToInt(parent_id),
            path,
            options.sep,
            options.prefix,
            options.recursive,
        ));
    }

    /// Look up an entity by its full path.
    ///
    /// Returns an `Entity` that matches the provided path, relative to the root.
    pub inline fn lookupFullPath(
        world: *World,
        path: [*:0]const u8,
    ) Entity {
        return world.lookupPath(null, path, .{});
    }

    /// Look up an entity by its full path.
    ///
    /// Returns an `EntityView` that matches the provided path, relative to the root.
    pub inline fn lookupFullPathView(
        world: *const World,
        path: [*:0]const u8,
    ) EntityView {
        return world.lookupPathView(null, path, .{});
    }

    /// Look up an entity by its full path.
    ///
    /// Returns an entity ID that matches the provided path, relative to the root.
    pub inline fn lookupFullPathId(
        world: *const World,
        path: [*:0]const u8,
    ) Id {
        return world.lookupPathId(null, path, .{});
    }

    /// Look up an entity by its symbol name.
    ///
    /// Returns an `Entity`.
    ///
    /// This looks up an entity by symbol stored in `(flecs.Identifier, flecs.Symbol)`.
    /// The operation does not take into account hierarchies.
    ///
    /// This operation can be useful to resolve, for example, a type by its Zig
    /// identifier, which does not include the Flecs namespacing.
    pub inline fn lookupSymbol(
        world: *World,
        symbol: [*:0]const u8,
        lookup_as_path: bool,
    ) Entity {
        return world.entity(world.lookupSymbolId(symbol, lookup_as_path));
    }

    /// Look up an entity by its symbol name.
    ///
    /// Returns an `EntityView`.
    ///
    /// This looks up an entity by symbol stored in `(flecs.Identifier, flecs.Symbol)`.
    /// The operation does not take into account hierarchies.
    ///
    /// This operation can be useful to resolve, for example, a type by its Zig
    /// identifier, which does not include the Flecs namespacing.
    pub inline fn lookupSymbolView(
        world: *const World,
        symbol: [*:0]const u8,
        lookup_as_path: bool,
    ) EntityView {
        return world.entityView(world.lookupSymbolId(symbol, lookup_as_path));
    }

    /// Look up an entity by its symbol name.
    ///
    /// Returns an entity ID.
    ///
    /// This looks up an entity by symbol stored in `(flecs.Identifier, flecs.Symbol)`.
    /// The operation does not take into account hierarchies.
    ///
    /// This operation can be useful to resolve, for example, a type by its Zig
    /// identifier, which does not include the Flecs namespacing.
    pub inline fn lookupSymbolId(
        world: *const World,
        symbol: [*:0]const u8,
        lookup_as_path: bool,
    ) Id {
        return @intToEnum(Id, c.ecs_lookup_symbol(
            @ptrCast(*const c.ecs_world_t, world),
            symbol,
            lookup_as_path,
        ));
    }

    /// Set the current scope.
    ///
    /// This operation sets the scope of the current stage to the provided entity.
    /// As a result new entities will be created in this scope, and lookups will
    /// be relative to the provided scope.
    ///
    /// It is considered good practice to restore the scope to the old value.
    /// Example usage:
    ///
    /// ```zig
    /// const old_scope = world.setScope(new_scope);
    /// defer _ = world.setScope(old_scope);
    /// ```
    pub inline fn setScope(world: *World, scope: anytype) Id {
        const ScopeType = @TypeOf(scope);
        const scope_id = switch (ScopeType) {
            Id => scope,
            Entity, EntityView => scope.id,
            type => Id.of(scope),
            else => @compileError("Cannot derive entity ID from " ++ @typeName(ScopeType)),
        };
        return @intToEnum(Id, c.ecs_set_scope(
            @ptrCast(*c.ecs_world_t, world),
            @enumToInt(scope_id),
        ));
    }

    /// Get the current scope.
    ///
    /// Returns the scope set by `setScope`, or `Id.null_id` if no scope was set.
    pub inline fn getScope(world: *const World) Id {
        return @intToEnum(Id, c.ecs_get_scope(
            @ptrCast(*const c.ecs_world_t, world),
        ));
    }

    /// Set search path for lookup operations.
    ///
    /// This operation accepts an array of entity IDs that will be used as search
    /// scopes by lookup operations. The operation returns the current search path.
    ///
    /// The search path will be evaluated starting from the last element.
    ///
    /// The default search path includes `flecs.core`. When a custom search path
    /// is provided it overwrites the existing search path. Operations that rely
    /// on looking up names from `flecs.core` without providing the namespace may
    /// fail if the custom search path does not include `flecs.core` (`flecs.FlecsCore`).
    ///
    /// The search path array is not copied into managed memory. The application
    /// must ensure that the provided array is valid for as long as it is used as
    /// the search path.
    ///
    /// The provided array must be terminated with a `null_id` element. This enables
    /// an application to push/pop elements to an existing array withut invoking the
    /// `setLookupPath` operation again.
    ///
    /// It is good practice to restore the old search path.
    /// Example usage:
    ///
    /// ```zig
    /// const old_lookup_path = world.setLookupPath(new_lookup_path);
    /// defer _ = world.setLookupPath(old_lookup_path);
    /// ```
    pub inline fn setLookupPath(
        world: *World,
        lookup_path: [*:Id.null_id]const Id,
    ) [*:Id.null_id]Id {
        return @ptrCast([*:Id.null_id]Id, c.ecs_set_lookup_path(
            @ptrCast(*c.ecs_world_t, world),
            @ptrCast([*:0]const c.ecs_entity_t, lookup_path),
        ));
    }

    /// Get current lookup path.
    ///
    /// Returns the lookup path set by `setLookupPath`.
    pub inline fn getLookupPath(world: *const World) [*:Id.null_id]Id {
        return @ptrCast([*:Id.null_id]Id, c.ecs_get_lookup_path(
            @ptrCast(*const c.ecs_world_t, world),
        ));
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

    const Foo2 = struct { const Foo = struct {}; }.Foo;
    const Foo = struct {};
    const Bar = struct {};
    try std.testing.expect(Id.of(Foo) == Id.null_id);
    try std.testing.expect(Id.of(Bar) == Id.null_id);
    try std.testing.expect(Id.of(Foo2) == Id.null_id);

    world_1.component(Foo);
    world_1.component(Bar);
    world_1.component(Foo2);

    const foo_id = Id.of(Foo);
    const bar_id = Id.of(Bar);
    const foo2_id = Id.of(Foo2);
    try std.testing.expect(foo_id != Id.null_id);
    try std.testing.expect(bar_id != Id.null_id);
    try std.testing.expect(foo2_id != Id.null_id);
    try std.testing.expect(foo_id != bar_id);
    try std.testing.expect(foo_id != foo2_id);
    try std.testing.expect(bar_id != foo2_id);

    const world_2 = World.init(null);
    defer world_2.deinit();

    world_2.component(Bar);
    world_2.component(Foo2);
    world_2.component(Foo);

    try std.testing.expect(Id.of(Foo) == foo_id);
    try std.testing.expect(Id.of(Bar) == bar_id);
    try std.testing.expect(Id.of(Foo2) == foo2_id);

    world_2.componentHi(Bar);
    world_2.componentHi(Foo2);
    world_2.componentHi(Foo);

    try std.testing.expect(Id.of(Foo) == foo_id);
    try std.testing.expect(Id.of(Bar) == bar_id);
    try std.testing.expect(Id.of(Foo2) == foo2_id);
}

test "prefab" {
    defer flecs.testing.reset();

    const world = World.init(null);
    defer world.deinit();

    const prefab = world.newPrefab("Foo");
    const entity_with_prefab = prefab.instantiate();
    _ = entity_with_prefab;
}
