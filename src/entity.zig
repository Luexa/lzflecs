const std = @import("std");
const builtin = @import("builtin");

const flecs = @import("lzflecs.zig");
const c = flecs.c;
const enabled_addons = flecs.enabled_addons;
const entities = flecs.entities;
const World = flecs.World;

pub const IdStorage = @import("entity/internals.zig").IdStorage;
pub const IntendedUse = @import("entity/internals.zig").IntendedUse;
pub const id_tracker = @import("entity/internals.zig").id_tracker;

/// Allow user to override metadata for an automatically registered component
/// or global entity type.
///
/// Metadata overrides are defined in a declaration `flecs_meta`. If the value
/// of this declaration is not explicitly typed, it is permitted to omit the
/// enclosing `.{ .override = ... }` union initialization syntax for the `name`
/// and `symbol` fields. The following are equivalent:
///
/// ```zig
/// pub const flecs_meta = .{ .name = .{ .override = "FooComponent" } };
///
/// pub const flecs_meta = .{ .name = "FooComponent" };
/// ```
pub const EntityTypeMeta = struct {
    /// Configure the entity name for this type.
    ///
    /// By default the entity name is simply `@typeName(T)`, but for various
    /// reasons it may be desirable to override the qualified name of the
    /// component.
    ///
    /// Behavior of each union variant is described as follows:
    ///
    ///  - `.auto` will use `@typeName(T)` as the name for a component `T`.
    ///    For instance, component in `src/bar.zig` would be named something
    ///    like `bar.Example` (even though users may import the component as
    ///    `foo.bar.Example`).
    ///
    ///  - `.override` will use the provided string as the name for the component.
    ///
    ///  - `.override_split` will prepend the first element of the provided tuple
    ///    to the second element of the tuple.
    ///
    ///  - `.disable` will cause the component to not be given a name.
    ///
    /// Names for pointers to this component (e.g. `*T` or `[]T`) will be generated
    /// using the following methods:
    ///
    ///  - The qualified name inferred from `.auto` or specified with `.override`
    ///    will be split at the final `.` separator to separate the namespace from
    ///    the unqualified name. The unqualified name will be prefixed with pointer
    ///    symbols like `*` and `[]`, then the namespace will be prepended to the
    ///    resulting string. For instance, `*bar.Example` will have the component
    ///    name `bar.*Example`.
    ///
    ///  - With `.override_split`, rather than splitting a string, the namespace is
    ///    assumed to be the first element of the tuple and the unqualified name is
    ///    assumed to be the second element of the tuple. For instance, a pointer
    ///    `*T` to a component `T` with the split name `.{ "foo.bar.", "baz.A" }`
    ///    will have the component name `foo.bar.*baz.A`.
    ///
    ///  - With `.disable`, the pointer component will not be given a name.
    name: NameConfig = .auto,

    /// Configure the entity symbol for this type.
    ///
    /// The rules for this value follow the same rules as the `.name` field.
    symbol: NameConfig = .disable,

    /// Indicate that the component should always be a pointer. The component
    /// name will not be prefixed with a pointer symbol unless used as a slice
    /// or pointer-to-pointer.
    ///
    ///  - `bar.T` would not be usable as a component (i.e. treated like opaque type).
    ///
    ///  - `*bar.T` would be given the component name `bar.T`.
    ///
    ///  - `[]bar.T` would be given the component name `bar.[]T`.
    ///
    ///  - `**bar.T` would be given the component name `bar.**T`.
    pointer_only: bool = false,

    /// Configure auto-registration behavior for this type.
    ///
    /// By default the type is registered as a component in most cases, but in
    /// certain contexts it can be registered as a simple entity (ID with no
    /// component-specific metadata).
    ///
    /// Use the `.component` enum variant to specify that the type should always
    /// be registered with component metadata.
    ///
    /// Use the `.global_entity` enum variant to specify that the type should
    /// always be registered as a simple entity, without component metadata.
    intended_use: IntendedUseConfig = .any,

    pub const NameConfig = union(enum) {
        auto: void,
        override: [:0]const u8,
        override_split: OverrideSplit,
        disable: void,

        pub const OverrideSplit = struct { []const u8, [:0]const u8 };
    };

    pub const IntendedUseConfig = enum {
        any,
        component,
        global_entity,
    };
};

