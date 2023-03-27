const std = @import("std");
const builtin = @import("builtin");

const flecs = @import("lzflecs.zig");
const c = flecs.c;
const enabled_addons = flecs.enabled_addons;
const entities = flecs.entities;
const World = flecs.World;

const ExternDecl = blk: {
    @setEvalBranchQuota(@typeInfo(c).Struct.decls.len * 2);
    break :blk std.meta.DeclEnum(c);
};

/// Identifier used to look up entities and components within a Flecs world.
pub const Id = enum(c.ecs_entity_t) {
    _,

    /// Return the ID associated with a given type.
    pub inline fn of(comptime T: type) Id {
        return @intToEnum(Id, IdStorage(T).get());
    }

    /// Special identifier used to request defaults or signal errors.
    ///
    /// Using this constant is discouraged as it defeats the purpose of Zig's
    /// optional types and error handling systems.
    pub const null_id = @intToEnum(Id, 0);

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

        return @intToEnum(Id, c.ECS_PAIR | (
            (@enumToInt(first_id) << 32) +
            @truncate(u32, @enumToInt(second_id))
        ));
    }

    pub inline fn withoutGeneration(id: Id) Id {
        return @intToEnum(Id, c.ecs_strip_generation(@enumToInt(id)));
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
            @enumToInt(entity.id),
            @enumToInt(component),
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
            @enumToInt(entity.id),
            @enumToInt(component),
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
            @enumToInt(entity.id),
            @enumToInt(component),
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
            @enumToInt(entity.id),
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
            @enumToInt(entity.id),
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
            @enumToInt(entity.id),
            @enumToInt(component),
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
            @enumToInt(entity.id),
            @enumToInt(component),
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
            @enumToInt(entity.id),
            @enumToInt(component),
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
            @enumToInt(entity.id),
            @enumToInt(component),
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
            @enumToInt(entity.id),
            @enumToInt(component),
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
            @enumToInt(entity.id),
            @enumToInt(component),
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

/// Internal container that provides a global variable that can hold dynamically
/// assigned component IDs and global entity IDs.
///
/// Builtin Flecs types are automatically resolved to their corresponding entity
/// ID rather than being assigned an ID through this scheme.
pub fn IdStorage(comptime T: type) type {
    comptime validateGlobalEntityType(T);
    return struct {
        var reset_count: u64 = 0;
        var value: c.ecs_entity_t = 0;

        pub const type_info = idStorageTypeInfo(T);
        pub const permitted_registrations = type_info.permittedRegistrations();
        pub const type_name: ?[:0]const u8 = switch (type_info) {
            .user_defined => @typeName(T),
            .builtin => |builtin_info| builtin_info.type_name,
        };

        pub inline fn get() c.ecs_entity_t {
            switch (type_info) {
                .user_defined => {
                    if (builtin.is_test and reset_count != id_tracker.reset_count) {
                        return 0;
                    }
                    return value;
                },
                .builtin => |builtin_info| {
                    return @field(c, @tagName(builtin_info.extern_decl));
                },
            }
        }

        pub inline fn set(new_value: c.ecs_entity_t) void {
            switch (type_info) {
                .user_defined => {
                    value = new_value;
                    if (builtin.is_test) {
                        reset_count = id_tracker.reset_count;
                    }
                },
                .builtin => |builtin_info| {
                    @field(c, @tagName(builtin_info.extern_decl)) = new_value;
                },
            }
        }
    };
}

pub const IdStorageTypeInfo = union(enum) {
    user_defined: UserDefined,
    builtin: Builtin,

    pub const UserDefined = struct {
        name: ?[:0]const u8 = null,
        symbol: ?[:0]const u8 = null,

        inline fn init(comptime T: type) UserDefined {
            comptime {
                switch (@typeInfo(T)) {
                    .Struct, .Union, .Enum, .Opaque => {},
                    else => return .{},
                }

                const type_name = @typeName(T);

                const name: ?[:0]const u8 = if (@hasDecl(T, "flecs_name"))
                    T.flecs_name
                else
                    type_name;

                const symbol: ?[:0]const u8 = blk: {
                    if (@hasDecl(T, "flecs_symbol")) break :blk T.flecs_symbol;
                    if (!std.mem.endsWith(u8, type_name, ")")) {
                        if (std.mem.lastIndexOfScalar(u8, type_name, '.')) |last_separator| {
                            break :blk type_name[(last_separator + 1).. :0];
                        } else {
                            break :blk type_name;
                        }
                    }
                    break :blk null;
                };

                return .{
                    .name = name,
                    .symbol = symbol,
                };
            }
        }
    };

    pub const Builtin = struct {
        extern_decl: ExternDecl,
        type_name: ?[:0]const u8 = null,
        permitted_registrations: PermittedRegistrations = .none,
    };

    pub const PermittedRegistrations = enum {
        none,
        any,
        component,
        global_entity,

        const EcsWorldStats: PermittedRegistrations = .component;
        const EcsPipelineStats: PermittedRegistrations = .component;
    };

    inline fn permittedRegistrations(type_info: IdStorageTypeInfo) PermittedRegistrations {
        return switch (type_info) {
            .user_defined => .any,
            .builtin => |builtin_info| builtin_info.permitted_registrations,
        };
    }
};

fn idStorageTypeInfo(comptime T: type) IdStorageTypeInfo {
    const UserDefined = IdStorageTypeInfo.UserDefined;
    const PermittedRegistrations = IdStorageTypeInfo.PermittedRegistrations;
    comptime {
        if (@as(?ExternDecl, switch (T) {
            flecs.QueryTag => .EcsQuery,
            flecs.ObserverTag => .EcsObserver,
            flecs.SystemTag => .EcsSystem,
            flecs.WorldEntity => .EcsWorld,

            // `FLECS_MONITOR` addon.
            flecs.FlecsMonitor => .FLECS__EFlecsMonitor,

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
        })) |override_decl| {
            return .{
                .builtin = .{
                    .extern_decl = override_decl,
                },
            };
        }

        const type_name = @typeName(T);
        const base_name = blk: {
            if (!std.mem.endsWith(u8, type_name, ")")) {
                if (std.mem.lastIndexOfScalar(u8, type_name, '.')) |last_separator| {
                    break :blk type_name[(last_separator + 1).. :0];
                }
            }
            break :blk type_name;
        };


        if (@hasDecl(entities, base_name)) {
            if (@field(entities, base_name) != T) {
                return .{
                    .user_defined = UserDefined.init(T),
                };
            }

            const ecs_base_name: [:0]const u8 = "Ecs" ++ base_name;
            const extern_decl = if (@hasDecl(c, ecs_base_name))
                @field(ExternDecl, ecs_base_name)
            else
                @field(ExternDecl, "FLECS__E" ++ ecs_base_name);

            return .{
                .builtin = .{
                    .extern_decl = extern_decl,
                },
            };
        }

        if (@hasDecl(c, base_name) and @TypeOf(@field(c, base_name)) == type) {
            if (@field(c, base_name) != T) {
                return .{
                    .user_defined = UserDefined.init(T),
                };
            }

            const extern_decl = @field(ExternDecl, "FLECS__E" ++ base_name);

            const permitted_registrations = if (@hasDecl(PermittedRegistrations, base_name))
                @field(PermittedRegistrations, base_name)
            else
                PermittedRegistrations.none;

            return .{
                .builtin = .{
                    .extern_decl = extern_decl,
                    .type_name = base_name,
                    .permitted_registrations = permitted_registrations,
                },
            };
        }

        return .{
            .user_defined = UserDefined.init(T),
        };
    }
}

fn validateGlobalEntityType(comptime T: type) void {
    comptime switch (@typeInfo(T)) {
        .Struct, .Union, .Enum => {},

        .Type, .Void, .NoReturn, .Array, .ComptimeFloat, .ComptimeInt,
        .Undefined, .Null, .Optional, .ErrorUnion, .ErrorSet,
        .Fn, .Opaque, .Frame, .AnyFrame, .Vector, .EnumLiteral => @compileError(
            "Cannot use " ++ @typeName(T) ++ " as a component",
        ),

        .Bool => @compileError(
            "Cannot use bool as a component: try flecs.bool",
        ),

        .Int, .Float => switch (T) {
            u8 => @compileError(
                "Cannot use u8 as a component: try flecs.char, flecs.byte, or flecs.u8",
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
}

// /// Container that associates a builtin Flecs type with an entity ID.
// fn BuiltinId(comptime T: type) ?type {
//     @setEvalBranchQuota(@typeInfo(c).Struct.decls.len * 2);
//
//     comptime var mutable_builtin = false;
//     comptime var type_name_: ?[:0]const u8 = null;
//     comptime var decl: ?std.meta.DeclEnum(c) = switch (T) {
//         c.EcsComponent => .FLECS__EEcsComponent,
//         c.EcsIdentifier => .FLECS__EEcsIdentifier,
//         c.EcsIterable => .FLECS__EEcsIterable,
//         c.EcsPoly => .FLECS__EEcsPoly,
//
//         Id => .FLECS__Eecs_entity_t,
//
//         flecs.IsA => .EcsIsA,
//
//         else => null,
//     };
//
//     if (decl == null and enabled_addons.rest) {
//         decl = switch (T) {
//             c.EcsRest => .FLECS__EEcsRest,
//             else => null,
//         };
//     }
//
//     if (decl == null and enabled_addons.timer) {
//         decl = switch (T) {
//             c.EcsTimer => .FLECS__EEcsTimer,
//             c.EcsRateFilter => .FLECS__EEcsRateFilter,
//             else => null,
//         };
//     }
//
//     if (decl == null and enabled_addons.system) {
//         decl = switch (T) {
//             c.EcsTickSource => .FLECS__EEcsTickSource,
//             else => null,
//         };
//     }
//
//     if (decl == null and enabled_addons.monitor) {
//         switch (T) {
//             c.EcsWorldStats => {
//                 mutable_builtin = true;
//                 type_name_ = "EcsWorldStats";
//                 decl = .FLECS__EEcsWorldStats;
//             },
//             c.EcsPipelineStats => {
//                 mutable_builtin = true;
//                 type_name_ = "EcsPipelineStats";
//                 decl = .FLECS__EEcsPipelineStats;
//             },
//             else => {},
//         }
//     }
//
//     if (decl == null and enabled_addons.doc) {
//         decl = switch (T) {
//             c.EcsDocDescription => .FLECS__EEcsDocDescription,
//             else => null,
//         };
//     }
//
//     if (decl == null and enabled_addons.meta) {
//         decl = switch (T) {
//             c.EcsMetaType => .FLECS__EEcsMetaType,
//             c.EcsMetaTypeSerialized => .FLECS__EEcsMetaTypeSerialized,
//             c.EcsPrimitive => .FLECS__EEcsPrimitive,
//             c.EcsEnum => .FLECS__EEcsEnum,
//             c.EcsBitmask => .FLECS__EEcsBitmask,
//             c.EcsMember => .FLECS__EEcsMember,
//             c.EcsStruct => .FLECS__EEcsStruct,
//             c.EcsArray => .FLECS__EEcsArray,
//             c.EcsVector => .FLECS__EEcsVector,
//             c.EcsOpaque => .FLECS__EEcsOpaque,
//             c.EcsUnit => .FLECS__EEcsUnit,
//             c.EcsUnitPrefix => .FLECS__EEcsUnitPrefix,
//             else => null,
//         };
//     }
//
//     if (decl == null) return null;
//     return struct {
//         pub inline fn get() c.ecs_entity_t {
//             return @field(c, @tagName(decl.?));
//         }
//
//         pub usingnamespace if (mutable_builtin) struct {
//             pub inline fn set(new_value: c.ecs_entity_t) void {
//                 @field(c, @tagName(decl.?)) = new_value;
//
//                 if (builtin.is_test) {
//                     id_tracker.add(&@field(c, @tagName(decl.?)));
//                 }
//             }
//
//             pub const type_name = type_name_.?;
//         } else struct {};
//     };
// }

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
    }
};