/// Identifier used to look up entities and components within a Flecs world.
pub const Id = enum(c.ecs_entity_t) {
    _,

    /// Return the ID associated with a given type.
    pub inline fn of(comptime T: type) Id {
        return @enumFromInt(Id, IdStorage(T).get());
    }

    /// Special identifier used to request defaults or signal errors.
    ///
    /// Using this constant is discouraged as it defeats the purpose of Zig's
    /// optional types and error handling systems.
    pub const null_id = @enumFromInt(Id, 0);

    /// Unwrap an ID into a value guaranteed not to be `Id.null_id`.
    ///
    /// The existence of `Id.null_id` circumvents the Zig optional system but is
    /// unfortunately necessary for ABI reasons and the fact that Zig optionals
    /// cannot do optimizations for null enum variants. APIs should ideally not
    /// return `Id.null_id`, but when they do this function can be used to convert
    /// the possibly-null ID into a Zig optional.
    pub inline fn nonNull(id: Id) ?Id {
        return switch (id) {
            null_id => null,
            else => id,
        };
    }

    /// Create a pair describing the relationship between `first` and `second`.
    pub inline fn pair(first: anytype, second: anytype) Id {
        const First = @TypeOf(first);
        const Second = @TypeOf(second);

        const first_id = if (First == Id)
            first
        else if (First == Entity or First == EntityView)
            first.id
        else if (First == type)
            Id.of(first)
        else if (comptime std.meta.trait.isSingleItemPtr(First) and std.meta.Child(First) == Id)
            @compileError("Cannot derive entity ID from " ++ @typeName(First) ++ "; if using method call syntax, try dereferencing the pointer first")
        else
            @compileError("Cannot derive entity ID from " ++ @typeName(First));

        const second_id = if (Second == Id)
            second
        else if (Second == Entity or Second == EntityView)
            second.id
        else if (Second == type)
            Id.of(second)
        else
            @compileError("Cannot derive entity ID from " ++ @typeName(Second));

        comptime std.debug.assert(@TypeOf(first_id) == Id); // Sanity check.
        comptime std.debug.assert(@TypeOf(second_id) == Id); // Sanity check.

        return @enumFromInt(Id, c.ECS_PAIR | (
            (@intFromEnum(first_id) << 32) +
            @truncate(u32, @intFromEnum(second_id))
        ));
    }

    /// Strip the generation count from the ID.
    pub inline fn withoutGeneration(id: Id) Id {
        return @enumFromInt(Id, c.ecs_strip_generation(@intFromEnum(id)));
    }
};

/// A mutable handle to an entity associated with a Flecs world.
pub const Entity = extern struct {
    world: *World,
    id: Id,

    /// Associate an existing entity type or ID with a world or stage.
    pub inline fn init(world: *World, id_or_type: anytype) Entity {
        const ParamType = @TypeOf(id_or_type);
        return switch (ParamType) {
            Entity, EntityView => init(world, id_or_type.id),
            type => init(world, Id.of(id_or_type)),
            Id => .{ .world = world, .id = id_or_type },
            else => @compileError("Cannot derive entity ID from " ++ @typeName(ParamType)),
        };
    }

    /// Return the `EntityView` corresponding to `entity` in its original world.
    pub inline fn view(entity: Entity) EntityView {
        return EntityView.init(entity.world, entity.id);
    }

    /// Return the `EntityView` corresponding to `entity`, leaving the value of
    /// `entity.world` as-is even if it is a stage.
    pub inline fn viewKeepStage(entity: Entity) EntityView {
        return EntityView.initKeepStage(entity.world, entity.id);
    }

    /// Reinterpret `entity` as an `EntityView` without attempting to ascertain
    /// the original world in the case that `entity.world` is actually a stage.
    pub inline fn asView(entity: *const Entity) *const EntityView {
        return @ptrCast(*const EntityView, entity);
    }

    /// Create a new entity with an `(IsA, prefab)` relationship.
    pub inline fn instantiate(prefab: Entity) Entity {
        return prefab.world.newWithId(
            Id.pair(flecs.IsA, prefab.id),
        );
    }

    /// Delete the entity from the world it is associated with.
    pub inline fn delete(entity: Entity) void {
        entity.world.delete(entity.id);
    }

    /// Add a component to an entity.
    ///
    /// This operation adds a single component to the entity. If the entity
    /// already has the specified component, calling this function has no side
    /// effects.
    pub inline fn add(entity: Entity, comptime Component: type) void {
        entity.addId(Id.of(Component));
    }

    /// Add a component ID to an entity.
    ///
    /// This operation adds a single component to the entity. If the entity
    /// already has this component, calling this function has no side effects.
    pub inline fn addId(entity: Entity, component: Id) void {
        c.ecs_add_id(
            @ptrCast(*c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            @intFromEnum(component),
        );
    }

    /// Remove a component from an entity.
    ///
    /// This operation removes a single component from the entity. If the entity
    /// does not have the specified component, calling this function has no side
    /// effects.
    pub inline fn remove(entity: Entity, comptime Component: type) void {
        entity.removeId(Id.of(Component));
    }

    /// Remove a component ID from an entity.
    ///
    /// This operation removes a single component from the entity. If the entity
    /// does not have the specified component, calling this function has no side
    /// effects.
    pub inline fn removeId(entity: Entity, component: Id) void {
        c.ecs_remove_id(
            @ptrCast(*c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            @intFromEnum(component),
        );
    }

    /// Add a component override to an entity.
    ///
    /// Adding an override to an entity ensures that when the entity is instantiated,
    /// the component with the override is copied to a component that is private to
    /// the instance. By default, components reachable through an `IsA` relationship
    /// are shared.
    ///
    /// Adding an override does not add the component. If an override is added to
    /// an entity that does not have the component, it will still be added to the
    /// instance, but with an uninitialized value (unless the component has a
    /// constructor). When the entity does have the entity, the compnent of the
    /// instance will be initialized with the value of the component on the entity.
    ///
    /// This is the same as what happens when calling `add` for a component that is
    /// inherited (reachable through an `IsA` relationship).
    pub inline fn override(entity: Entity, comptime Component: type) void {
        entity.overrideId(Id.of(Component));
    }

    /// Add a component ID override to an entity.
    ///
    /// Adding an override to an entity ensures that when the entity is instantiated,
    /// the component with the override is copied to a component that is private to
    /// the instance. By default, components reachable through an `IsA` relationship
    /// are shared.
    ///
    /// Adding an override does not add the component. If an override is added to
    /// an entity that does not have the component, it will still be added to the
    /// instance, but with an uninitialized value (unless the component has a
    /// constructor). When the entity does have the entity, the compnent of the
    /// instance will be initialized with the value of the component on the entity.
    ///
    /// This is the same as what happens when calling `addId` for a component ID
    /// that is inherited (reachable through an `IsA` relationship).
    pub inline fn overrideId(entity: Entity, component: Id) void {
        c.ecs_override_id(
            @ptrCast(*c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            @intFromEnum(component),
        );
    }

    /// Clear all components from an entity.
    ///
    /// This operation will clear all components from the entity but will not
    /// delete the entity itself. This effectively prevents the entity ID from
    /// being recycled.
    pub inline fn clear(entity: Entity) void {
        c.ecs_clear(
            @ptrCast(*c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
        );
    }

    /// Enable or disable an entity.
    ///
    /// This operation enables or disables an entity by adding or removing the
    /// `Disabled` tag. A disabled entity will not be matched with any systems,
    /// unless the system explicitly specifies the `Disabled` tag.
    pub inline fn enable(entity: Entity, enabled: bool) void {
        c.ecs_enable(
            @ptrCast(*c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            enabled,
        );
    }

    /// Enable or disable a component on an entity.
    ///
    /// Enabling or disabling a component does not add or remove a component
    /// from the entity, but prevents it from being matched with queries. This
    /// operation can be useful when a component must be temporarily disabled
    /// without destroying its value. It is also a more performant operation for
    /// when an application needs to add/remove components at a high frequency,
    /// as enabling/disabling is cheaper than a regular add or remove.
    pub inline fn enableComponent(entity: Entity, comptime Component: type, enabled: bool) void {
        entity.enableId(Id.of(Component), enabled);
    }

    /// Enable or disable a component ID on an entity.
    ///
    /// Enabling or disabling a component does not add or remove a component
    /// from the entity, but prevents it from being matched with queries. This
    /// operation can be useful when a component must be temporarily disabled
    /// without destroying its value. It is also a more performant operation for
    /// when an application needs to add/remove components at a high frequency,
    /// as enabling/disabling is cheaper than a regular add or remove.
    pub inline fn enableId(entity: Entity, component: Id, enabled: bool) void {
        c.ecs_enable_id(
            @ptrCast(*c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            @intFromEnum(component),
            enabled,
        );
    }

    /// Test if a component is enabled on an entity.
    ///
    /// This operation will return true when the entity has a component
    /// that has not been disabled by `enableComponent`.
    pub inline fn componentEnabled(entity: Entity, comptime Component: type) bool {
        return entity.idEnabled(Id.of(Component));
    }

    /// Test if a component ID is enabled on an entity.
    ///
    /// This operation will return true when the entity has a component ID
    /// that has not been disabled by `enableId`.
    pub inline fn idEnabled(entity: Entity, component: Id) bool {
        return entity.viewKeepStage().idEnabled(component);
    }

    /// Get an immutable pointer to a component.
    ///
    /// This operation obtains a `const` pointer to the requested component.
    /// If the entity does not have the component, the returned pointer is `null`.
    pub inline fn get(entity: Entity, comptime Component: type) ?*const Component {
        return entity.getId(Id.of(Component));
    }

    /// Get an immutable pointer to a component.
    ///
    /// This operation obtains a `const` pointer to the requested component.
    /// If the entity does not have the component, the returned pointer is `null`.
    ///
    /// Caller is responsible for casting the returned pointer to the correct type.
    pub inline fn getId(entity: Entity, component: Id) ?*const anyopaque {
        return entity.viewKeepStage().getId(component);
    }

    /// Get a mutable pointer to a component.
    ///
    /// This operation returns a mutable pointer to a component. If the component
    /// did not yet exist, it will be added.
    ///
    /// If `getMut` is called when the world is in deferred/readonly mode, the
    /// function will:
    ///  - return a pointer to temporary storage if the component does not yet exist, or
    ///  - return a pointer to the existing component if it exists
    pub inline fn getMut(entity: Entity, comptime Component: type) *Component {
        const erased_ptr = entity.getMutId(Id.of(Component));
        const aligned_ptr = @alignCast(@alignOf(Component), erased_ptr);
        return @ptrCast(*Component, aligned_ptr);
    }

    /// Get a mutable pointer to a component.
    ///
    /// This operation returns a mutable pointer to a component. If the component
    /// did not yet exist, it will be added.
    ///
    /// If `getMutId` is called when the world is in deferred/readonly mode, the
    /// function will:
    ///  - return a pointer to temporary storage if the component does not yet exist, or
    ///  - return a pointer to the existing component if it exists
    ///
    /// Caller is responsible for casting the returned pointer to the correct type.
    pub inline fn getMutId(entity: Entity, component: Id) *anyopaque {
        return c.ecs_get_mut_id(
            @ptrCast(*c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            @intFromEnum(component),
        );
    }

    /// Signal that a component has been modified.
    ///
    /// This operation signals to Flecs that a component has been modified. As a
    /// result, `OnSet` systems will be invoked.
    ///
    /// This operation is commonly used together with `getMut`.
    pub inline fn modified(entity: Entity, comptime Component: type) void {
        entity.modifiedId(Id.of(Component));
    }

    /// Signal that a component has been modified.
    ///
    /// This operation signals to Flecs that a component has been modified. As a
    /// result, `OnSet` systems will be invoked.
    ///
    /// This operation is commonly used together with `getMutId`.
    pub inline fn modifiedId(entity: Entity, component: Id) void {
        c.ecs_modified_id(
            @ptrCast(*c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            @intFromEnum(component),
        );
    }

    /// Set the value of a component.
    ///
    /// This operation is equivalent to calling `getMut` and `modified`.
    pub inline fn set(entity: Entity, comptime Component: type, ptr: *const Component) void {
        entity.setId(Id.of(Component), @sizeOf(Component), ptr);
    }

    /// Set the value of a component.
    ///
    /// This operation is equivalent to calling `getMutId` and `modifiedId`.
    pub inline fn setId(entity: Entity, component: Id, size: usize, ptr: *const anyopaque) void {
        _ = c.ecs_set_id(
            @ptrCast(*c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            @intFromEnum(component),
            size,
            ptr,
        );
    }

    /// Test whether an entity is valid.
    ///
    /// Entities that are valid can be used with API functions.
    ///
    /// An entity is valid if it is not 0 and is alive.
    ///
    /// This function will return for IDs that do not exist (alive or not alive).
    /// This allows for using IDs that have never been created by `World.new` or
    /// similar. In this the function differs from `isAlive`, which will return
    /// false for entities that do not yet exist.
    ///
    /// The operation will return false for an ID that exists and is not alive, as
    /// using this ID with an API operation would cause it to assert.
    pub inline fn isValid(entity: Entity) bool {
        return entity.world.isValid(entity.id);
    }

    /// Test whether an entity is alive.
    ///
    /// An entity is alive when it has been returned by `World.new` (or similar)
    /// or if it is not empty (components have been explicitly added to the ID).
    pub inline fn isAlive(entity: Entity) bool {
        return entity.world.isAlive(entity.id);
    }
};

/// A read-only view of an entity associated with a Flecs world.
pub const EntityView = extern struct {
    world: *const World,
    id: Id,

    /// Associate an existing entity type or ID with a world.
    ///
    /// `id_or_type` may be one of the following:
    ///  - An `Id`, which is stored as-is in the returned `EntityView`.
    ///  - An `Entity` or `EntityView`; the `id` field is used as the entity ID.
    ///  - A `type` representing a component or global entity (e.g. `WorldEntity`).
    ///
    /// If the provided `world` is actually a stage, the result will instead be
    /// associated with the world that created the stage.
    pub inline fn init(world: *const World, id_or_type: anytype) EntityView {
        return initKeepStage(@ptrCast(*const World, c.ecs_get_world(world)), id_or_type);
    }

    /// Associate an existing entity type or ID with a world.
    ///
    /// `id_or_type` may be one of the following:
    ///  - An `Id`, which is stored as-is in the returned `EntityView`.
    ///  - An `Entity` or `EntityView`; the `id` field is used as the entity ID.
    ///  - A `type` representing a component or global entity (e.g. `WorldEntity`).
    ///
    /// The provided `world` is left as-is, even if it is a stage.
    pub inline fn initKeepStage(world: *const World, id_or_type: anytype) EntityView {
        const ParamType = @TypeOf(id_or_type);
        return switch (ParamType) {
            Entity, EntityView => initKeepStage(world, id_or_type.id),
            type => initKeepStage(world, Id.of(id_or_type)),
            Id => .{ .world = world, .id = id_or_type },
            else => @compileError("Cannot derive entity ID from " ++ @typeName(ParamType)),
        };
    }

    /// Test if a component is enabled on an entity.
    ///
    /// This operation will return true when the entity has a component
    /// that has not been disabled by `Entity.enableComponent`.
    pub inline fn componentEnabled(entity: EntityView, comptime Component: type) bool {
        return entity.idEnabled(Id.of(Component));
    }

    /// Test if a component ID is enabled on an entity.
    ///
    /// This operation will return true when the entity has a component ID
    /// that has not been disabled by `Entity.enableId`.
    pub inline fn idEnabled(entity: EntityView, component: Id) bool {
        return c.ecs_is_enabled_id(
            @ptrCast(*const c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            @intFromEnum(component),
        );
    }

    /// Get an immutable pointer to a component.
    ///
    /// This operation obtains a `const` pointer to the requested component.
    /// If the entity does not have the component, the returned pointer is `null`.
    pub inline fn get(entity: EntityView, comptime Component: type) ?*const Component {
        const erased_ptr = entity.getId(Id.of(Component));
        const aligned_ptr = @alignCast(@alignOf(Component), erased_ptr);
        return @ptrCast(?*const Component, aligned_ptr);
    }

    /// Get an immutable pointer to a component.
    ///
    /// This operation obtains a `const` pointer to the requested component.
    /// If the entity does not have the component, the returned pointer is `null`.
    ///
    /// Caller is responsible for casting the returned pointer to the correct type.
    pub inline fn getId(entity: EntityView, component: Id) ?*const anyopaque {
        return c.ecs_get_id(
            @ptrCast(*const c.ecs_world_t, entity.world),
            @intFromEnum(entity.id),
            @intFromEnum(component),
        );
    }

    /// Test whether an entity is valid.
    ///
    /// Entities that are valid can be used with API functions.
    ///
    /// An entity is valid if it is not 0 and is alive.
    ///
    /// This function will return for IDs that do not exist (alive or not alive).
    /// This allows for using IDs that have never been created by `World.new` or
    /// similar. In this the function differs from `isAlive`, which will return
    /// false for entities that do not yet exist.
    ///
    /// The operation will return false for an ID that exists and is not alive, as
    /// using this ID with an API operation would cause it to assert.
    pub inline fn isValid(entity: EntityView) bool {
        return entity.world.isValid(entity.id);
    }

    /// Test whether an entity is alive.
    ///
    /// An entity is alive when it has been returned by `World.new` (or similar)
    /// or if it is not empty (components have been explicitly added to the ID).
    pub inline fn isAlive(entity: EntityView) bool {
        return entity.world.isAlive(entity.id);
    }
};
