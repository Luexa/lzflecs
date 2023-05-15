pub const EcsWorldQuitWorkers = 1 << 0;
pub const EcsWorldReadonly = 1 << 1;
pub const EcsWorldInit = 1 << 2;
pub const EcsWorldQuit = 1 << 3;
pub const EcsWorldFini = 1 << 4;
pub const EcsWorldMeasureFrameTime = 1 << 5;
pub const EcsWorldMeasureSystemTime = 1 << 6;
pub const EcsWorldMultiThreaded = 1 << 7;

pub const EcsOsApiHighResolutionTimer = 1 << 0;
pub const EcsOsApiLogWithColors = 1 << 1;
pub const EcsOsApiLogWithTimeStamp = 1 << 2;
pub const EcsOsApiLogWithTimeDelta = 1 << 3;

pub const EcsEntityIsId = 1 << 31;
pub const EcsEntityIsTarget = 1 << 30;
pub const EcsEntityIsTraversable = 1 << 29;

pub const EcsIdOnDeleteRemove = 1 << 0;
pub const EcsIdOnDeleteDelete = 1 << 1;
pub const EcsIdOnDeletePanic = 1 << 2;
pub const EcsIdOnDeleteMask = (
    EcsIdOnDeleteRemove |
    EcsIdOnDeleteDelete |
    EcsIdOnDeletePanic
);

pub const EcsIdOnDeleteObjectRemove = 1 << 3;
pub const EcsIdOnDeleteObjectDelete = 1 << 4;
pub const EcsIdOnDeleteObjectPanic = 1 << 5;
pub const EcsIdOnDeleteObjectMask =
    EcsIdOnDeleteObjectPanic |
    EcsIdOnDeleteObjectRemove |
    EcsIdOnDeleteObjectDelete
;

pub const EcsIdExclusive = 1 << 6;
pub const EcsIdDontInherit = 1 << 7;
pub const EcsIdTag = 1 << 8;
pub const EcsIdWith = 1 << 9;
pub const EcsIdUnion = 1 << 11;
pub const EcsIdAlwaysOverride = 1 << 12;

pub const EcsIdHasOnAdd = 1 << 16;
pub const EcsIdHasOnRemove = 1 << 17;
pub const EcsIdHasOnSet = 1 << 18;
pub const EcsIdHasUnSet = 1 << 19;
pub const EcsIdEventMask =
    EcsIdHasOnAdd |
    EcsIdHasOnRemove |
    EcsIdHasOnSet |
    EcsIdHasUnSet
;

pub const EcsIdMarkedForDelete = 1 << 30;

pub const EcsIterIsValid = 1 << 0;
pub const EcsIterNoData = 1 << 1;
pub const EcsIterIsInstanced = 1 << 2;
pub const EcsIterHasShared = 1 << 3;
pub const EcsIterTableOnly = 1 << 4;
pub const EcsIterEntityOptional = 1 << 5;
pub const EcsIterNoResults = 1 << 6;
pub const EcsIterIgnoreThis = 1 << 7;
pub const EcsIterMatchVar = 1 << 8;
pub const EcsIterHasCondSet = 1 << 10;
pub const EcsIterProfile = 1 << 11;

pub const EcsEventTableOnly = 1 << 8;
pub const EcsEventNoOnSet = 1 << 16;

pub const EcsFilterMatchThis = 1 << 1;
pub const EcsFilterMatchOnlyThis = 1 << 2;
pub const EcsFilterMatchPrefab = 1 << 3;
pub const EcsFilterMatchDisabled = 1 << 4;
pub const EcsFilterMatchEmptyTables = 1 << 5;
pub const EcsFilterMatchAnything = 1 << 6;
pub const EcsFilterNoData = 1 << 7;
pub const EcsFilterIsInstanced = 1 << 8;
pub const EcsFilterPopulate = 1 << 9;
pub const EcsFilterHasCondSet = 1 << 10;
pub const EcsFilterUnresolvedByName = 1 << 1;

pub const EcsTableHasBuiltins = 1 << 1;
pub const EcsTableIsPrefab = 1 << 2;
pub const EcsTableHasIsA = 1 << 3;
pub const EcsTableHasChildOf = 1 << 4;
pub const EcsTableHasName = 1 << 5;
pub const EcsTableHasPairs = 1 << 6;
pub const EcsTableHasModule = 1 << 7;
pub const EcsTableIsDisabled = 1 << 8;
pub const EcsTableHasCtors = 1 << 9;
pub const EcsTableHasDtors = 1 << 10;
pub const EcsTableHasCopy = 1 << 11;
pub const EcsTableHasMove = 1 << 12;
pub const EcsTableHasUnion = 1 << 13;
pub const EcsTableHasToggle = 1 << 14;
pub const EcsTableHasOverrides = 1 << 15;

pub const EcsTableHasOnAdd = 1 << 16;
pub const EcsTableHasOnRemove = 1 << 17;
pub const EcsTableHasOnSet = 1 << 18;
pub const EcsTableHasUnSet = 1 << 19;

pub const EcsTableHasObserved = 1 << 20;
pub const EcsTableHasTarget = 1 << 21;

pub const EcsTableMarkedForDelete = 1 << 30;

pub const EcsTableHasLifecycle =
    EcsTableHasCtors |
    EcsTableHasDtors
;

pub const EcsTableIsComplex =
    EcsTableHasLifecycle |
    EcsTableHasUnion |
    EcsTableHasToggle
;

pub const EcsTableHasAddActions =
    EcsTableHasIsA |
    EcsTableHasUnion |
    EcsTableHasCtors |
    EcsTableHasOnAdd |
    EcsTableHasOnSet
;

pub const EcsTableHasRemoveActions =
    EcsTableHasIsA |
    EcsTableHasDtors |
    EcsTableHasOnRemove |
    EcsTableHasOnSet
;

pub const EcsQueryHasRefs = 1 << 1;
pub const EcsQueryIsSubquery = 1 << 2;
pub const EcsQueryIsOrphaned = 1 << 3;
pub const EcsQueryHasOutColumns = 1 << 4;
pub const EcsQueryHasMonitor = 1 << 5;
pub const EcsQueryTrivialIter = 1 << 6;

pub const EcsAperiodicEmptyTables = 1 << 1;
pub const EcsAperiodicComponentMonitors = 1 << 2;
pub const EcsAperiodicEmptyQueries = 1 << 4;

pub const EcsSelf = 1 << 1;
pub const EcsUp = 1 << 2;
pub const EcsDown = 1 << 3;
pub const EcsTraverseAll = 1 << 4;
pub const EcsCascade = 1 << 5;
pub const EcsParent = 1 << 6;
pub const EcsIsVariable = 1 << 7;
pub const EcsIsEntity = 1 << 8;
pub const EcsIsName = 1 << 9;
pub const EcsFilter = 1 << 10;

pub const EcsTraverseFlags =
    EcsUp |
    EcsDown |
    EcsTraverseAll |
    EcsSelf |
    EcsCascade |
    EcsParent
;

pub const EcsTermMatchAny = 1 << 0;
pub const EcsTermMatchAnySrc = 1 << 1;
pub const EcsTermSrcFirstEq = 1 << 2;
pub const EcsTermSrcSecondEq = 1 << 3;
pub const EcsTermTransitive = 1 << 4;
pub const EcsTermReflexive = 1 << 5;
pub const EcsTermIdInherited = 1 << 6;

pub const EcsIterNextYield = 0;
pub const EcsIterYield = -1;
pub const EcsIterNext = 1;

pub const EcsFirstUserComponentId = 8;
pub const EcsFirstUserEntityId = FLECS_HI_COMPONENT_ID + 128;

pub const ECS_ID_FLAGS_MASK: u64 = 0x0F << 60;
pub const ECS_ENTITY_MASK: u64 = 0xFFFFFFFF;
pub const ECS_GENERATION_MASK: u64 = 0xFFFF << 32;
pub const ECS_COMPONENT_MASK: u64 = ~ECS_ID_FLAGS_MASK;

pub const ECS_ROW_MASK: u32 = 0x0FFFFFFF;
pub const ECS_ROW_FLAGS_MASK: u32 = ~ECS_ROW_MASK;

pub const ECS_MAX_COMPONENT_ID: u32 = ~@intCast(u32, ECS_ID_FLAGS_MASK >> 32);

pub const FLECS_LOW_FOOTPRINT = @import("package_options").constants.low_footprint;
pub const FLECS_HI_COMPONENT_ID = @import("package_options").constants.hi_component_id;
pub const FLECS_HI_ID_RECORD_ID = @import("package_options").constants.hi_id_record_id;
pub const FLECS_SPARSE_PAGE_BITS = @import("package_options").constants.sparse_page_bits;
pub const FLECS_ENTITY_PAGE_BITS = @import("package_options").constants.entity_page_bits;
pub const FLECS_USE_OS_ALLOC = @import("package_options").constants.use_os_alloc;
pub const FLECS_ID_DESC_MAX = @import("package_options").constants.id_desc_max;
pub const FLECS_TERM_DESC_MAX = 16;
pub const FLECS_EVENT_DESC_MAX = 8;
pub const FLECS_VARIABLE_COUNT_MAX = 64;

pub const FLECS_SPARSE_PAGE_SIZE = 1 << FLECS_SPARSE_PAGE_BITS;

pub const ECS_INVALID_OPERATION = 1;
pub const ECS_INVALID_PARAMETER = 2;
pub const ECS_CONSTRAINT_VIOLATED = 3;
pub const ECS_OUT_OF_MEMORY = 4;
pub const ECS_OUT_OF_RANGE = 5;
pub const ECS_UNSUPPORTED = 6;
pub const ECS_INTERNAL_ERROR = 7;
pub const ECS_ALREADY_DEFINED = 8;
pub const ECS_MISSING_OS_API = 9;
pub const ECS_OPERATION_FAILED = 10;
pub const ECS_INVALID_CONVERSION = 11;
pub const ECS_ID_IN_USE = 12;
pub const ECS_CYCLE_DETECTED = 13;
pub const ECS_LEAK_DETECTED = 14;

pub const ECS_INCONSISTENT_NAME = 20;
pub const ECS_NAME_IN_USE = 21;
pub const ECS_NOT_A_COMPONENT = 22;
pub const ECS_INVALID_COMPONENT_SIZE = 23;
pub const ECS_INVALID_COMPONENT_ALIGNMENT = 24;
pub const ECS_COMPONENT_NOT_REGISTERED = 25;
pub const ECS_INCONSISTENT_COMPONENT_ID = 26;
pub const ECS_INCONSISTENT_COMPONENT_ACTION = 27;
pub const ECS_MODULE_UNDEFINED = 28;
pub const ECS_MISSING_SYMBOL = 29;
pub const ECS_ALREADY_IN_USE = 30;

pub const ECS_ACCESS_VIOLATION = 40;
pub const ECS_COLUMN_INDEX_OUT_OF_RANGE = 41;
pub const ECS_COLUMN_IS_NOT_SHARED = 42;
pub const ECS_COLUMN_IS_SHARED = 43;
pub const ECS_COLUMN_TYPE_MISMATCH = 45;

pub const ECS_INVALID_WHILE_READONLY = 70;
pub const ECS_LOCKED_STORAGE = 71;
pub const ECS_INVALID_FROM_WORKER = 72;


pub const ecs_flags8_t = u8;
pub const ecs_flags16_t = u16;
pub const ecs_flags32_t = u32;
pub const ecs_flags64_t = u64;

pub const ecs_id_t = u64;
pub const ecs_entity_t = ecs_id_t;

pub const ecs_float_t = @import("package_options").types.ecs_float_t;
pub const ecs_ftime_t = @import("package_options").types.ecs_ftime_t;

pub const ecs_world_t = opaque {};
pub const ecs_table_t = opaque {};
pub const ecs_query_t = opaque {};
pub const ecs_rule_t = opaque {};
pub const ecs_id_record_t = opaque {};
pub const ecs_table_record_t = opaque {};
pub const ecs_poly_t = anyopaque;
pub const ecs_mixins_t = opaque {};

pub const ecs_type_t = extern struct {
    array: ?[*]ecs_id_t,
    count: i32,
};

pub const ecs_header_t = extern struct {
    magic: i32,
    type: i32,
    mixins: ?*ecs_mixins_t,
};

pub const ecs_run_action_t = *const fn (
    it: *ecs_iter_t,
) callconv(.C) void;

pub const ecs_iter_action_t = *const fn (
    it: *ecs_iter_t,
) callconv(.C) void;

pub const ecs_iter_next_action_t = *const fn (
    it: *ecs_iter_t,
) callconv(.C) bool;

pub const ecs_iter_init_action_t = *const fn (
    world: *const ecs_world_t,
    iterable: *const ecs_poly_t,
    it: *ecs_iter_t,
    filter: ?*ecs_term_t,
) callconv(.C) void;

pub const ecs_iter_fini_action_t = *const fn (
    it: *ecs_iter_t,
) callconv(.C) void;

pub const ecs_order_by_action_t = *const fn (
    e1: ecs_entity_t,
    ptr1: ?*const anyopaque,
    e2: ecs_entity_t,
    ptr2: ?*const anyopaque,
) callconv(.C) c_int;

pub const ecs_sort_table_action_t = *const fn (
    world: *ecs_world_t,
    table: *ecs_table_t,
    entities: [*]ecs_entity_t,
    ptr: ?*anyopaque,
    size: i32,
    lo: i32,
    hi: i32,
    order_by: ecs_order_by_action_t,
) callconv(.C) void;

pub const ecs_group_by_action_t = *const fn (
    world: *ecs_world_t,
    table: *ecs_table_t,
    group_id: ecs_id_t,
    ctx: ?*anyopaque,
) callconv(.C) u64;

pub const ecs_group_create_action_t = *const fn (
    world: *ecs_world_t,
    group_id: u64,
    group_by_ctx: ?*anyopaque,
) callconv(.C) ?*anyopaque;

pub const ecs_group_delete_action_t = *const fn (
    world: *ecs_world_t,
    group_id: u64,
    group_ctx: ?*anyopaque,
    group_by_ctx: ?*anyopaque,
) callconv(.C) void;

pub const ecs_module_action_t = *const fn (
    world: *ecs_world_t,
) callconv(.C) void;

pub const ecs_fini_action_t = *const fn (
    world: *ecs_world_t,
    ctx: ?*anyopaque,
) callconv(.C) void;

pub const ecs_ctx_free_t = *const fn (
    ctx: ?*anyopaque,
) callconv(.C) void;

pub const ecs_compare_action_t = *const fn (
    ptr1: *const anyopaque,
    ptr2: *const anyopaque,
) callconv(.C) c_int;

pub const ecs_hash_value_action_t = *const fn (
    ptr: *const anyopaque,
) callconv(.C) u64;

pub const ecs_xtor_t = *const fn (
    ptr: *anyopaque,
    count: i32,
    type_info: *const ecs_type_info_t,
) callconv(.C) void;

pub const ecs_copy_t = *const fn (
    dst_ptr: *anyopaque,
    src_ptr: *const anyopaque,
    count: i32,
    type_info: *const ecs_type_info_t,
) callconv(.C) void;

pub const ecs_move_t = *const fn (
    dst_ptr: *anyopaque,
    src_ptr: *anyopaque,
    count: i32,
    type_info: *const ecs_type_info_t,
) callconv(.C) void;

pub const ecs_poly_dtor_t = *const fn (
    poly: *ecs_poly_t,
) callconv(.C) void;

pub const ecs_iterable_t = EcsIterable;

pub const ecs_inout_kind_t = enum(c_int) {
    EcsInOutDefault,
    EcsInOutNone,
    EcsInOut,
    EcsIn,
    EcsOut,
    _,
};

pub const ecs_oper_kind_t = enum(c_int) {
    EcsAnd,
    EcsOr,
    EcsNot,
    EcsOptional,
    EcsAndFrom,
    EcsOrFrom,
    EcsNotFrom,
    _,
};

pub const ecs_term_id_t = extern struct {
    id: ecs_entity_t,
    name: ?[*:0]u8,
    trav: ecs_entity_t,
    flags: ecs_flags32_t,
};

pub const ecs_term_t = extern struct {
    id: ecs_id_t,

    src: ecs_term_id_t,
    first: ecs_term_id_t,
    second: ecs_term_id_t,

    inout: ecs_inout_kind_t,
    oper: ecs_oper_kind_t,

    id_flags: ecs_id_t,
    name: ?[*:0]u8,

    field_index: i32,
    idr: ?*ecs_id_record_t,

    flags: ecs_flags16_t,

    move: bool,
};

pub const ecs_filter_t = extern struct {
    hdr: ecs_header_t,

    terms: ?[*]ecs_term_t,
    term_count: i32,
    field_count: i32,

    owned: bool,
    terms_owned: bool,

    flags: ecs_flags32_t,

    variable_names: [1]?[*:0]u8,
    sizes: ?[*]i32,

    entity: ecs_entity_t,
    iterable: ecs_iterable_t,
    dtor: ?ecs_poly_dtor_t,
    world: ?*ecs_world_t,
};

pub const ecs_observer_t = extern struct {
    hdr: ecs_header_t,

    filter: ecs_filter_t,

    events: [FLECS_EVENT_DESC_MAX]ecs_entity_t,
    event_count: i32,

    callback: ?ecs_iter_action_t,
    run: ?ecs_run_action_t,

    ctx: ?*anyopaque,
    binding_ctx: ?*anyopaque,

    ctx_free: ?ecs_ctx_free_t,
    binding_ctx_free: ?ecs_ctx_free_t,

    observable: ?*ecs_observable_t,

    last_event_id: ?*i32,
    last_event_id_storage: i32,

    register_id: ecs_id_t,
    term_index: i32,

    is_monitor: bool,
    is_multi: bool,

    dtor: ?ecs_poly_dtor_t,
};

pub const ecs_type_hooks_t = extern struct {
    ctor: ?*const fn (ptr: *anyopaque, count: i32, type_info: *const ecs_type_info_t) callconv(.C) void,
    dtor: ?*const fn (ptr: *anyopaque, count: i32, type_info: *const ecs_type_info_t) callconv(.C) void,
    copy: ?ecs_copy_t,
    move: ?ecs_move_t,

    copy_ctor: ?ecs_copy_t,
    move_ctor: ?ecs_move_t,

    ctor_move_dtor: ?ecs_move_t,
    move_dtor: ?ecs_move_t,

    on_add: ?ecs_iter_action_t,
    on_set: ?ecs_iter_action_t,
    on_remove: ?ecs_iter_action_t,

    ctx: ?*anyopaque,
    binding_ctx: ?*anyopaque,

    ctx_free: ?ecs_ctx_free_t,
    binding_ctx_free: ?ecs_ctx_free_t,
};

pub const ecs_type_info_t = extern struct {
    size: i32,
    alignment: i32,
    hooks: ecs_type_hooks_t,
    component: ecs_entity_t,
    name: ?[*:0]const u8,
};

pub const ecs_vec_t = extern struct {
    array: ?*anyopaque,
    count: i32,
    size: i32,
};

pub const ecs_block_allocator_block_t = extern struct {
    memory: ?*anyopaque,
    next: ?*ecs_block_allocator_block_t,
};

pub const ecs_block_allocator_chunk_header_t = extern struct {
    next: ?*ecs_block_allocator_chunk_header_t,
};

pub const ecs_block_allocator_t = extern struct {
    head: ?*ecs_block_allocator_chunk_header_t,
    block_head: ?*ecs_block_allocator_block_t,
    block_tail: ?*ecs_block_allocator_block_t,
    chunk_size: i32,
    data_size: i32,
    chunks_per_block: i32,
    block_size: i32,
    alloc_count: i32,
};

pub const ecs_sparse_t = extern struct {
    dense: ecs_vec_t,
    pages: ecs_vec_t,
    size: i32,
    count: i32,
    max_id: u64,
    allocator: ?*ecs_allocator_t,
    page_allocator: ?*ecs_block_allocator_t,
};

pub const ecs_allocator_t = extern struct {
    chunks: ecs_block_allocator_t,
    sizes: ecs_sparse_t,
};

pub const ecs_map_data_t = u64;
pub const ecs_map_key_t = ecs_map_data_t;
pub const ecs_map_val_t = ecs_map_data_t;

pub const ecs_bucket_entry_t = extern struct {
    key: ecs_map_key_t,
    value: ecs_map_val_t,
    next: ?*ecs_bucket_entry_t,
};

pub const ecs_bucket_t = extern struct {
    first: ?*ecs_bucket_entry_t,
};

pub const ecs_map_t = extern struct {
    bucket_shift: u8,
    shared_allocator: bool,
    buckets: ?[*]ecs_bucket_t,
    bucket_count: i32,
    count: i32,
    entry_allocator: ?*ecs_block_allocator_t,
    allocator: ?*ecs_allocator_t,
};

pub const ecs_map_iter_t = extern struct {
    map: ?*const ecs_map_t,
    bucket: ?*ecs_bucket_t,
    entry: ?*ecs_bucket_entry_t,
    res: ?*ecs_map_data_t,
};

pub const ecs_map_params_t = extern struct {
    allocator: ?*ecs_allocator_t,
    entry_allocator: ecs_block_allocator_t,
};

pub const ecs_strbuf_element = extern struct {
    buffer_embedded: bool,
    pos: i32,
    buf: ?[*]u8,
    next: ?*ecs_strbuf_element,
};

pub const ecs_strbuf_element_embedded = extern struct {
    super: ecs_strbuf_element,
    buf: [512]u8,
};

pub const ecs_strbuf_element_str = extern struct {
    super: ecs_strbuf_element,
    alloc_str: [*:0]u8,
};

pub const ecs_strbuf_list_elem = extern struct {
    count: i32,
    separator: ?[*:0]const u8,
};

pub const ecs_strbuf_t = extern struct {
    buf: ?[*]u8 = null,
    max: i32 = 0,
    size: i32 = 0,
    element_count: i32 = 0,
    first_element: ecs_strbuf_element_embedded = .{
        .super = .{
            .buffer_embedded = false,
            .pos = 0,
            .buf = null,
            .next = null,
        },
        .buf = [_]u8{ 0 } ** 512,
    },
    current: ?*ecs_strbuf_element = null,
    list_stack: [32]ecs_strbuf_list_elem = [_]ecs_strbuf_list_elem{
        .{
            .count = 0,
            .separator = null,
        },
    } ** 32,
    list_sp: i32 = 0,
    content: ?[*:0]u8 = null,
    length: i32 = 0,
};

pub const ecs_time_t = extern struct {
    sec: u32,
    nanosec: u32,
};

pub const ecs_os_api_t = extern struct {
    init: ?ecs_os_api_init_t,
    fini: ?ecs_os_api_fini_t,

    malloc: ?ecs_os_api_malloc_t,
    realloc: ?ecs_os_api_realloc_t,
    calloc: ?ecs_os_api_calloc_t,
    free: ?ecs_os_api_free_t,

    strdup: ?ecs_os_api_strdup_t,

    thread_new: ?ecs_os_api_thread_new_t,
    thread_join: ?ecs_os_api_thread_join_t,
    thread_self: ?ecs_os_api_thread_self_t,

    ainc: ?ecs_os_api_ainc_t,
    adec: ?ecs_os_api_ainc_t,
    lainc: ?ecs_os_api_lainc_t,
    ladec: ?ecs_os_api_lainc_t,

    mutex_new: ?ecs_os_api_mutex_new_t,
    mutex_free: ?ecs_os_api_mutex_free_t,
    mutex_lock: ?ecs_os_api_mutex_lock_t,
    mutex_unlock: ?ecs_os_api_mutex_unlock_t,

    cond_new: ?ecs_os_api_cond_new_t,
    cond_free: ?ecs_os_api_cond_free_t,
    cond_signal: ?ecs_os_api_cond_signal_t,
    cond_broadcast: ?ecs_os_api_cond_broadcast_t,
    cond_wait: ?ecs_os_api_cond_wait_t,

    sleep: ?ecs_os_api_sleep_t,
    now: ?ecs_os_api_now_t,
    get_time: ?ecs_os_api_get_time_t,

    log: ?ecs_os_api_log_t,

    abort: ?ecs_os_api_abort_t,

    dlopen: ?ecs_os_api_dlopen_t,
    dlproc: ?ecs_os_api_dlproc_t,
    dlclose: ?ecs_os_api_dlclose_t,

    module_to_dl: ?ecs_os_api_module_to_path_t,
    module_to_etc: ?ecs_os_api_module_to_path_t,

    log_level: i32,
    log_indent: i32,
    log_last_error: i32,
    log_last_timestamp: i64,

    flags: ecs_flags32_t,
};

pub const ecs_os_thread_t = usize;
pub const ecs_os_cond_t = usize;
pub const ecs_os_mutex_t = usize;
pub const ecs_os_dl_t = usize;
pub const ecs_os_sock_t = usize;

pub const ecs_os_thread_id_t = u64;

pub const ecs_os_proc_t = *const fn () callconv(.C) void;
pub const ecs_os_api_init_t = *const fn () callconv(.C) void;
pub const ecs_os_api_fini_t = *const fn () callconv(.C) void;
pub const ecs_os_api_malloc_t = *const fn (size: i32) callconv(.C) *anyopaque;
pub const ecs_os_api_free_t = *const fn (ptr: ?*anyopaque) callconv(.C) void;
pub const ecs_os_api_realloc_t = *const fn (ptr: ?*anyopaque, size: i32) callconv(.C) *anyopaque;
pub const ecs_os_api_calloc_t = *const fn (size: i32) callconv(.C) *anyopaque;
pub const ecs_os_api_strdup_t = *const fn (str: [*:0]const u8) callconv(.C) [*:0]u8;

pub const ecs_os_thread_callback_t = *const fn (?*anyopaque) callconv(.C) ?*anyopaque;
pub const ecs_os_api_thread_new_t = *const fn (
    callback: ecs_os_thread_callback_t,
    param: ?*anyopaque,
) callconv(.C) ecs_os_thread_t;
pub const ecs_os_api_thread_join_t = *const fn (thread: ecs_os_thread_t) callconv(.C) ?*anyopaque;
pub const ecs_os_api_thread_self_t = *const fn () callconv(.C) ecs_os_thread_id_t;

pub const ecs_os_api_ainc_t = *const fn (value: *i32) callconv(.C) i32;
pub const ecs_os_api_lainc_t = *const fn (value: *i64) callconv(.C) i64;

pub const ecs_os_api_mutex_new_t = *const fn () callconv(.C) ecs_os_mutex_t;
pub const ecs_os_api_mutex_lock_t = *const fn (mutex: ecs_os_mutex_t) callconv(.C) void;
pub const ecs_os_api_mutex_unlock_t = *const fn (mutex: ecs_os_mutex_t) callconv(.C) void;
pub const ecs_os_api_mutex_free_t = *const fn (mutex: ecs_os_mutex_t) callconv(.C) void;

pub const ecs_os_api_cond_new_t = *const fn () callconv(.C) ecs_os_cond_t;
pub const ecs_os_api_cond_free_t = *const fn (cond: ecs_os_cond_t) callconv(.C) void;
pub const ecs_os_api_cond_signal_t = *const fn (cond: ecs_os_cond_t) callconv(.C) void;
pub const ecs_os_api_cond_broadcast_t = *const fn (cond: ecs_os_cond_t) callconv(.C) void;
pub const ecs_os_api_cond_wait_t = *const fn (
    cond: ecs_os_cond_t,
    mutex: ecs_os_mutex_t,
) callconv(.C) void;

pub const ecs_os_api_sleep_t = *const fn (sec: i32, nanosec: i32) callconv(.C) void;
pub const ecs_os_api_enable_high_timer_resolution_t = *const fn (enable: bool) callconv(.C) void;
pub const ecs_os_api_get_time_t = *const fn (time_out: *ecs_time_t) callconv(.C) void;
pub const ecs_os_api_now_t = *const fn () u64;
pub const ecs_os_api_log_t = *const fn (
    level: i32,
    file: ?[*:0]const u8,
    line: i32,
    msg: [*:0]const u8,
) callconv(.C) void;

pub const ecs_os_api_abort_t = *const fn () callconv(.C) void;

pub const ecs_os_api_dlopen_t = *const fn (libname: ?[*:0]const u8) callconv(.C) ecs_os_dl_t;
pub const ecs_os_api_dlproc_t = *const fn (
    lib: ecs_os_dl_t,
    procname: [*:0]const u8,
) callconv(.C) ecs_os_proc_t;
pub const ecs_os_api_dlclose_t = *const fn (lib: ecs_os_dl_t) callconv(.C) void;
pub const ecs_os_api_module_to_path_t = *const fn (module_id: [*:0]const u8) callconv(.C) [*:0]u8;

pub const ecs_stage_t = opaque {};
pub const ecs_data_t = opaque {};
pub const ecs_switch_t = opaque {};
pub const ecs_query_table_node_t = opaque {};
pub const ecs_event_id_record_t = opaque {};
pub const ecs_stack_page_t = opaque {};
pub const ecs_table_cache_hdr_t = opaque {};
pub const ecs_rule_var_t = opaque {};
pub const ecs_rule_op_t = opaque {};
pub const ecs_rule_op_ctx_t = opaque {};

pub const ecs_event_record_t = extern struct {
    any: ?*ecs_event_id_record_t,
    wildcard: ?*ecs_event_id_record_t,
    wildcard_pair: ?*ecs_event_id_record_t,
    event_ids: ecs_map_t,
    event: ecs_entity_t,
};

pub const ecs_observable_t = extern struct {
    on_add: ecs_event_record_t,
    on_remove: ecs_event_record_t,
    on_set: ecs_event_record_t,
    un_set: ecs_event_record_t,
    on_wildcard: ecs_event_record_t,
    events: ecs_sparse_t,
};

pub const ecs_record_t = extern struct {
    idr: ?*ecs_id_record_t,
    table: ?*ecs_table_t,
    row: u32,
    dense: i32,
};

pub const ecs_table_range_t = extern struct {
    table: ?*ecs_table_t,
    offset: i32,
    count: i32,
};

pub const ecs_var_t = extern struct {
    range: ecs_table_range_t,
    entity: ecs_entity_t,
};

pub const ecs_ref_t = extern struct {
    entity: ecs_entity_t,
    id: ecs_entity_t,
    tr: ?*ecs_table_record_t,
    record: ?*ecs_record_t,
};

pub const ecs_stack_cursor_t = extern struct {
    cur: ?*ecs_stack_page_t,
    sp: i16,
};

pub const ecs_page_iter_t = extern struct {
    offset: i32,
    limit: i32,
    remaining: i32,
};

pub const ecs_worker_iter_t = extern struct {
    index: i32,
    count: i32,
};

pub const ecs_table_cache_iter_t = extern struct {
    cur: ?*ecs_table_cache_hdr_t,
    next: ?*ecs_table_cache_hdr_t,
    next_list: ?*ecs_table_cache_hdr_t,
};

pub const ecs_term_iter_t = extern struct {
    term: ecs_term_t,
    self_index: ?*ecs_id_record_t,
    set_index: ?*ecs_id_record_t,

    cur: ?*ecs_id_record_t,
    it: ecs_table_cache_iter_t,
    index: i32,
    observed_table_count: i32,

    table: ?*ecs_table_t,
    cur_match: i32,
    match_count: i32,
    last_column: i32,

    empty_tables: bool,

    id: ecs_id_t,
    column: i32,
    subject: ecs_entity_t,
    size: i32,
    ptr: ?*anyopaque,
};

pub const ecs_iter_kind_t = enum(c_int) {
    EcsIterEvalCondition,
    EcsIterEvalTables,
    EcsIterEvalChain,
    EcsIterEvalNone,
    _,
};

pub const ecs_filter_iter_t = extern struct {
    filter: ?*const ecs_filter_t,
    kind: ecs_iter_kind_t,
    term_iter: ecs_term_iter_t,
    matches_left: i32,
    pivot_term: i32,
};

pub const ecs_query_iter_t = extern struct {
    query: ?*ecs_query_t,
    node: ?*ecs_query_table_node_t,
    prev: ?*ecs_query_table_node_t,
    last: ?*ecs_query_table_node_t,
    sparse_smallest: i32,
    sparse_first: i32,
    bitset_first: i32,
    skip_count: i32,
};

pub const ecs_snapshot_iter_t = extern struct {
    filter: ecs_filter_t,
    tables: ecs_vec_t,
    index: i32,
};

pub const ecs_rule_op_profile_t = extern struct {
    count: [2]i32,
};

pub const ecs_rule_iter_t = extern struct {
    rule: ?*const ecs_rule_t,
    vars: ?[*]ecs_var_t,
    rule_vars: ?*const ecs_rule_var_t,
    ops: ?*const ecs_rule_op_t,
    op_ctx: ?*ecs_rule_op_ctx_t,

    written: ?[*]u64,

    redo: bool,
    op: i16,
    sp: i16,
};

pub const ecs_iter_cache_t = extern struct {
    stack_cursor: ecs_stack_cursor_t,
    used: ecs_flags8_t,
    allocated: ecs_flags8_t,
};

pub const ecs_iter_private_t = extern struct {
    iter: extern union {
        term: ecs_term_iter_t,
        filter: ecs_filter_iter_t,
        query: ecs_query_iter_t,
        rule: ecs_rule_iter_t,
        snapshot: ecs_snapshot_iter_t,
        page: ecs_page_iter_t,
        worker: ecs_worker_iter_t,
    },

    entity_iter: ?*anyopaque,
    cache: ecs_iter_cache_t,
};

pub const ecs_iter_t = extern struct {
    world: ?*ecs_world_t,
    real_world: ?*ecs_world_t,

    entities: ?[*]ecs_entity_t,
    ptrs: ?[*]?*anyopaque,
    sizes: ?[*]i32,
    table: ?*ecs_table_t,
    other_table: ?*ecs_table_t,
    ids: ?[*]ecs_id_t,
    variables: ?[*]ecs_var_t,
    columns: ?[*]i32,
    sources: ?[*]ecs_entity_t,
    match_indices: ?[*]i32,

    references: ?[*]ecs_ref_t,
    constrained_vars: ecs_flags64_t,
    group_id: u64,
    field_count: i32,

    system: ecs_entity_t,
    event: ecs_entity_t,
    event_id: ecs_id_t,

    terms: ?[*]ecs_term_t,
    table_count: i32,
    term_index: i32,
    variable_count: i32,
    variable_names: ?[*]?[*:0]u8,

    param: ?*anyopaque,
    ctx: ?*anyopaque,
    binding_ctx: ?*anyopaque,

    delta_time: ecs_ftime_t,
    delta_system_time: ecs_ftime_t,

    frame_offset: i32,
    offset: i32,
    count: i32,
    instance_count: i32,

    flags: ecs_flags32_t,

    interrupted_by: ecs_entity_t,

    priv: ecs_iter_private_t,

    next: ?ecs_iter_next_action_t,
    callback: ?ecs_iter_action_t,
    fini: ?ecs_iter_fini_action_t,
    chain_it: ?*ecs_iter_t,
};

pub const ecs_hm_bucket_t = extern struct {
    keys: ecs_vec_t,
    values: ecs_vec_t,
};

pub const ecs_hashmap_t = extern struct {
    hash: ?ecs_hash_value_action_t,
    compare: ?ecs_compare_action_t,
    key_size: i32,
    value_size: i32,
    hashmap_allocator: ?*ecs_block_allocator_t,
    bucket_allocator: ecs_block_allocator_t,
    impl: ecs_map_t,
};

pub const flecs_hashmap_iter_t = extern struct {
    it: ecs_map_iter_t,
    bucket: ?*ecs_hm_bucket_t,
    index: i32,
};

pub const flecs_hashmap_result_t = extern struct {
    key: ?*anyopaque,
    value: ?*anyopaque,
    hash: u64,
};

pub const ecs_entity_desc_t = extern struct {
    _canary: i32,
    id: ecs_entity_t,
    name: ?[*:0]const u8,
    sep: ?[*:0]const u8,
    root_sep: ?[*:0]const u8,
    symbol: ?[*:0]const u8,
    use_low_id: bool,
    add: [FLECS_ID_DESC_MAX]ecs_id_t,
    add_expr: ?[*:0]const u8,
};

pub const ecs_bulk_desc_t = extern struct {
    _canary: i32,
    entities: ?[*]ecs_entity_t,
    count: i32,
    ids: [FLECS_ID_DESC_MAX]ecs_id_t,
    data: ?[*]?*anyopaque,
    table: ?*ecs_table_t,
};

pub const ecs_component_desc_t = extern struct {
    _canary: i32,
    entity: ecs_entity_t,
    type: ecs_type_info_t,
};

pub const ecs_filter_desc_t = extern struct {
    _canary: i32,
    terms: [FLECS_TERM_DESC_MAX]ecs_term_t,
    terms_buffer: ?[*]ecs_term_t,
    terms_buffer_count: i32,
    storage: ?*ecs_filter_t,
    instanced: bool,
    flags: ecs_flags32_t,
    expr: ?[*:0]const u8,
    entity: ecs_entity_t,
};

pub const ecs_query_desc_t = extern struct {
    _canary: i32,
    filter: ecs_filter_desc_t,
    order_by_component: ecs_entity_t,
    order_by: ?ecs_order_by_action_t,
    sort_table: ?ecs_sort_table_action_t,
    group_by_id: ecs_id_t,
    group_by: ?ecs_group_by_action_t,
    on_group_create: ?ecs_group_create_action_t,
    on_group_delete: ?ecs_group_delete_action_t,
    group_by_ctx: ?*anyopaque,
    group_by_ctx_free: ?ecs_ctx_free_t,
    parent: ?*ecs_query_t,
};

pub const ecs_observer_desc_t = extern struct {
    _canary: i32,
    entity: ecs_entity_t,
    filter: ecs_filter_desc_t,
    events: [FLECS_EVENT_DESC_MAX]ecs_entity_t,
    yield_existing: bool,
    callback: ?ecs_iter_action_t,
    run: ?ecs_run_action_t,
    ctx: ?*anyopaque,
    binding_ctx: ?*anyopaque,
    ctx_free: ?ecs_ctx_free_t,
    binding_ctx_free: ?ecs_ctx_free_t,
    observable: ?*ecs_poly_t,
    last_event_id: ?*i32,
    term_index: i32,
};

pub const ecs_value_t = extern struct {
    type: ecs_entity_t,
    ptr: ?*anyopaque,
};

pub const ecs_world_info_t = extern struct {
    last_component_id: ecs_entity_t,
    min_id: ecs_entity_t,
    max_id: ecs_entity_t,

    delta_time_raw: ecs_ftime_t,
    delta_time: ecs_ftime_t,
    time_scale: ecs_ftime_t,
    target_fps: ecs_ftime_t,
    frame_time_total: ecs_ftime_t,
    system_time_total: ecs_ftime_t,
    emit_time_total: ecs_ftime_t,
    merge_time_total: ecs_ftime_t,
    world_time_total: ecs_ftime_t,
    world_time_total_raw: ecs_ftime_t,
    rematch_time_total: ecs_ftime_t,

    frame_count_total: i64,
    merge_count_total: i64,
    rematch_count_total: i64,

    id_create_total: i64,
    id_delete_total: i64,
    table_create_total: i64,
    table_delete_total: i64,
    pipeline_build_count_total: i64,
    systems_ran_frame: i64,
    observers_ran_frame: i64,

    id_count: i32,
    tag_id_count: i32,
    component_id_count: i32,
    pair_id_count: i32,
    wildcard_id_count: i32,

    table_count: i32,
    tag_table_count: i32,
    trivial_table_count: i32,

    empty_table_count: i32,
    table_record_count: i32,
    table_storage_count: i32,

    cmd: extern struct {
        add_count: i64,
        remove_count: i64,
        delete_count: i64,
        clear_count: i64,
        set_count: i64,
        get_mut_count: i64,
        modified_count: i64,
        other_count: i64,
        discard_count: i64,
        batched_entity_count: i64,
        batched_command_count: i64,
    },

    name_prefix: ?[*:0]const u8,
};

pub const ecs_query_group_info_t = extern struct {
    match_count: i32,
    table_count: i32,
    ctx: ?*anyopaque,
};

pub const EcsIdentifier = extern struct {
    value: ?[*:0]u8,
    length: i32,
    hash: u64,
    index_hash: u64,
    index: ?*ecs_hashmap_t,
};

pub const EcsComponent = extern struct {
    size: i32,
    alignment: i32,
};

pub const EcsPoly = extern struct {
    poly: ?*ecs_poly_t,
};

pub const EcsTarget = extern struct {
    count: i32,
    target: ?*ecs_record_t,
};

pub const EcsIterable = extern struct {
    init: ecs_iter_init_action_t,
};

pub const ecs_event_desc_t = extern struct {
    event: ecs_entity_t,
    ids: ?*const ecs_type_t,
    table: ?*ecs_table_t,
    other_table: ?*ecs_table_t,
    offset: i32,
    count: i32,
    entity: ecs_entity_t,
    param: ?*const anyopaque,
    observable: ?*ecs_poly_t,
    flags: ecs_flags32_t,
};

pub const ecs_flatten_desc_t = extern struct {
    keep_names: bool,
    lose_depth: bool,
};

pub extern fn ecs_vec_init(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
    elem_count: i32,
) *ecs_vec_t;

pub extern fn ecs_vec_init_if(
    vec: *ecs_vec_t,
    size: i32,
) void;

pub extern fn ecs_vec_fini(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
) void;

pub extern fn ecs_vec_reset(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
) *ecs_vec_t;

pub extern fn ecs_vec_clear(
    vec: *ecs_vec_t,
) void;

pub extern fn ecs_vec_append(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
) *anyopaque;

pub extern fn ecs_vec_remove(
    vec: *ecs_vec_t,
    size: i32,
    elem: i32,
) void;

pub extern fn ecs_vec_remove_last(
    vec: *ecs_vec_t,
) void;

pub extern fn ecs_vec_copy(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
) ecs_vec_t;

pub extern fn ecs_vec_reclaim(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
) void;

pub extern fn ecs_vec_set_size(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
    elem_count: i32,
) void;

pub extern fn ecs_vec_set_min_size(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
    elem_count: i32,
) void;

pub extern fn ecs_vec_set_count(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
    elem_count: i32,
) void;

pub extern fn ecs_vec_set_min_count(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
    elem_count: i32,
) void;

pub extern fn ecs_vec_set_min_count_zeromem(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
    elem_count: i32,
) void;

pub extern fn ecs_vec_grow(
    allocator: ?*ecs_allocator_t,
    vec: *ecs_vec_t,
    size: i32,
    elem_count: i32,
) *anyopaque;

pub extern fn ecs_vec_count(
    vec: *const ecs_vec_t,
) i32;

pub extern fn ecs_vec_size(
    vec: *const ecs_vec_t,
) i32;

pub extern fn ecs_vec_get(
    vec: *const ecs_vec_t,
    size: i32,
    index: i32,
) *anyopaque;

pub extern fn ecs_vec_first(
    vec: *const ecs_vec_t,
) ?*anyopaque;

pub extern fn ecs_vec_last(
    vec: *const ecs_vec_t,
    size: i32,
) ?*anyopaque;

pub extern fn ecs_sparse_init(
    sparse: *ecs_sparse_t,
    elem_size: i32,
) void;

pub extern fn ecs_sparse_add(
    spare: *ecs_sparse_t,
    elem_size: i32,
) *anyopaque;

pub extern fn ecs_sparse_last_id(
    sparse: *const ecs_sparse_t,
) u64;

pub extern fn ecs_sparse_count(
    sparse: *const ecs_sparse_t,
) i32;

pub extern fn flecs_sparse_set_generation(
    sparse: *ecs_sparse_t,
    id: u64,
) void;

pub extern fn ecs_sparse_get_dense(
    sparse: *const ecs_sparse_t,
    elem_size: i32,
    index: i32,
) *anyopaque;

pub extern fn ecs_sparse_get(
    sparse: *const ecs_sparse_t,
    elem_size: i32,
    id: u64,
) *anyopaque;

pub extern fn flecs_ballocator_init(
    ba: *ecs_block_allocator_t,
    size: i32,
) void;

pub extern fn flecs_ballocator_fini(
    ba: *ecs_block_allocator_t,
) void;

pub extern fn flecs_ballocator_new(
    size: i32,
) *ecs_block_allocator_t;

pub extern fn flecs_ballocator_free(
    ba: *ecs_block_allocator_t,
) void;

pub extern fn flecs_balloc(
    allocator: ?*ecs_block_allocator_t,
) ?*anyopaque;

pub extern fn flecs_bcalloc(
    allocator: ?*ecs_block_allocator_t,
) ?*anyopaque;

pub extern fn flecs_bfree(
    allocator: ?*ecs_block_allocator_t,
    memory: ?*anyopaque,
) void;

pub extern fn flecs_brealloc(
    dst: ?*ecs_block_allocator_t,
    src: ?*ecs_block_allocator_t,
    memory: ?*anyopaque,
) ?*anyopaque;

pub extern fn flecs_bdup(
    ba: ?*ecs_block_allocator_t,
    memory: ?*anyopaque,
) ?*anyopaque;

pub extern fn ecs_map_params_init(
    params: *ecs_map_params_t,
    allocator: ?*ecs_allocator_t,
) void;

pub extern fn ecs_map_params_fini(
    params: *ecs_map_params_t,
) void;

pub extern fn ecs_map_init(
    map: *ecs_map_t,
    allocator: ?*ecs_allocator_t,
) void;

pub extern fn ecs_map_init_w_params(
    map: *ecs_map_t,
    params: *ecs_map_params_t,
) void;

pub extern fn ecs_map_init_if(
    map: *ecs_map_t,
    allocator: ?*ecs_allocator_t,
) void;

pub extern fn ecs_map_init_w_params_if(
    map: *ecs_map_t,
    params: *ecs_map_params_t,
) void;

pub extern fn ecs_map_fini(
    map: ?*ecs_map_t,
) void;

pub extern fn ecs_map_get(
    map: *const ecs_map_t,
    key: ecs_map_key_t,
) ?*ecs_map_val_t;

pub extern fn _ecs_map_get_deref(
    map: *const ecs_map_t,
    key: ecs_map_key_t,
) ?*anyopaque;

pub extern fn ecs_map_ensure(
    map: *ecs_map_t,
    key: ecs_map_key_t,
) *ecs_map_val_t;

pub extern fn ecs_map_ensure_alloc(
    map: *ecs_map_t,
    elem_size: i32,
    key: ecs_map_key_t,
) *anyopaque;

pub extern fn ecs_map_insert(
    map: *ecs_map_t,
    key: ecs_map_key_t,
    value: ecs_map_val_t,
) void;

pub extern fn ecs_map_insert_alloc(
    map: *ecs_map_t,
    elem_size: i32,
    key: ecs_map_key_t,
) *anyopaque;

pub extern fn ecs_map_remove(
    map: *ecs_map_t,
    key: ecs_map_key_t,
) ecs_map_val_t;

pub extern fn ecs_map_remove_free(
    map: *ecs_map_t,
    key: ecs_map_key_t,
) void;

pub extern fn ecs_map_clear(
    map: *ecs_map_t,
) void;

pub extern fn ecs_map_iter(
    map: *const ecs_map_t,
) ecs_map_iter_t;

pub extern fn ecs_map_next(
    iter: *ecs_map_iter_t,
) bool;

pub extern fn ecs_map_copy(
    dst: *ecs_map_t,
    src: ?*const ecs_map_t,
) void;

pub extern fn flecs_allocator_init(
    a: *ecs_allocator_t,
) void;

pub extern fn flecs_allocator_fini(
    a: *ecs_allocator_t,
) void;

pub extern fn flecs_allocator_get(
    a: *ecs_allocator_t,
    size: i32,
) ?*anyopaque;

pub extern fn flecs_strdup(
    a: *ecs_allocator_t,
    str: [*:0]const u8,
) [*:0]u8;

pub extern fn flecs_strfree(
    a: *ecs_allocator_t,
    str: [*:0]u8,
) void;

pub extern fn flecs_dup(
    a: *ecs_allocator_t,
    size: i32,
    src: *const anyopaque,
) ?*anyopaque;

pub extern fn ecs_strbuf_append(
    buffer: *ecs_strbuf_t,
    fmt: [*:0]const u8,
    ...,
) bool;

pub extern fn ecs_strbuf_appendstr(
    buffer: *ecs_strbuf_t,
    str: [*:0]const u8,
) bool;

pub extern fn ecs_strbuf_appendstrn(
    buffer: *ecs_strbuf_t,
    str: [*]const u8,
    n: i32,
) bool;

pub extern fn ecs_strbuf_appendch(
    buffer: *ecs_strbuf_t,
    ch: u8,
) bool;

pub extern fn ecs_strbuf_appendint(
    buffer: *ecs_strbuf_t,
    v: i64,
) bool;

pub extern fn ecs_strbuf_appendflt(
    buffer: *ecs_strbuf_t,
    v: f64,
) bool;

pub extern fn ecs_strbuf_mergebuff(
    dst_buffer: *ecs_strbuf_t,
    src_buffer: *ecs_strbuf_t,
) bool;

pub extern fn ecs_strbuf_appendstr_zerocpy(
    buffer: *ecs_strbuf_t,
    str: [*:0]u8,
) bool;

pub extern fn ecs_strbuf_appendstr_zerocpyn(
    buffer: *ecs_strbuf_t,
    str: [*]u8,
    n: i32,
) bool;

pub extern fn ecs_strbuf_appendstr_zerocpy_const(
    buffer: *ecs_strbuf_t,
    str: [*:0]const u8,
) bool;

pub extern fn ecs_strbuf_appendstr_zerocpyn_const(
    buffer: *ecs_strbuf_t,
    str: [*]const u8,
    n: i32,
) bool;

pub extern fn ecs_strbuf_get(
    buffer: *ecs_strbuf_t,
) ?[*:0]u8;

pub extern fn ecs_strbuf_get_small(
    buffer: *ecs_strbuf_t,
) ?[*:0]u8;

pub extern fn ecs_strbuf_reset(
    buffer: *ecs_strbuf_t,
) void;

pub extern fn ecs_strbuf_list_push(
    buffer: *ecs_strbuf_t,
    list_open: [*:0]const u8,
    separator: [*:0]const u8,
) void;

pub extern fn ecs_strbuf_list_pop(
    buffer: *ecs_strbuf_t,
    list_close: [*:0]const u8,
) void;

pub extern fn ecs_strbuf_list_next(
    buffer: *ecs_strbuf_t,
) void;

pub extern fn ecs_strbuf_list_appendch(
    buffer: *ecs_strbuf_t,
    ch: u8,
) bool;

pub extern fn ecs_strbuf_list_append(
    buffer: *ecs_strbuf_t,
    fmt: [*:0]const u8,
    ...,
) bool;

pub extern fn ecs_strbuf_list_appendstr(
    buffer: *ecs_strbuf_t,
    str: [*:0]const u8,
) bool;

pub extern fn ecs_strbuf_list_appendstrn(
    buffer: *ecs_strbuf_t,
    str: [*]const u8,
    n: i32,
) bool;

pub extern fn ecs_strbuf_written(
    buffer: *const ecs_strbuf_t,
) i32;

pub extern fn ecs_module_path_from_c(
    c_name: [*:0]const u8,
) [*:0]u8;

pub extern fn ecs_default_ctor(
    ptr: *anyopaque,
    count: i32,
    ctx: *const ecs_type_info_t,
) void;

pub extern fn ecs_asprintf(
    fmt: [*:0]const u8,
    ...,
) ?[*:0]u8;

pub extern fn flecs_to_snake_case(
    str: [*:0]const u8,
) [*:0]u8;

pub extern fn ecs_is_fini(
    world: *const ecs_world_t,
) bool;

pub extern fn ecs_atfini(
    world: *ecs_world_t,
    action: ecs_fini_action_t,
    ctx: ?*anyopaque,
) void;

pub extern fn ecs_frame_begin(
    world: *ecs_world_t,
    delta_time: ecs_ftime_t,
) ecs_ftime_t;

pub extern fn ecs_frame_end(
    world: *ecs_world_t,
) void;

pub extern fn ecs_run_post_frame(
    world: *ecs_world_t,
    action: ecs_fini_action_t,
    ctx: ?*anyopaque,
) void;

pub extern fn ecs_quit(
    world: *ecs_world_t,
) void;

pub extern fn ecs_should_quit(
    world: *const ecs_world_t,
) bool;

pub extern fn ecs_measure_frame_time(
    world: *ecs_world_t,
    enable: bool,
) void;

pub extern fn ecs_measure_system_time(
    world: *ecs_world_t,
    enable: bool,
) void;

pub extern fn ecs_set_target_fps(
    world: *ecs_world_t,
    fps: ecs_ftime_t,
) void;

pub extern fn ecs_readonly_begin(
    world: *ecs_world_t,
) bool;

pub extern fn ecs_readonly_end(
    world: *ecs_world_t,
) bool;

pub extern fn ecs_merge(
    world: *ecs_world_t,
) void;

pub extern fn ecs_defer_begin(
    world: *ecs_world_t,
) bool;

pub extern fn ecs_is_deferred(
    world: *const ecs_world_t,
) bool;

pub extern fn ecs_defer_end(
    world: *ecs_world_t,
) bool;

pub extern fn ecs_defer_suspend(
    world: *ecs_world_t,
) void;

pub extern fn ecs_defer_resume(
    world: *ecs_world_t,
) void;

pub extern fn ecs_set_automerge(
    world: *ecs_world_t,
    automerge: bool,
) void;

pub extern fn ecs_set_stage_count(
    world: *ecs_world_t,
    stages: i32,
) void;

pub extern fn ecs_get_stage_count(
    world: *const ecs_world_t,
) i32;

pub extern fn ecs_get_stage_id(
    world: *const ecs_world_t,
) i32;

pub extern fn ecs_get_stage(
    world: *const ecs_world_t,
    stage_id: i32,
) ?*ecs_world_t;

pub extern fn ecs_stage_is_readonly(
    world: *const ecs_world_t,
) bool;

pub extern fn ecs_async_stage_new(
    world: *ecs_world_t,
) *ecs_world_t;

pub extern fn ecs_async_stage_free(
    stage: *ecs_world_t,
) void;

pub extern fn ecs_stage_is_async(
    stage: *ecs_world_t,
) bool;

pub extern fn ecs_set_context(
    world: *ecs_world_t,
    ctx: ?*anyopaque,
) void;

pub extern fn ecs_get_context(
    world: *const ecs_world_t,
) ?*anyopaque;

pub extern fn ecs_get_world_info(
    world: *const ecs_world_t,
) *const ecs_world_info_t;

pub extern fn ecs_dim(
    world: *ecs_world_t,
    entity_count: i32,
) void;

pub extern fn ecs_set_entity_range(
    world: *ecs_world_t,
    id_start: ecs_entity_t,
    id_end: ecs_entity_t,
) void;

pub extern fn ecs_enable_range_check(
    world: *ecs_world_t,
    enable: bool,
) bool;

pub extern fn ecs_get_max_id(
    world: *const ecs_world_t,
) ecs_entity_t;

pub extern fn ecs_run_aperiodic(
    world: *ecs_world_t,
    flags: ecs_flags32_t,
) void;

pub extern fn ecs_delete_empty_tables(
    world: *ecs_world_t,
    id: ecs_id_t,
    clear_generation: u16,
    delete_generation: u16,
    min_id_count: i32,
    time_budget_seconds: f64,
) i32;

pub extern fn ecs_get_world(
    poly: *const ecs_poly_t,
) *const ecs_world_t;

pub extern fn ecs_get_entity(
    poly: *const ecs_poly_t,
) ecs_entity_t;

pub extern fn _ecs_poly_is(
    object: *const ecs_poly_t,
    type_: i32,
) bool;

pub extern fn ecs_make_pair(
    first: ecs_entity_t,
    second: ecs_entity_t,
) ecs_id_t;

pub extern fn ecs_new_id(
    world: *ecs_world_t,
) ecs_entity_t;

pub extern fn ecs_new_low_id(
    world: *ecs_world_t,
) ecs_entity_t;

pub extern fn ecs_new_w_id(
    world: *ecs_world_t,
    id: ecs_id_t,
) ecs_entity_t;

pub extern fn ecs_new_w_table(
    world: *ecs_world_t,
    table: *ecs_table_t,
) ecs_entity_t;

pub extern fn ecs_entity_init(
    world: *ecs_world_t,
    desc: *const ecs_entity_desc_t,
) ecs_entity_t;

pub extern fn ecs_bulk_init(
    world: *ecs_world_t,
    desc: *const ecs_bulk_desc_t,
) ?[*]const ecs_entity_t;

pub extern fn ecs_bulk_new_w_id(
    world: *ecs_world_t,
    id: ecs_id_t,
    count: i32,
) ?[*]const ecs_entity_t;

pub extern fn ecs_clone(
    world: *ecs_world_t,
    dst: ecs_entity_t,
    src: ecs_entity_t,
    copy_value: bool,
) ecs_entity_t;

pub extern fn ecs_delete(
    world: *ecs_world_t,
    entity: ecs_entity_t,
) void;

pub extern fn ecs_delete_with(
    world: *ecs_world_t,
    id: ecs_id_t,
) void;

pub extern fn ecs_add_id(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) void;

pub extern fn ecs_remove_id(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) void;

pub extern fn ecs_override_id(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) void;

pub extern fn ecs_clear(
    world: *ecs_world_t,
    entity: ecs_entity_t,
) void;

pub extern fn ecs_remove_all(
    world: *ecs_world_t,
    id: ecs_id_t,
) void;

pub extern fn ecs_set_with(
    world: *ecs_world_t,
    id: ecs_id_t,
) ecs_entity_t;

pub extern fn ecs_get_with(
    world: *const ecs_world_t,
) ecs_id_t;

pub extern fn ecs_enable(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    enabled: bool,
) void;

pub extern fn ecs_enable_id(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
    enable: bool,
) void;

pub extern fn ecs_is_enabled_id(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) bool;

pub extern fn ecs_get_id(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) ?*const anyopaque;

pub extern fn ecs_ref_init_id(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) ecs_ref_t;

pub extern fn ecs_ref_get_id(
    world: *const ecs_world_t,
    ref: *ecs_ref_t,
    id: ecs_id_t,
) ?*anyopaque;

pub extern fn ecs_ref_update(
    world: *const ecs_world_t,
    ref: *ecs_ref_t,
) void;

pub extern fn ecs_get_mut_id(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) *anyopaque;

pub extern fn ecs_write_begin(
    world: *ecs_world_t,
    entity: ecs_entity_t,
) *ecs_record_t;

pub extern fn ecs_write_end(
    record: *ecs_record_t,
) void;

pub extern fn ecs_read_begin(
    world: *ecs_world_t,
    entity: ecs_entity_t,
) *const ecs_record_t;

pub extern fn ecs_read_end(
    record: *const ecs_record_t,
) void;

pub extern fn ecs_record_get_entity(
    record: *const ecs_record_t,
) ecs_entity_t;

pub extern fn ecs_record_get_id(
    world: *ecs_world_t,
    record: *const ecs_record_t,
    id: ecs_id_t,
) ?*const anyopaque;

pub extern fn ecs_record_get_mut_id(
    world: *ecs_world_t,
    record: *ecs_record_t,
    id: ecs_id_t,
) ?*anyopaque;

pub extern fn ecs_record_has_id(
    world: *ecs_world_t,
    record: *const ecs_record_t,
    id: ecs_id_t,
) bool;

pub extern fn ecs_emplace_id(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) ?*anyopaque;

pub extern fn ecs_modified_id(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) void;

pub extern fn ecs_set_id(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
    size: usize,
    ptr: *const anyopaque,
) ecs_entity_t;

pub extern fn ecs_is_valid(
    world: *const ecs_world_t,
    e: ecs_entity_t,
) bool;

pub extern fn ecs_is_alive(
    world: *const ecs_world_t,
    e: ecs_entity_t,
) bool;

pub extern fn ecs_strip_generation(
    e: ecs_entity_t,
) ecs_id_t;

pub extern fn ecs_set_entity_generation(
    world: *ecs_world_t,
    entity: ecs_entity_t,
) void;

pub extern fn ecs_get_alive(
    world: *const ecs_world_t,
    e: ecs_entity_t,
) ecs_entity_t;

pub extern fn ecs_ensure(
    world: *ecs_world_t,
    entity: ecs_entity_t,
) void;

pub extern fn ecs_ensure_id(
    world: *ecs_world_t,
    id: ecs_id_t,
) void;

pub extern fn ecs_exists(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) bool;

pub extern fn ecs_get_type(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?*const ecs_type_t;

pub extern fn ecs_get_table(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?*ecs_table_t;

pub extern fn ecs_type_str(
    world: *const ecs_world_t,
    type_: *const ecs_type_t,
) [*:0]u8;

pub extern fn ecs_entity_str(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) [*:0]u8;

pub extern fn ecs_has_id(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
    id: ecs_id_t,
) bool;

pub extern fn ecs_get_target(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
    rel: ecs_entity_t,
    index: i32,
) ecs_entity_t;

pub extern fn ecs_get_parent(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ecs_entity_t;

pub extern fn ecs_get_target_for_id(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
    rel: ecs_entity_t,
    id: ecs_id_t,
) ecs_entity_t;

pub extern fn ecs_get_depth(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
    rel: ecs_entity_t,
) i32;

pub extern fn ecs_flatten(
    world: *ecs_world_t,
    pair: ecs_id_t,
    desc: ?*const ecs_flatten_desc_t,
) void;

pub extern fn ecs_count_id(
    world: *const ecs_world_t,
    entity: ecs_id_t,
) i32;

pub extern fn ecs_get_name(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?[*:0]const u8;

pub extern fn ecs_get_symbol(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?[*:0]const u8;

pub extern fn ecs_set_name(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    name: ?[*:0]const u8,
) ecs_entity_t;

pub extern fn ecs_set_symbol(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    symbol: ?[*:0]const u8,
) ecs_entity_t;

pub extern fn ecs_set_alias(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    alias: ?[*:0]const u8,
) void;

pub extern fn ecs_lookup(
    world: *const ecs_world_t,
    name: [*:0]const u8,
) ecs_entity_t;

pub extern fn ecs_lookup_child(
    world: *const ecs_world_t,
    parent: ecs_entity_t,
    name: [*:0]const u8,
) ecs_entity_t;

pub extern fn ecs_lookup_path_w_sep(
    world: *const ecs_world_t,
    parent: ecs_entity_t,
    path: [*:0]const u8,
    sep: ?[*:0]const u8,
    prefix: ?[*:0]const u8,
    recursive: bool,
) ecs_entity_t;

pub extern fn ecs_lookup_symbol(
    world: *const ecs_world_t,
    symbol: [*:0]const u8,
    lookup_as_path: bool,
) ecs_entity_t;

pub extern fn ecs_get_path_w_sep(
    world: *const ecs_world_t,
    parent: ecs_entity_t,
    child: ecs_entity_t,
    sep: ?[*:0]const u8,
    prefix: ?[*:0]const u8,
) [*:0]u8;

pub extern fn ecs_get_path_w_sep_buf(
    world: *const ecs_world_t,
    parent: ecs_entity_t,
    child: ecs_entity_t,
    sep: ?[*:0]const u8,
    prefix: ?[*:0]const u8,
    buf: *ecs_strbuf_t,
) void;

pub extern fn ecs_new_from_path_w_sep(
    world: *ecs_world_t,
    parent: ecs_entity_t,
    path: [*:0]const u8,
    sep: ?[*:0]const u8,
    prefix: ?[*:0]const u8,
) ecs_entity_t;

pub extern fn ecs_add_path_w_sep(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    parent: ecs_entity_t,
    path: [*:0]const u8,
    sep: ?[*:0]const u8,
    prefix: ?[*:0]const u8,
) ecs_entity_t;

pub extern fn ecs_set_scope(
    world: *ecs_world_t,
    scope: ecs_entity_t,
) ecs_entity_t;

pub extern fn ecs_get_scope(
    world: *const ecs_world_t,
) ecs_entity_t;

pub extern fn ecs_set_name_prefix(
    world: *ecs_world_t,
    prefix: ?[*:0]const u8,
) ?[*:0]const u8;

pub extern fn ecs_set_lookup_path(
    world: *ecs_world_t,
    lookup_path: [*:0]const ecs_entity_t,
) [*:0]ecs_entity_t;

pub extern fn ecs_get_lookup_path(
    world: *const ecs_world_t,
) *ecs_entity_t;

pub extern fn ecs_component_init(
    world: *ecs_world_t,
    desc: *const ecs_component_desc_t,
) ecs_entity_t;

pub extern fn ecs_set_hooks_id(
    world: *ecs_world_t,
    id: ecs_entity_t,
    hooks: *const ecs_type_hooks_t,
) void;

pub extern fn ecs_get_hooks_id(
    world: *ecs_world_t,
    id: ecs_entity_t,
) ?*const ecs_type_hooks_t;

pub extern fn ecs_id_is_tag(
    world: *const ecs_world_t,
    id: ecs_id_t,
) bool;

pub extern fn ecs_id_is_union(
    world: *const ecs_world_t,
    id: ecs_id_t,
) bool;

pub extern fn ecs_id_in_use(
    world: *const ecs_world_t,
    id: ecs_id_t,
) bool;

pub extern fn ecs_get_type_info(
    world: *const ecs_world_t,
    id: ecs_id_t,
) ?*const ecs_type_info_t;

pub extern fn ecs_get_typeid(
    world: *const ecs_world_t,
    id: ecs_id_t,
) ecs_entity_t;

pub extern fn ecs_id_match(
    id: ecs_id_t,
    pattern: ecs_id_t,
) bool;

pub extern fn ecs_id_is_pair(
    id: ecs_id_t,
) bool;

pub extern fn ecs_id_is_valid(
    world: *const ecs_world_t,
    id: ecs_id_t,
) bool;

pub extern fn ecs_id_get_flags(
    world: *const ecs_world_t,
    id: ecs_id_t,
) ecs_flags32_t;

pub extern fn ecs_id_flag_str(
    id_flags: ecs_id_t,
) ?[*:0]const u8;

pub extern fn ecs_id_str(
    world: *const ecs_world_t,
    id: ecs_id_t,
) [*:0]u8;

pub extern fn ecs_id_str_buf(
    world: *const ecs_world_t,
    id: ecs_id_t,
    buf: *ecs_strbuf_t,
) void;

pub extern fn ecs_term_iter(
    world: *const ecs_world_t,
    term: *ecs_term_t,
) ecs_iter_t;

pub extern fn ecs_term_chain_iter(
    it: *const ecs_iter_t,
    term: *ecs_term_t,
) ecs_iter_t;

pub extern fn ecs_term_next(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_children(
    world: *const ecs_world_t,
    parent: ecs_entity_t,
) ecs_iter_t;

pub extern fn ecs_children_next(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_term_id_is_set(
    id: *const ecs_term_id_t,
) bool;

pub extern fn ecs_term_is_initialized(
    term: *const ecs_term_t,
) bool;

pub extern fn ecs_term_match_this(
    term: *const ecs_term_t,
) bool;

pub extern fn ecs_term_match_0(
    term: *const ecs_term_t,
) bool;

pub extern fn ecs_term_finalize(
    world: *const ecs_world_t,
    term: *ecs_term_t,
) c_int;

pub extern fn ecs_term_copy(
    src: *const ecs_term_t,
) ecs_term_t;

pub extern fn ecs_term_move(
    src: *ecs_term_t,
) ecs_term_t;

pub extern fn ecs_term_fini(
    term: *ecs_term_t,
) void;

pub extern fn ecs_filter_init(
    world: *ecs_world_t,
    desc: *const ecs_filter_desc_t,
) ?*ecs_filter_t;

pub extern fn ecs_filter_fini(
    filter: *ecs_filter_t,
) void;

pub extern fn ecs_filter_finalize(
    world: *const ecs_world_t,
    filter: *ecs_filter_t,
) c_int;

pub extern fn ecs_filter_find_this_var(
    filter: *const ecs_filter_t,
) i32;

pub extern fn ecs_term_str(
    world: *const ecs_world_t,
    term: *const ecs_term_t,
) [*:0]u8;

pub extern fn ecs_filter_str(
    world: *const ecs_world_t,
    filter: *const ecs_filter_t,
) [*:0]u8;

pub extern fn ecs_filter_iter(
    world: *const ecs_world_t,
    filter: *const ecs_filter_t,
) ecs_iter_t;

pub extern fn ecs_filter_chain_iter(
    it: *const ecs_iter_t,
    filter: *const ecs_filter_t,
) ecs_iter_t;

pub extern fn ecs_filter_pivot_term(
    world: *const ecs_world_t,
    filter: *const ecs_filter_t,
) i32;

pub extern fn ecs_filter_next(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_filter_next_instanced(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_filter_move(
    dst: *ecs_filter_t,
    src: ?*ecs_filter_t,
) void;

pub extern fn ecs_filter_copy(
    dst: *ecs_filter_t,
    src: ?*const ecs_filter_t,
) void;

pub extern fn ecs_query_init(
    world: *ecs_world_t,
    desc: *const ecs_query_desc_t,
) ?*ecs_query_t;

pub extern fn ecs_query_fini(
    query: *ecs_query_t,
) void;

pub extern fn ecs_query_get_filter(
    query: *const ecs_query_t,
) *const ecs_filter_t;

pub extern fn ecs_query_iter(
    world: *const ecs_world_t,
    query: *ecs_query_t,
) ecs_iter_t;

pub extern fn ecs_query_next(
    iter: *ecs_iter_t,
) bool;

pub extern fn ecs_query_next_instanced(
    iter: *ecs_iter_t,
) bool;

pub extern fn ecs_query_next_table(
    iter: *ecs_iter_t,
) bool;

pub extern fn ecs_query_populate(
    iter: *ecs_iter_t,
    when_changed: bool,
) c_int;

pub extern fn ecs_query_changed(
    query: ?*ecs_query_t,
    it: ?*const ecs_iter_t,
) bool;

pub extern fn ecs_query_skip(
    it: *ecs_iter_t,
) void;

pub extern fn ecs_query_set_group(
    it: *ecs_iter_t,
    group_id: u64,
) void;

pub extern fn ecs_query_get_group_ctx(
    query: *const ecs_query_t,
    group_id: u64,
) ?*anyopaque;

pub extern fn ecs_query_get_group_info(
    query: *const ecs_query_t,
    group_id: u64,
) ?*const ecs_query_group_info_t;

pub extern fn ecs_query_orphaned(
    query: *const ecs_query_t,
) bool;

pub extern fn ecs_query_str(
    query: *const ecs_query_t,
) [*:0]u8;

pub extern fn ecs_query_table_count(
    query: *const ecs_query_t,
) i32;

pub extern fn ecs_query_empty_table_count(
    query: *const ecs_query_t,
) i32;

pub extern fn ecs_query_entity_count(
    query: *const ecs_query_t,
) i32;

pub extern fn ecs_emit(
    world: *ecs_world_t,
    desc: *ecs_event_desc_t,
) void;

pub extern fn ecs_observer_init(
    world: *ecs_world_t,
    desc: *const ecs_observer_desc_t,
) ecs_entity_t;

pub extern fn ecs_observer_default_run_action(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_get_observer_ctx(
    world: *const ecs_world_t,
    observer: ecs_entity_t,
) ?*anyopaque;

pub extern fn ecs_get_observer_binding_ctx(
    world: *const ecs_world_t,
    observer: ecs_entity_t,
) ?*anyopaque;

pub extern fn ecs_iter_poly(
    world: *const ecs_world_t,
    poly: *const ecs_poly_t,
    iter: [*]ecs_iter_t,
    filter: ?*ecs_term_t,
) void;

pub extern fn ecs_iter_next(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_iter_fini(
    it: *ecs_iter_t,
) void;

pub extern fn ecs_iter_count(
    it: *ecs_iter_t,
) i32;

pub extern fn ecs_iter_is_true(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_iter_first(
    it: *ecs_iter_t,
) ecs_entity_t;

pub extern fn ecs_iter_set_var(
    it: *ecs_iter_t,
    var_id: i32,
    entity: ecs_entity_t,
) void;

pub extern fn ecs_iter_set_var_as_table(
    it: *ecs_iter_t,
    var_id: i32,
    table: *const ecs_table_t,
) void;

pub extern fn ecs_iter_set_var_as_range(
    it: *ecs_iter_t,
    var_id: i32,
    range: *const ecs_table_range_t,
) void;

pub extern fn ecs_iter_get_var(
    it: *ecs_iter_t,
    var_id: i32,
) ecs_entity_t;

pub extern fn ecs_iter_get_var_as_table(
    it: *ecs_iter_t,
    var_id: i32,
) ?*ecs_table_t;

pub extern fn ecs_iter_get_var_as_range(
    it: *ecs_iter_t,
    var_id: i32,
) ecs_table_range_t;

pub extern fn ecs_iter_var_is_constrained(
    it: *ecs_iter_t,
    var_id: i32,
) bool;

pub extern fn ecs_page_iter(
    it: *const ecs_iter_t,
    offset: i32,
    limit: i32,
) ecs_iter_t;

pub extern fn ecs_page_next(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_worker_iter(
    it: *const ecs_iter_t,
    index: i32,
    count: i32,
) ecs_iter_t;

pub extern fn ecs_worker_next(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_field_w_size(
    it: *const ecs_iter_t,
    size: usize,
    index: i32,
) *anyopaque;

pub extern fn ecs_field_is_readonly(
    it: *const ecs_iter_t,
    index: i32,
) bool;

pub extern fn ecs_field_is_writeonly(
    it: *const ecs_iter_t,
    index: i32,
) bool;

pub extern fn ecs_field_is_set(
    it: *const ecs_iter_t,
    index: i32,
) bool;

pub extern fn ecs_field_id(
    it: *const ecs_iter_t,
    index: i32,
) ecs_id_t;

pub extern fn ecs_field_column_index(
    it: *const ecs_iter_t,
    index: i32,
) i32;

pub extern fn ecs_field_src(
    it: *const ecs_iter_t,
    index: i32,
) ecs_entity_t;

pub extern fn ecs_field_size(
    it: *const ecs_iter_t,
    index: i32,
) usize;

pub extern fn ecs_field_is_self(
    it: *const ecs_iter_t,
    index: i32,
) bool;

pub extern fn ecs_iter_str(
    it: *const ecs_iter_t,
) [*:0]u8;

pub extern fn ecs_table_get_type(
    table: *const ecs_table_t,
) *const ecs_type_t;

pub extern fn ecs_table_get_column(
    table: *const ecs_table_t,
    index: i32,
    offset: i32,
) ?*anyopaque;

pub extern fn ecs_table_get_column_size(
    table: *const ecs_table_t,
    index: i32,
) usize;

pub extern fn ecs_table_get_index(
    world: *const ecs_world_t,
    table: *const ecs_table_t,
    id: ecs_id_t,
) i32;

pub extern fn ecs_table_has_id(
    world: *const ecs_world_t,
    table: *const ecs_table_t,
    id: ecs_id_t,
) bool;

pub extern fn ecs_table_get_id(
    world: *const ecs_world_t,
    table: *const ecs_table_t,
    id: ecs_id_t,
    offset: i32,
) ?*anyopaque;

pub extern fn ecs_table_get_depth(
    world: *const ecs_world_t,
    table: *const ecs_table_t,
    rel: ecs_entity_t,
) i32;

pub extern fn ecs_table_get_storage_table(
    table: *const ecs_table_t,
) ?*ecs_table_t;

pub extern fn ecs_table_type_to_storage_index(
    table: *const ecs_table_t,
    index: i32,
) i32;

pub extern fn ecs_table_storage_to_type_index(
    table: *const ecs_table_t,
    index: i32,
) i32;

pub extern fn ecs_table_count(
    table: *const ecs_table_t,
) i32;

pub extern fn ecs_table_add_id(
    world: *ecs_world_t,
    table: *ecs_table_t,
    id: ecs_id_t,
) *ecs_table_t;

pub extern fn ecs_table_find(
    world: *ecs_world_t,
    ids: [*]const ecs_id_t,
    id_count: i32,
) *ecs_table_t;

pub extern fn ecs_table_remove_id(
    world: *ecs_world_t,
    table: *ecs_table_t,
    id: ecs_id_t,
) *ecs_table_t;

pub extern fn ecs_table_lock(
    world: *ecs_world_t,
    table: *ecs_table_t,
) void;

pub extern fn ecs_table_unlock(
    world: *ecs_world_t,
    table: *ecs_table_t,
) void;

pub extern fn ecs_table_has_module(
    table: *ecs_table_t,
) bool;

pub extern fn ecs_table_swap_rows(
    world: *ecs_world_t,
    table: *ecs_table_t,
    row_1: i32,
    row_2: i32,
) void;

pub extern fn ecs_commit(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    record: ?*ecs_record_t,
    table: *ecs_table_t,
    added: ?*const ecs_type_t,
    removed: ?*const ecs_type_t,
) bool;

pub extern fn ecs_record_find(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?*ecs_record_t;

pub extern fn ecs_record_get_column(
    r: *const ecs_record_t,
    column: i32,
    size: usize,
) *anyopaque;

pub extern fn ecs_search(
    world: *const ecs_world_t,
    table: *const ecs_table_t,
    id: ecs_id_t,
    id_out: ?*ecs_id_t,
) i32;

pub extern fn ecs_search_offset(
    world: *const ecs_world_t,
    table: *const ecs_table_t,
    offset: i32,
    id: ecs_id_t,
    id_out: ?*ecs_id_t,
) i32;

pub extern fn ecs_search_relation(
    world: *const ecs_world_t,
    table: *const ecs_table_t,
    offset: i32,
    id: ecs_id_t,
    rel: ecs_entity_t,
    flags: ecs_flags32_t,
    subject_out: ?*ecs_entity_t,
    id_out: ?*ecs_id_t,
    tr_out: ?*?*ecs_table_record_t,
) i32;

pub extern fn ecs_value_init(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    ptr: *anyopaque,
) c_int;

pub extern fn ecs_value_init_w_type_info(
    world: *const ecs_world_t,
    ti: *const ecs_type_info_t,
    ptr: *anyopaque,
) c_int;

pub extern fn ecs_value_new(
    world: *ecs_world_t,
    type_: ecs_entity_t,
) ?*anyopaque;

pub extern fn ecs_value_w_type_info(
    world: *ecs_world_t,
    ti: *const ecs_type_info_t,
) ?*anyopaque;

pub extern fn ecs_value_fini_w_type_info(
    world: *const ecs_world_t,
    ti: *const ecs_type_info_t,
    ptr: *anyopaque,
) c_int;

pub extern fn ecs_value_fini(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    ptr: *anyopaque,
) c_int;

pub extern fn ecs_value_free(
    world: *ecs_world_t,
    type_: ecs_entity_t,
    ptr: *anyopaque,
) c_int;

pub extern fn ecs_value_copy_w_type_info(
    world: *const ecs_world_t,
    ti: *const ecs_type_info_t,
    dst: *anyopaque,
    src: *const anyopaque,
) c_int;

pub extern fn ecs_value_copy(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    dst: *anyopaque,
    src: *const anyopaque,
) c_int;

pub extern fn ecs_value_move_w_type_info(
    world: *const ecs_world_t,
    ti: *const ecs_type_info_t,
    dst: *anyopaque,
    src: *anyopaque,
) c_int;

pub extern fn ecs_value_move(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    dst: *anyopaque,
    src: *anyopaque,
) c_int;

pub extern fn ecs_value_move_ctor_w_type_info(
    world: *const ecs_world_t,
    ti: *const ecs_type_info_t,
    dst: *anyopaque,
    src: *anyopaque,
) c_int;

pub extern fn ecs_value_move_ctor(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    dst: *anyopaque,
    src: *anyopaque,
) c_int;

pub extern fn ecs_log_set_level(
    level: c_int,
) c_int;

pub extern fn ecs_log_get_level() c_int;

pub extern fn ecs_log_enable_colors(
    enabled: bool,
) bool;

pub extern fn ecs_log_enable_timedelta(
    enabled: bool,
) bool;

pub extern fn ecs_log_last_error() c_int;

pub extern fn ecs_os_init() void;
pub extern fn ecs_os_fini() void;
pub extern fn ecs_os_set_api(os_api: *ecs_os_api_t) void;
pub extern fn ecs_os_get_api() ecs_os_api_t;
pub extern fn ecs_os_set_api_defaults() void;

pub extern fn ecs_os_dbg(file: ?[*:0]const u8, line: i32, msg: ?[*:0]const u8) void;
pub extern fn ecs_os_trace(file: ?[*:0]const u8, line: i32, msg: ?[*:0]const u8) void;
pub extern fn ecs_os_warn(file: ?[*:0]const u8, line: i32, msg: ?[*:0]const u8) void;
pub extern fn ecs_os_err(file: ?[*:0]const u8, line: i32, msg: ?[*:0]const u8) void;
pub extern fn ecs_os_fatal(file: ?[*:0]const u8, line: i32, msg: ?[*:0]const u8) void;
pub extern fn ecs_os_strerror(err: c_int) ?[*:0]const u8;
pub extern fn ecs_os_strset(str: *?[*:0]u8, value: [*:0]const u8) void;

pub extern fn ecs_sleepf(t: f64) void;
pub extern fn ecs_time_measure(start: *ecs_time_t) f64;
pub extern fn ecs_time_sub(t1: ecs_time_t, t2: ecs_time_t) ecs_time_t;
pub extern fn ecs_time_to_double(t: ecs_time_t) f64;

pub extern fn ecs_os_memdup(src: ?*const anyopaque, size: i32) ?*anyopaque;

pub extern fn ecs_os_has_heap() bool;
pub extern fn ecs_os_has_threading() bool;
pub extern fn ecs_os_has_time() bool;
pub extern fn ecs_os_has_logging() bool;
pub extern fn ecs_os_has_dl() bool;
pub extern fn ecs_os_has_modules() bool;

pub extern fn ecs_init() ?*ecs_world_t;
pub extern fn ecs_mini() ?*ecs_world_t;
pub extern fn ecs_init_w_args(argc: c_int, argv: [*]const [*:0]const u8) ?*ecs_world_t;
pub extern fn ecs_fini(world: *ecs_world_t) c_int;

pub extern var ecs_os_api: ecs_os_api_t;

pub extern var ECS_FILTER_INIT: ecs_filter_t;

pub extern const ECS_PAIR: ecs_id_t;
pub extern const ECS_OVERRIDE: ecs_id_t;
pub extern const ECS_TOGGLE: ecs_id_t;
pub extern const ECS_AND: ecs_id_t;

pub extern const EcsQuery: ecs_entity_t;
pub extern const EcsObserver: ecs_entity_t;
pub extern const EcsSystem: ecs_entity_t;
pub extern const EcsFlecs: ecs_entity_t;
pub extern const EcsFlecsCore: ecs_entity_t;
pub extern const EcsWorld: ecs_entity_t;
pub extern const EcsWildcard: ecs_entity_t;
pub extern const EcsAny: ecs_entity_t;
pub extern const EcsThis: ecs_entity_t;
pub extern const EcsVariable: ecs_entity_t;
pub extern const EcsTransitive: ecs_entity_t;
pub extern const EcsReflexive: ecs_entity_t;
pub extern const EcsFinal: ecs_entity_t;
pub extern const EcsDontInherit: ecs_entity_t;
pub extern const EcsAlwaysOverride: ecs_entity_t;
pub extern const EcsSymmetric: ecs_entity_t;
pub extern const EcsExclusive: ecs_entity_t;
pub extern const EcsAcyclic: ecs_entity_t;
pub extern const EcsTraversable: ecs_entity_t;
pub extern const EcsWith: ecs_entity_t;
pub extern const EcsOneOf: ecs_entity_t;
pub extern const EcsTag: ecs_entity_t;
pub extern const EcsName: ecs_entity_t;
pub extern const EcsSymbol: ecs_entity_t;
pub extern const EcsAlias: ecs_entity_t;
pub extern const EcsChildOf: ecs_entity_t;
pub extern const EcsIsA: ecs_entity_t;
pub extern const EcsDependsOn: ecs_entity_t;
pub extern const EcsSlotOf: ecs_entity_t;
pub extern const EcsModule: ecs_entity_t;
pub extern const EcsPrivate: ecs_entity_t;
pub extern const EcsPrefab: ecs_entity_t;
pub extern const EcsDisabled: ecs_entity_t;
pub extern const EcsOnAdd: ecs_entity_t;
pub extern const EcsOnRemove: ecs_entity_t;
pub extern const EcsOnSet: ecs_entity_t;
pub extern const EcsUnSet: ecs_entity_t;
pub extern const EcsMonitor: ecs_entity_t;
pub extern const EcsOnDelete: ecs_entity_t;
pub extern const EcsOnTableCreate: ecs_entity_t;
pub extern const EcsOnTableEmpty: ecs_entity_t;
pub extern const EcsOnTableFill: ecs_entity_t;
pub extern const EcsOnDeleteTarget: ecs_entity_t;
pub extern const EcsRemove: ecs_entity_t;
pub extern const EcsDelete: ecs_entity_t;
pub extern const EcsPanic: ecs_entity_t;
pub extern const EcsFlatten: ecs_entity_t;
pub extern const EcsDefaultChildComponent: ecs_entity_t;
pub extern const EcsPredEq: ecs_entity_t;
pub extern const EcsPredMatch: ecs_entity_t;
pub extern const EcsPredLookup: ecs_entity_t;
pub extern const EcsEmpty: ecs_entity_t;
pub extern const EcsOnStart: ecs_entity_t;
pub extern const EcsPreFrame: ecs_entity_t;
pub extern const EcsOnLoad: ecs_entity_t;
pub extern const EcsPostLoad: ecs_entity_t;
pub extern const EcsPreUpdate: ecs_entity_t;
pub extern const EcsOnUpdate: ecs_entity_t;
pub extern const EcsOnValidate: ecs_entity_t;
pub extern const EcsPostUpdate: ecs_entity_t;
pub extern const EcsPreStore: ecs_entity_t;
pub extern const EcsOnStore: ecs_entity_t;
pub extern const EcsPostFrame: ecs_entity_t;
pub extern const EcsPhase: ecs_entity_t;

pub extern const FLECS__EEcsComponent: ecs_entity_t;
pub extern const FLECS__EEcsIdentifier: ecs_entity_t;
pub extern const FLECS__EEcsIterable: ecs_entity_t;
pub extern const FLECS__EEcsPoly: ecs_entity_t;
pub extern const FLECS__EEcsTickSource: ecs_entity_t;
// pub extern const FLECS__EEcsPipelineQuery: ecs_entity_t;
pub extern const FLECS__EEcsTimer: ecs_entity_t;
pub extern const FLECS__EEcsRateFilter: ecs_entity_t;
pub extern const FLECS__EEcsTarget: ecs_entity_t;
pub extern const FLECS__EEcsPipeline: ecs_entity_t;

// // Avoid `std.builtin.VaList` on unsupported platforms.
// pub usingnamespace if (switch (@import("builtin").cpu.arch) {
//     .aarch64 => @import("builtin").os.tag == .windows or @import("builtin").os.tag.isDarwin(),
//     .x86_64 => @import("builtin").os.tag != .windows,
//     .arm, .amdgcn, .avr, .bpfel, .bpfeb, .hexagon, .mips, .mipsel, .mips64,
//     .mips64el, .riscv32, .riscv64, .powerpc, .powerpcle, .powerpc64,
//     .powerpc64le, .sparc, .sparcel, .sparc64, .spirv32, .spirv64, .s390x,
//     .wasm32, .wasm64, .x86 => true,
//     else => false,
// }) struct {
//     pub extern fn ecs_strbuf_vappend(
//         buffer: *ecs_strbuf_t,
//         fmt: [*:0]const u8,
//         args: @import("std").builtin.VaList,
//     ) bool;
// } else struct {};


// ------------------
// `FLECS_LOG` addon.
// ------------------

pub extern fn _ecs_deprecated(
    file: ?[*:0]const u8,
    line: i32,
    msg: ?[*:0]const u8,
) void;

pub extern fn _ecs_log_push(
    level: i32,
) void;

pub extern fn _ecs_log_pop(
    level: i32,
) void;

pub extern fn ecs_should_log(
    level: i32,
) bool;

pub extern fn ecs_strerror(
    error_code: i32,
) [*:0]const u8;

pub extern fn _ecs_print(
    level: i32,
    file: ?[*:0]const u8,
    line: i32,
    fmt: [*:0]const u8,
    ...,
) void;

pub extern fn _ecs_log(
    level: i32,
    file: ?[*:0]const u8,
    line: i32,
    fmt: [*:0]const u8,
    ...,
) void;

pub extern fn _ecs_abort(
    error_code: i32,
    file: ?[*:0]const u8,
    line: i32,
    fmt: ?[*:0]const u8,
    ...,
) void;

pub extern fn _ecs_assert(
    condition: bool,
    error_code: i32,
    condition_str: [*:0]const u8,
    file: ?[*:0]const u8,
    line: i32,
    fmt: ?[*:0]const u8,
    ...,
) bool;

pub extern fn _ecs_parser_error(
    name: ?[*:0]const u8,
    expr: ?[*:0]const u8,
    column: i64,
    fmt: [*:0]const u8,
    ...,
) void;


// ------------------
// `FLECS_APP` addon.
// ------------------

pub const ecs_app_init_action_t = *const fn (
    world: *ecs_world_t,
) callconv(.C) c_int;

pub const ecs_app_desc_t = extern struct {
    target_fps: ecs_ftime_t,
    delta_time: ecs_ftime_t,
    threads: i32,
    frames: i32,
    enable_rest: bool,
    enable_monitor: bool,
    port: u16,

    init: ?ecs_app_init_action_t,

    ctx: ?*anyopaque,
};

pub const ecs_app_run_action_t = *const fn (
    world: *ecs_world_t,
    desc: *ecs_app_desc_t,
) callconv(.C) c_int;

pub const ecs_app_frame_action_t = *const fn (
    world: *ecs_world_t,
    desc: *const ecs_app_desc_t,
) callconv(.C) c_int;

pub extern fn ecs_app_run(
    world: *ecs_world_t,
    desc: *ecs_app_desc_t,
) c_int;

pub extern fn ecs_app_run_frame(
    world: *ecs_world_t,
    desc: *const ecs_app_desc_t,
) c_int;

pub extern fn ecs_app_set_run_action(
    callback: ecs_app_run_action_t,
) c_int;

pub extern fn ecs_app_set_frame_action(
    callback: ecs_app_frame_action_t,
) c_int;


// -------------------
// `FLECS_REST` addon.
// -------------------

pub const ECS_REST_DEFAULT_PORT = 27750;

pub const EcsRest = extern struct {
    port: u16,
    ipaddr: ?[*:0]u8,
    impl: ?*anyopaque,
};

pub extern fn ecs_rest_server_init(
    world: *ecs_world_t,
    desc: ?*const ecs_http_server_desc_t,
) ?*ecs_http_server_t;

pub extern fn ecs_rest_server_fini(
    srv: *ecs_http_server_t,
) void;

pub extern fn FlecsRestImport(
    world: *ecs_world_t,
) void;

pub extern const FLECS__EEcsRest: ecs_entity_t;


// --------------------
// `FLECS_TIMER` addon.
// --------------------

pub const EcsTimer = extern struct {
    timeout: ecs_ftime_t,
    time: ecs_ftime_t,
    overshoot: ecs_ftime_t,
    fired_count: i32,
    active: bool,
    single_shot: bool,
};

pub const EcsRateFilter = extern struct {
    src: ecs_entity_t,
    rate: i32,
    tick_count: i32,
    time_elapsed: ecs_ftime_t,
};

pub extern fn ecs_set_timeout(
    world: *ecs_world_t,
    tick_source: ecs_entity_t,
    timeout: ecs_ftime_t,
) ecs_entity_t;

pub extern fn ecs_get_timeout(
    world: *const ecs_world_t,
    tick_source: ecs_entity_t,
) ecs_ftime_t;

pub extern fn ecs_set_interval(
    world: *ecs_world_t,
    tick_source: ecs_entity_t,
    interval: ecs_ftime_t,
) ecs_entity_t;

pub extern fn ecs_get_interval(
    world: *const ecs_world_t,
    tick_source: ecs_entity_t,
) ecs_ftime_t;

pub extern fn ecs_start_timer(
    world: *ecs_world_t,
    tick_source: ecs_entity_t,
) void;

pub extern fn ecs_stop_timer(
    world: *ecs_world_t,
    tick_source: ecs_entity_t,
) void;

pub extern fn ecs_set_rate(
    world: *ecs_world_t,
    tick_source: ecs_entity_t,
    rate: i32,
    source: ecs_entity_t,
) ecs_entity_t;

pub extern fn ecs_set_tick_source(
    world: *ecs_world_t,
    system: ecs_entity_t,
    tick_source: ecs_entity_t,
) void;

pub extern fn FlecsTimerImport(
    world: *ecs_world_t,
) void;


// -----------------------
// `FLECS_PIPELINE` addon.
// -----------------------

pub const ecs_pipeline_desc_t = extern struct {
    entity: ecs_entity_t,
    query: ecs_query_desc_t,
};

pub extern fn ecs_pipeline_init(
    world: *ecs_world_t,
    desc: *const ecs_pipeline_desc_t,
) ecs_entity_t;

pub extern fn ecs_set_pipeline(
    world: *ecs_world_t,
    pipeline: ecs_entity_t,
) void;

pub extern fn ecs_get_pipeline(
    world: *const ecs_world_t,
) ecs_entity_t;

pub extern fn ecs_progress(
    world: *ecs_world_t,
    delta_time: ecs_ftime_t,
) bool;

pub extern fn ecs_set_time_scale(
    world: *ecs_world_t,
    scale: ecs_ftime_t,
) void;

pub extern fn ecs_reset_clock(
    world: *ecs_world_t,
) void;

pub extern fn ecs_run_pipeline(
    world: *ecs_world_t,
    pipeline: ecs_entity_t,
    delta_time: ecs_ftime_t,
) void;

pub extern fn ecs_set_threads(
    world: *ecs_world_t,
    threads: i32,
) void;

pub extern fn FlecsPipelineImport(
    world: *ecs_world_t,
) void;


// ---------------------
// `FLECS_SYSTEM` addon.
// ---------------------

pub const EcsTickSource = extern struct {
    tick: bool,
    time_elapsed: ecs_ftime_t,
};

pub const ecs_system_desc_t = extern struct {
    _canary: i32,
    entity: ecs_entity_t,
    query: ecs_query_desc_t,
    run: ?ecs_run_action_t,
    ctx: ?*anyopaque,
    binding_ctx: ?*anyopaque,
    ctx_free: ?ecs_ctx_free_t,
    binding_ctx_free: ?ecs_ctx_free_t,
    interval: ecs_ftime_t,
    rate: i32,
    tick_source: ecs_entity_t,
    multi_threaded: bool,
    no_readonly: bool,
};

pub extern fn ecs_system_init(
    world: *ecs_world_t,
    desc: *const ecs_system_desc_t,
) ecs_entity_t;

pub extern fn ecs_run(
    world: *ecs_world_t,
    system: ecs_entity_t,
    delta_time: ecs_ftime_t,
    param: ?*anyopaque,
) ecs_entity_t;

pub extern fn ecs_run_worker(
    world: *ecs_world_t,
    system: ecs_entity_t,
    stage_current: i32,
    stage_count: i32,
    delta_time: ecs_ftime_t,
    param: ?*anyopaque,
) ecs_entity_t;

pub extern fn ecs_run_w_filter(
    world: *ecs_world_t,
    system: ecs_entity_t,
    delta_time: ecs_ftime_t,
    offset: i32,
    limit: i32,
    param: ?*anyopaque,
) ecs_entity_t;

pub extern fn ecs_system_get_query(
    world: *const ecs_world_t,
    system: ecs_entity_t,
) ?*ecs_query_t;

pub extern fn ecs_get_system_ctx(
    world: *const ecs_world_t,
    system: ecs_entity_t,
) ?*anyopaque;

pub extern fn ecs_get_system_binding_ctx(
    world: *const ecs_world_t,
    system: ecs_entity_t,
) ?*anyopaque;

pub extern fn FlecsSystemImport(
    world: *ecs_world_t,
) void;


// --------------------
// `FLECS_STATS` addon.
// --------------------

pub const ECS_STAT_WINDOW = 60;

pub const ecs_gauge_t = extern struct {
    avg: [ECS_STAT_WINDOW]ecs_float_t,
    min: [ECS_STAT_WINDOW]ecs_float_t,
    max: [ECS_STAT_WINDOW]ecs_float_t,
};

pub const ecs_counter_t = extern struct {
    rate: ecs_gauge_t,
    value: [ECS_STAT_WINDOW]f64,
};

pub const ecs_metric_t = extern struct {
    gauge: ecs_gauge_t,
    counter: ecs_counter_t,
};

pub const ecs_world_stats_t = extern struct {
    first_: i64,

    entities: extern struct {
        count: ecs_metric_t,
        not_alive_count: ecs_metric_t,
    },

    ids: extern struct {
        count: ecs_metric_t,
        tag_count: ecs_metric_t,
        component_count: ecs_metric_t,
        pair_count: ecs_metric_t,
        wildcard_count: ecs_metric_t,
        type_count: ecs_metric_t,
        create_count: ecs_metric_t,
        delete_count: ecs_metric_t,
    },

    tables: extern struct {
        count: ecs_metric_t,
        empty_count: ecs_metric_t,
        tag_only_count: ecs_metric_t,
        trivial_only_count: ecs_metric_t,
        record_count: ecs_metric_t,
        storage_count: ecs_metric_t,
        create_count: ecs_metric_t,
        delete_count: ecs_metric_t
    },

    queries: extern struct {
        query_count: ecs_metric_t,
        observer_count: ecs_metric_t,
        system_count: ecs_metric_t,
    },

    commands: extern struct {
        add_count: ecs_metric_t,
        remove_count: ecs_metric_t,
        delete_count: ecs_metric_t,
        clear_count: ecs_metric_t,
        set_count: ecs_metric_t,
        get_mut_count: ecs_metric_t,
        modified_count: ecs_metric_t,
        other_count: ecs_metric_t,
        discard_count: ecs_metric_t,
        batched_entity_count: ecs_metric_t,
        batched_count: ecs_metric_t,
    },

    frame: extern struct {
        frame_count: ecs_metric_t,
        merge_count: ecs_metric_t,
        rematch_count: ecs_metric_t,
        pipeline_build_count: ecs_metric_t,
        systems_ran: ecs_metric_t,
        observers_ran: ecs_metric_t,
        event_emit_count: ecs_metric_t,
    },

    performance: extern struct {
        world_time_raw: ecs_metric_t,
        world_time: ecs_metric_t,
        frame_time: ecs_metric_t,
        system_time: ecs_metric_t,
        emit_time: ecs_metric_t,
        merge_time: ecs_metric_t,
        rematch_time: ecs_metric_t,
        fps: ecs_metric_t,
        delta_time: ecs_metric_t,
    },

    memory: extern struct {
        alloc_count: ecs_metric_t,
        realloc_count: ecs_metric_t,
        free_count: ecs_metric_t,
        outstanding_alloc_count: ecs_metric_t,

        block_alloc_count: ecs_metric_t,
        block_free_count: ecs_metric_t,
        block_outstanding_alloc_count: ecs_metric_t,
        stack_alloc_count: ecs_metric_t,
        stack_free_count: ecs_metric_t,
        stack_outstanding_alloc_count: ecs_metric_t,
    },

    http: extern struct {
        request_received_count: ecs_metric_t,
        request_invalid_count: ecs_metric_t,
        request_handled_ok_count: ecs_metric_t,
        request_handled_error_count: ecs_metric_t,
        request_not_handled_count: ecs_metric_t,
        request_preflight_count: ecs_metric_t,
        send_ok_count: ecs_metric_t,
        send_error_count: ecs_metric_t,
        busy_count: ecs_metric_t,
    },

    last_: i64,

    t: i32,
};

pub const ecs_query_stats_t = extern struct {
    first_: i64,
    matched_table_count: ecs_metric_t,
    matched_empty_table_count: ecs_metric_t,
    matched_entity_count: ecs_metric_t,
    last_: i64,

    t: i32,
};

pub const ecs_system_stats_t = extern struct {
    first_: i64,
    time_spent: ecs_metric_t,
    invoke_count: ecs_metric_t,
    active: ecs_metric_t,
    enabled: ecs_metric_t,
    last_: i64,

    task: bool,

    query: ecs_query_stats_t,
};

pub const ecs_pipeline_stats_t = extern struct {
    _canary: i8,
    systems: ecs_vec_t,
    system_stats: ecs_map_t,

    t: i32,

    system_count: i32,
    active_system_count: i32,
    rebuild_count: i32,
};

pub extern fn ecs_world_stats_get(
    world: *const ecs_world_t,
    stats: *ecs_world_stats_t,
) void;

pub extern fn ecs_world_stats_reduce(
    dst: *ecs_world_stats_t,
    src: *const ecs_world_stats_t,
) void;

pub extern fn ecs_world_stats_reduce_last(
    stats: *ecs_world_stats_t,
    old: *const ecs_world_stats_t,
    count: i32,
) void;

pub extern fn ecs_world_stats_repeat_last(
    stats: *ecs_world_stats_t,
) void;

pub extern fn ecs_world_stats_copy_last(
    dst: *ecs_world_stats_t,
    src: *const ecs_world_stats_t,
) void;

pub extern fn ecs_world_stats_log(
    world: *const ecs_world_t,
    stats: *const ecs_world_stats_t,
) void;

pub extern fn ecs_query_stats_get(
    world: *const ecs_world_t,
    query: *const ecs_query_t,
    stats: *ecs_query_stats_t,
) void;

pub extern fn ecs_query_stats_reduce(
    dst: *ecs_query_stats_t,
    src: *const ecs_query_stats_t,
) void;

pub extern fn ecs_query_stats_reduce_last(
    stats: *ecs_query_stats_t,
    old: *const ecs_query_stats_t,
    count: i32,
) void;

pub extern fn ecs_query_stats_repeat_last(
    stats: *ecs_query_stats_t,
) void;

pub extern fn ecs_query_stats_copy_last(
    dst: *ecs_query_stats_t,
    src: *const ecs_query_stats_t,
) void;

pub extern fn ecs_metric_reduce(
    dst: *ecs_metric_t,
    src: *const ecs_metric_t,
    t_dst: i32,
    t_src: i32,
) void;

pub extern fn ecs_metric_reduce_last(
    m: *ecs_metric_t,
    t: i32,
    count: i32,
) void;

pub extern fn ecs_metric_copy(
    m: *ecs_metric_t,
    dst: i32,
    src: i32,
) void;

pub extern fn ecs_system_stats_get(
    world: *const ecs_world_t,
    system: ecs_entity_t,
    stats: *ecs_system_stats_t,
) bool;

pub extern fn ecs_system_stats_reduce(
    dst: *ecs_system_stats_t,
    src: *const ecs_system_stats_t,
) void;

pub extern fn ecs_system_stats_reduce_last(
    stats: *ecs_system_stats_t,
    old: *const ecs_system_stats_t,
    count: i32,
) void;

pub extern fn ecs_system_stats_repeat_last(
    stats: *ecs_system_stats_t,
) void;

pub extern fn ecs_system_stats_copy_last(
    dst: *ecs_system_stats_t,
    src: *const ecs_system_stats_t,
) void;

pub extern fn ecs_pipeline_stats_get(
    world: *ecs_world_t,
    pipeline: ecs_entity_t,
    stats: *ecs_pipeline_stats_t,
) bool;

pub extern fn ecs_pipeline_stats_fini(
    stats: *ecs_pipeline_stats_t,
) void;

pub extern fn ecs_pipeline_stats_reduce(
    dst: *ecs_pipeline_stats_t,
    src: *const ecs_pipeline_stats_t,
) void;

pub extern fn ecs_pipeline_stats_reduce_last(
    stats: *ecs_pipeline_stats_t,
    old: *const ecs_pipeline_stats_t,
    count: i32,
) void;

pub extern fn ecs_pipeline_stats_repeat_last(
    stats: *ecs_pipeline_stats_t,
) void;

pub extern fn ecs_pipeline_stats_copy_last(
    dst: *ecs_pipeline_stats_t,
    src: *const ecs_pipeline_stats_t,
) void;


// ----------------------
// `FLECS_MONITOR` addon.
// ----------------------

pub const EcsStatsHeader = extern struct {
    elapsed: ecs_ftime_t,
    reduce_count: i32,
};

pub const EcsWorldStats = extern struct {
    hdr: EcsStatsHeader,
    stats: ecs_world_stats_t,
};

pub const EcsPipelineStats = extern struct {
    hdr: EcsStatsHeader,
    stats: ecs_pipeline_stats_t,
};

pub extern fn FlecsMonitorImport(
    world: *ecs_world_t,
) void;

pub extern var EcsPeriod1s: ecs_entity_t;
pub extern var EcsPeriod1m: ecs_entity_t;
pub extern var EcsPeriod1h: ecs_entity_t;
pub extern var EcsPeriod1d: ecs_entity_t;
pub extern var EcsPeriod1w: ecs_entity_t;

pub extern var FLECS__EFlecsMonitor: ecs_entity_t;
pub extern var FLECS__EEcsWorldStats: ecs_entity_t;
pub extern var FLECS__EEcsPipelineStats: ecs_entity_t;


// ----------------------
// `FLECS_METRICS` addon.
// ----------------------

pub const EcsMetricValue = struct {
    value: f64,
};

pub const EcsMetricSource = struct {
    entity: ecs_entity_t,
};

pub const ecs_metric_desc_t = struct {
    entity: ecs_entity_t,
    member: ecs_entity_t,
    id: ecs_id_t,
    targets: bool,
    kind: ecs_entity_t,
    brief: ?[*:0]const u8,
};

pub extern fn ecs_metric_init(
    world: *ecs_world_t,
    desc: *const ecs_metric_desc_t,
) ecs_entity_t;

pub extern fn FlecsMetricsImport(
    world: *ecs_world_t,
) void;

pub extern var EcsMetric: ecs_entity_t;
pub extern var EcsCounter: ecs_entity_t;
pub extern var EcsCounterIncrement: ecs_entity_t;
pub extern var EcsGauge: ecs_entity_t;

pub extern var FLECS__EFlecsMetrics: ecs_entity_t;
pub extern var FLECS__EEcsMetricInstance: ecs_entity_t;
pub extern var FLECS__EEcsMetricValue: ecs_entity_t;
pub extern var FLECS__EEcsMetricSource: ecs_entity_t;

// ----------------------
// `FLECS_COREDOC` addon.
// ----------------------

pub extern fn FlecsCoreDocImport(
    world: *ecs_world_t,
) void;


// ------------------
// `FLECS_DOC` addon.
// ------------------

pub const EcsDocDescription = extern struct {
    value: ?[*:0]u8,
};

pub extern fn ecs_doc_set_name(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    name: ?[*:0]const u8,
) void;

pub extern fn ecs_doc_set_brief(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    description: ?[*:0]const u8,
) void;

pub extern fn ecs_doc_set_detail(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    description: ?[*:0]const u8,
) void;

pub extern fn ecs_doc_set_link(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    link: ?[*:0]const u8,
) void;

pub extern fn ecs_doc_set_color(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    color: ?[*:0]const u8,
) void;

pub extern fn ecs_doc_get_name(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?[*:0]const u8;

pub extern fn ecs_doc_get_brief(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?[*:0]const u8;

pub extern fn ecs_doc_get_detail(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?[*:0]const u8;

pub extern fn ecs_doc_get_link(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?[*:0]const u8;

pub extern fn ecs_doc_get_color(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
) ?[*:0]const u8;

pub extern fn FlecsDocImport(
    world: *ecs_world_t,
) void;

pub extern const EcsDocBrief: ecs_entity_t;
pub extern const EcsDocDetail: ecs_entity_t;
pub extern const EcsDocLink: ecs_entity_t;
pub extern const EcsDocColor: ecs_entity_t;

pub extern const FLECS__EEcsDocDescription: ecs_entity_t;


// -------------------
// `FLECS_JSON` addon.
// -------------------

pub const ecs_from_json_desc_t = extern struct {
    name: ?[*:0]const u8,
    expr: ?[*:0]const u8,

    lookup_action: ?*const fn (
        world: *const ecs_world_t,
        value: [*:0]const u8,
        ctx: ?*anyopaque,
    ) callconv(.C) ecs_entity_t,
    lookup_ctx: ?*anyopaque,
};

pub const ecs_entity_to_json_desc_t = extern struct {
    serialize_path: bool = true,
    serialize_meta_ids: bool = false,
    serialize_label: bool = false,
    serialize_brief: bool = false,
    serialize_link: bool = false,
    serialize_color: bool = false,
    serialize_id_labels: bool = false,
    serialize_base: bool = true,
    serialize_private: bool = false,
    serialize_hidden: bool = false,
    serialize_values: bool = false,
    serialize_type_info: bool = false,
};

pub const ecs_iter_to_json_desc_t = extern struct {
    serialize_term_ids: bool = true,
    serialize_ids: bool = true,
    serialize_sources: bool = true,
    serialize_variables: bool = true,
    serialize_is_set: bool = true,
    serialize_values: bool = true,
    serialize_entities: bool = true,
    serialize_entity_labels: bool = false,
    serialize_entity_ids: bool = false,
    serialize_entity_names: bool = false,
    serialize_variable_labels: bool = false,
    serialize_colors: bool = false,
    measure_eval_duration: bool = false,
    serialize_type_info: bool = false,
    serialize_table: bool = false,
};

pub const ecs_world_to_json_desc_t = extern struct {
    serialize_builtin: bool,
    serialize_modules: bool,
};

pub extern fn ecs_ptr_from_json(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    ptr: *anyopaque,
    json: [*:0]const u8,
    desc: ?*const ecs_from_json_desc_t,
) ?[*:0]const u8;

pub extern fn ecs_entity_from_json(
    world: *ecs_world_t,
    entity: ecs_entity_t,
    json: [*:0]const u8,
    desc: ?*const ecs_from_json_desc_t,
) ?[*:0]const u8;

pub extern fn ecs_world_from_json(
    world: *ecs_world_t,
    json: [*:0]const u8,
    desc: ?*const ecs_from_json_desc_t,
) ?[*:0]const u8;

pub extern fn ecs_array_to_json(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    data: *const anyopaque,
    count: i32,
) ?[*:0]u8;

pub extern fn ecs_array_to_json_buf(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    data: *const anyopaque,
    count: i32,
    buf_out: *ecs_strbuf_t,
) c_int;

pub extern fn ecs_ptr_to_json(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    data: *const anyopaque,
) ?[*:0]u8;

pub extern fn ecs_ptr_to_json_buf(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    data: *const anyopaque,
    buf_out: *ecs_strbuf_t,
) c_int;

pub extern fn ecs_type_info_to_json(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
) ?[*:0]u8;

pub extern fn ecs_type_info_to_json_buf(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    buf_out: *ecs_strbuf_t,
) c_int;

pub extern fn ecs_entity_to_json(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
    desc: ?*const ecs_entity_to_json_desc_t,
) ?[*:0]u8;

pub extern fn ecs_entity_to_json_buf(
    world: *const ecs_world_t,
    entity: ecs_entity_t,
    buf_out: *ecs_strbuf_t,
    desc: ?*const ecs_entity_to_json_desc_t,
) c_int;

pub extern fn ecs_iter_to_json(
    world: *const ecs_world_t,
    iter: *ecs_iter_t,
    desc: ?*const ecs_iter_to_json_desc_t,
) ?[*:0]u8;

pub extern fn ecs_iter_to_json_buf(
    world: *const ecs_world_t,
    iter: *ecs_iter_t,
    buf_out: *ecs_strbuf_t,
    desc: ?*const ecs_iter_to_json_desc_t,
) c_int;

pub extern fn ecs_world_to_json(
    world: *ecs_world_t,
    desc: ?*const ecs_world_to_json_desc_t,
) ?[*:0]u8;

pub extern fn ecs_world_to_json_buf(
    world: *ecs_world_t,
    buf_out: *ecs_strbuf_t,
    desc: ?*const ecs_world_to_json_desc_t,
) c_int;


// --------------------
// `FLECS_UNITS` addon.
// --------------------

pub extern fn FlecsUnitsImport(
    world: *ecs_world_t,
) void;

pub extern var FLECS__EEcsUnitPrefixes: ecs_entity_t;

pub extern var FLECS__EEcsYocto: ecs_entity_t;
pub extern var FLECS__EEcsZepto: ecs_entity_t;
pub extern var FLECS__EEcsAtto: ecs_entity_t;
pub extern var FLECS__EEcsFemto: ecs_entity_t;
pub extern var FLECS__EEcsPico: ecs_entity_t;
pub extern var FLECS__EEcsNano: ecs_entity_t;
pub extern var FLECS__EEcsMicro: ecs_entity_t;
pub extern var FLECS__EEcsMilli: ecs_entity_t;
pub extern var FLECS__EEcsCenti: ecs_entity_t;
pub extern var FLECS__EEcsDeci: ecs_entity_t;
pub extern var FLECS__EEcsDeca: ecs_entity_t;
pub extern var FLECS__EEcsHecto: ecs_entity_t;
pub extern var FLECS__EEcsKilo: ecs_entity_t;
pub extern var FLECS__EEcsMega: ecs_entity_t;
pub extern var FLECS__EEcsGiga: ecs_entity_t;
pub extern var FLECS__EEcsTera: ecs_entity_t;
pub extern var FLECS__EEcsPeta: ecs_entity_t;
pub extern var FLECS__EEcsExa: ecs_entity_t;
pub extern var FLECS__EEcsZetta: ecs_entity_t;
pub extern var FLECS__EEcsYotta: ecs_entity_t;

pub extern var FLECS__EEcsKibi: ecs_entity_t;
pub extern var FLECS__EEcsMebi: ecs_entity_t;
pub extern var FLECS__EEcsGibi: ecs_entity_t;
pub extern var FLECS__EEcsTebi: ecs_entity_t;
pub extern var FLECS__EEcsPebi: ecs_entity_t;
pub extern var FLECS__EEcsExbi: ecs_entity_t;
pub extern var FLECS__EEcsZebi: ecs_entity_t;
pub extern var FLECS__EEcsYobi: ecs_entity_t;

pub extern var FLECS__EEcsDuration: ecs_entity_t;
pub extern var FLECS__EEcsPicoSeconds: ecs_entity_t;
pub extern var FLECS__EEcsNanoSeconds: ecs_entity_t;
pub extern var FLECS__EEcsMicroSeconds: ecs_entity_t;
pub extern var FLECS__EEcsMilliSeconds: ecs_entity_t;
pub extern var FLECS__EEcsSeconds: ecs_entity_t;
pub extern var FLECS__EEcsMinutes: ecs_entity_t;
pub extern var FLECS__EEcsHours: ecs_entity_t;
pub extern var FLECS__EEcsDays: ecs_entity_t;

pub extern var FLECS__EEcsTime: ecs_entity_t;
pub extern var FLECS__EEcsDate: ecs_entity_t;

pub extern var FLECS__EEcsMass: ecs_entity_t;
pub extern var FLECS__EEcsGrams: ecs_entity_t;
pub extern var FLECS__EEcsKiloGrams: ecs_entity_t;

pub extern var FLECS__EEcsElectricCurrent: ecs_entity_t;
pub extern var FLECS__EEcsAmpere: ecs_entity_t;

pub extern var FLECS__EEcsAmount: ecs_entity_t;
pub extern var FLECS__EEcsMole: ecs_entity_t;

pub extern var FLECS__EEcsLuminousIntensity: ecs_entity_t;
pub extern var FLECS__EEcsCandela: ecs_entity_t;

pub extern var FLECS__EEcsForce: ecs_entity_t;
pub extern var FLECS__EEcsNewton: ecs_entity_t;

pub extern var FLECS__EEcsLength: ecs_entity_t;
pub extern var FLECS__EEcsMeters: ecs_entity_t;
pub extern var FLECS__EEcsPicoMeters: ecs_entity_t;
pub extern var FLECS__EEcsNanoMeters: ecs_entity_t;
pub extern var FLECS__EEcsMicroMeters: ecs_entity_t;
pub extern var FLECS__EEcsMilliMeters: ecs_entity_t;
pub extern var FLECS__EEcsCentiMeters: ecs_entity_t;
pub extern var FLECS__EEcsKiloMeters: ecs_entity_t;
pub extern var FLECS__EEcsMiles: ecs_entity_t;
pub extern var FLECS__EEcsPixels: ecs_entity_t;

pub extern var FLECS__EEcsPressure: ecs_entity_t;
pub extern var FLECS__EEcsPascal: ecs_entity_t;
pub extern var FLECS__EEcsBar: ecs_entity_t;

pub extern var FLECS__EEcsSpeed: ecs_entity_t;
pub extern var FLECS__EEcsMetersPerSecond: ecs_entity_t;
pub extern var FLECS__EEcsKiloMetersPerSecond: ecs_entity_t;
pub extern var FLECS__EEcsKiloMetersPerHour: ecs_entity_t;
pub extern var FLECS__EEcsMilesPerHour: ecs_entity_t;

pub extern var FLECS__EEcsTemperature: ecs_entity_t;
pub extern var FLECS__EEcsKelvin: ecs_entity_t;
pub extern var FLECS__EEcsCelsius: ecs_entity_t;
pub extern var FLECS__EEcsFahrenheit: ecs_entity_t;

pub extern var FLECS__EEcsData: ecs_entity_t;
pub extern var FLECS__EEcsBits: ecs_entity_t;
pub extern var FLECS__EEcsKiloBits: ecs_entity_t;
pub extern var FLECS__EEcsMegaBits: ecs_entity_t;
pub extern var FLECS__EEcsGigaBits: ecs_entity_t;
pub extern var FLECS__EEcsBytes: ecs_entity_t;
pub extern var FLECS__EEcsKiloBytes: ecs_entity_t;
pub extern var FLECS__EEcsMegaBytes: ecs_entity_t;
pub extern var FLECS__EEcsGigaBytes: ecs_entity_t;
pub extern var FLECS__EEcsKibiBytes: ecs_entity_t;
pub extern var FLECS__EEcsMebiBytes: ecs_entity_t;
pub extern var FLECS__EEcsGibiBytes: ecs_entity_t;

pub extern var FLECS__EEcsDataRate: ecs_entity_t;
pub extern var FLECS__EEcsBitsPerSecond: ecs_entity_t;
pub extern var FLECS__EEcsKiloBitsPerSecond: ecs_entity_t;
pub extern var FLECS__EEcsMegaBitsPerSecond: ecs_entity_t;
pub extern var FLECS__EEcsGigaBitsPerSecond: ecs_entity_t;
pub extern var FLECS__EEcsBytesPerSecond: ecs_entity_t;
pub extern var FLECS__EEcsKiloBytesPerSecond: ecs_entity_t;
pub extern var FLECS__EEcsMegaBytesPerSecond: ecs_entity_t;
pub extern var FLECS__EEcsGigaBytesPerSecond: ecs_entity_t;

pub extern var FLECS__EEcsAngle: ecs_entity_t;
pub extern var FLECS__EEcsRadians: ecs_entity_t;
pub extern var FLECS__EEcsDegrees: ecs_entity_t;

pub extern var FLECS__EEcsFrequency: ecs_entity_t;
pub extern var FLECS__EEcsHertz: ecs_entity_t;
pub extern var FLECS__EEcsKiloHertz: ecs_entity_t;
pub extern var FLECS__EEcsMegaHertz: ecs_entity_t;
pub extern var FLECS__EEcsGigaHertz: ecs_entity_t;

pub extern var FLECS__EEcsUri: ecs_entity_t;
pub extern var FLECS__EEcsUriHyperlink: ecs_entity_t;
pub extern var FLECS__EEcsUriImage: ecs_entity_t;
pub extern var FLECS__EEcsUriFile: ecs_entity_t;

pub extern var FLECS__EEcsAcceleration: ecs_entity_t;
pub extern var FLECS__EEcsPercentage: ecs_entity_t;
pub extern var FLECS__EEcsBel: ecs_entity_t;
pub extern var FLECS__EEcsDeciBel: ecs_entity_t;


// -------------------
// `FLECS_META` addon.
// -------------------

pub const ECS_MEMBER_DESC_CACHE_SIZE = 32;
pub const ECS_META_MAX_SCOPE_DEPTH = 32;

pub const ecs_type_kind_t = enum(c_int) {
    EcsPrimitiveType,
    EcsBitmaskType,
    EcsEnumType,
    EcsStructType,
    EcsArrayType,
    EcsVectorType,
    EcsOpaqueType,
};

pub const EcsMetaType = extern struct {
    kind: ecs_type_kind_t,
    existing: bool,
    partial: bool,
    size: i32,
    alignment: i32,
};

pub const ecs_primitive_kind_t = enum(c_int) {
    EcsBool = 1,
    EcsChar,
    EcsByte,
    EcsU8,
    EcsU16,
    EcsU32,
    EcsU64,
    EcsI8,
    EcsI16,
    EcsI32,
    EcsI64,
    EcsF32,
    EcsF64,
    EcsUPtr,
    EcsIPtr,
    EcsString,
    EcsEntity,
};

pub const EcsPrimitive = extern struct {
    kind: ecs_primitive_kind_t,
};

pub const EcsMember = extern struct {
    type: ecs_entity_t,
    count: i32,
    unit: ecs_entity_t,
    offset: i32,
};

pub const ecs_member_t = extern struct {
    name: ?[*:0]const u8,
    type: ecs_entity_t,

    count: i32,
    offset: i32,

    unit: ecs_entity_t,

    size: i32,
    member: ecs_entity_t,
};

pub const EcsStruct = extern struct {
    members: ecs_vec_t,
};

pub const ecs_enum_constant_t = extern struct {
    name: ?[*:0]const u8,
    value: i32,
    constant: ecs_entity_t,
};

pub const EcsEnum = extern struct {
    constants: ecs_map_t,
};

pub const ecs_bitmask_constant_t = extern struct {
    name: ?[*:0]const u8,
    value: ecs_flags32_t,
    constant: ecs_entity_t,
};

pub const EcsBitmask = extern struct {
    constants: ecs_map_t,
};

pub const EcsArray = extern struct {
    type: ecs_entity_t,
    count: i32,
};

pub const EcsVector = extern struct {
    type: ecs_entity_t,
};

pub const ecs_serializer_t = extern struct {
    value: ?*const fn (
        ser: *const ecs_serializer_t,
        type_: ecs_entity_t,
        value: *const anyopaque,
    ) callconv(.C) c_int,

    member: ?*const fn (
        ser: *const ecs_serializer_t,
        member: [*:0]const u8,
    ) callconv(.C) c_int,

    world: *const ecs_world_t,
    ctx: ?*anyopaque,
};

pub const ecs_meta_serialize_t = *const fn (
    ser: *const ecs_serializer_t,
    src: *const anyopaque,
) callconv(.C) c_int;

pub const EcsOpaque = extern struct {
    as_type: ecs_entity_t,
    serialize: ?ecs_meta_serialize_t,

    assign_bool: ?*const fn (
        dst: *anyopaque,
        value: bool,
    ) callconv(.C) void,

    assign_char: ?*const fn (
        dst: *anyopaque,
        value: u8,
    ) callconv(.C) void,

    assign_int: ?*const fn (
        dst: *anyopaque,
        value: i64,
    ) callconv(.C) void,

    assign_uint: ?*const fn (
        dst: *anyopaque,
        value: u64,
    ) callconv(.C) void,

    assign_float: ?*const fn (
        dst: *anyopaque,
        value: f64,
    ) callconv(.C) void,

    assign_string: ?*const fn (
        dst: *anyopaque,
        value: [*:0]const u8,
    ) callconv(.C) void,

    assign_entity: ?*const fn (
        dst: *anyopaque,
        world: *ecs_world_t,
        entity: ecs_entity_t,
    ) callconv(.C) void,

    assign_null: ?*const fn (
        dst: *anyopaque,
    ) callconv(.C) void,

    clear: ?*const fn (
        dst: *anyopaque,
    ) callconv(.C) void,

    ensure_element: ?*const fn (
        dst: *anyopaque,
        elem: usize,
    ) callconv(.C) *anyopaque,

    ensure_member: ?*const fn (
        dst: *anyopaque,
        member: [*:0]const u8,
    ) callconv(.C) *anyopaque,

    count: ?*const fn (
        dst: *const anyopaque,
    ) callconv(.C) usize,

    resize: ?*const fn (
        dst: *anyopaque,
        count: usize,
    ) callconv(.C) void,
};

pub const ecs_unit_translation_t = extern struct {
    factor: i32,
    power: i32,
};

pub const EcsUnit = extern struct {
    symbol: ?[*:0]u8,
    prefix: ecs_entity_t,
    base: ecs_entity_t,
    over: ecs_entity_t,
    translation: ecs_unit_translation_t,
};

pub const EcsUnitPrefix = extern struct {
    symbol: ?[*:0]u8,
    translation: ecs_unit_translation_t,
};

pub const ecs_meta_type_op_kind_t = enum(c_int) {
    EcsOpArray,
    EcsOpVector,
    EcsOpOpaque,
    EcsOpPush,
    EcsOpPop,

    EcsOpScope,

    EcsOpEnum,
    EcsOpBitmask,

    EcsOpPrimitive,

    EcsOpBool,
    EcsOpChar,
    EcsOpByte,
    EcsOpU8,
    EcsOpU16,
    EcsOpU32,
    EcsOpU64,
    EcsOpI8,
    EcsOpI16,
    EcsOpI32,
    EcsOpI64,
    EcsOpF32,
    EcsOpF64,
    EcsOpUPtr,
    EcsOpIPtr,
    EcsOpString,
    EcsOpEntity,
};

pub const ecs_meta_type_op_t = extern struct {
    kind: ecs_meta_type_op_kind_t,
    offset: i32,
    count: i32,
    name: ?[*:0]const u8,
    op_count: i32,
    size: i32,
    type: ecs_entity_t,
    unit: ecs_entity_t,
    members: ?*ecs_hashmap_t,
};

pub const EcsMetaTypeSerialized = extern struct {
    ops: ecs_vec_t,
};

pub const ecs_meta_scope_t = extern struct {
    type: ecs_entity_t,
    ops: ?[*]ecs_meta_type_op_t,
    op_count: i32,
    op_cur: i32,
    elem_cur: i32,
    prev_depth: i32,
    ptr: ?*anyopaque,

    comp: ?*const EcsComponent,
    @"opaque": ?*const EcsOpaque,
    vector: ?*ecs_vec_t,
    members: ?*ecs_hashmap_t,
    is_collection: bool,
    is_inline_array: bool,
    is_empty_scope: bool,
};

pub const ecs_meta_cursor_t = extern struct {
    world: ?*const ecs_world_t,
    scope: [ECS_META_MAX_SCOPE_DEPTH]ecs_meta_scope_t,
    depth: i32,
    valid: bool,
    is_primitive_scope: bool,

    lookup_action: ?*const fn (
        world: *const ecs_world_t,
        path: [*:0]const u8,
        ctx: ?*anyopaque,
    ) callconv(.C) ecs_entity_t,
    lookup_ctx: ?*anyopaque,
};

pub const ecs_primitive_desc_t = extern struct {
    entity: ecs_entity_t,
    kind: ecs_primitive_kind_t,
};

pub const ecs_enum_desc_t = extern struct {
    entity: ecs_entity_t,
    constants: [ECS_MEMBER_DESC_CACHE_SIZE]ecs_enum_constant_t,
};

pub const ecs_bitmask_desc_t = extern struct {
    entity: ecs_entity_t,
    constants: [ECS_MEMBER_DESC_CACHE_SIZE]ecs_bitmask_constant_t,
};

pub const ecs_array_desc_t = extern struct {
    entity: ecs_entity_t,
    type: ecs_entity_t,
    count: i32,
};

pub const ecs_vector_desc_t = extern struct {
    entity: ecs_entity_t,
    type: ecs_entity_t,
};

pub const ecs_struct_desc_t = extern struct {
    entity: ecs_entity_t,
    members: [ECS_MEMBER_DESC_CACHE_SIZE]ecs_member_t,
};

pub const ecs_opaque_desc_t = extern struct {
    entity: ecs_entity_t,
    type: EcsOpaque,
};

pub const ecs_unit_desc_t = extern struct {
    entity: ecs_entity_t,
    symbol: ?[*:0]const u8,
    quanity: ecs_entity_t,
    base: ecs_entity_t,
    over: ecs_entity_t,
    translation: ecs_unit_translation_t,
    prefix: ecs_entity_t,
};

pub const ecs_unit_prefix_desc_t = extern struct {
    entity: ecs_entity_t,
    symbol: ?[*:0]const u8,
    translation: ecs_unit_translation_t,
};

pub extern fn ecs_meta_cursor(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    ptr: *anyopaque,
) ecs_meta_cursor_t;

pub extern fn ecs_meta_get_ptr(
    cursor: *ecs_meta_cursor_t,
) ?*anyopaque;

pub extern fn ecs_meta_next(
    cursor: *ecs_meta_cursor_t,
) c_int;

pub extern fn ecs_meta_elem(
    cursor: *ecs_meta_cursor_t,
    elem: i32,
) c_int;

pub extern fn ecs_meta_member(
    cursor: *ecs_meta_cursor_t,
    name: [*:0]const u8,
) c_int;

pub extern fn ecs_meta_dotmember(
    cursor: *ecs_meta_cursor_t,
    name: [*:0]const u8,
) c_int;

pub extern fn ecs_meta_push(
    cursor: *ecs_meta_cursor_t,
) c_int;

pub extern fn ecs_meta_pop(
    cursor: *ecs_meta_cursor_t,
) c_int;

pub extern fn ecs_meta_is_collection(
    cursor: *const ecs_meta_cursor_t,
) bool;

pub extern fn ecs_meta_get_type(
    cursor: *const ecs_meta_cursor_t,
) ecs_entity_t;

pub extern fn ecs_meta_get_unit(
    cursor: *const ecs_meta_cursor_t,
) ecs_entity_t;

pub extern fn ecs_meta_get_member(
    cursor: *const ecs_meta_cursor_t,
) ?[*:0]const u8;

pub extern fn ecs_meta_set_bool(
    cursor: *ecs_meta_cursor_t,
    value: bool,
) c_int;

pub extern fn ecs_meta_set_char(
    cursor: *ecs_meta_cursor_t,
    value: u8,
) c_int;

pub extern fn ecs_meta_set_int(
    cursor: *ecs_meta_cursor_t,
    value: i64,
) c_int;

pub extern fn ecs_meta_set_uint(
    cursor: *ecs_meta_cursor_t,
    value: u64,
) c_int;

pub extern fn ecs_meta_set_float(
    cursor: *ecs_meta_cursor_t,
    value: f64,
) c_int;

pub extern fn ecs_meta_set_string(
    cursor: *ecs_meta_cursor_t,
    value: [*:0]const u8,
) c_int;

pub extern fn ecs_meta_set_value(
    cursor: *ecs_meta_cursor_t,
    value: *const ecs_value_t,
) c_int;

pub extern fn ecs_meta_get_bool(
    cursor: *const ecs_meta_cursor_t,
) bool;

pub extern fn ecs_meta_get_char(
    cursor: *const ecs_meta_cursor_t,
) u8;

pub extern fn ecs_meta_get_int(
    cursor: *const ecs_meta_cursor_t,
) i64;

pub extern fn ecs_meta_get_uint(
    cursor: *const ecs_meta_cursor_t,
) u64;

pub extern fn ecs_meta_get_string(
    cursor: *const ecs_meta_cursor_t,
) ?[*:0]const u8;

pub extern fn ecs_meta_get_entity(
    cursor: *const ecs_meta_cursor_t,
) ecs_entity_t;

pub extern fn ecs_meta_ptr_to_float(
    type_kind: ecs_primitive_kind_t,
    ptr: *const anyopaque,
) f64;

pub extern fn ecs_primitive_init(
    world: *ecs_world_t,
    desc: *const ecs_primitive_desc_t,
) ecs_entity_t;

pub extern fn ecs_enum_init(
    world: *ecs_world_t,
    desc: *const ecs_enum_desc_t,
) ecs_entity_t;

pub extern fn ecs_bitmask_init(
    world: *ecs_world_t,
    desc: *const ecs_bitmask_desc_t,
) ecs_entity_t;

pub extern fn ecs_array_init(
    world: *ecs_world_t,
    desc: *const ecs_array_desc_t,
) ecs_entity_t;

pub extern fn ecs_vector_init(
    world: *ecs_world_t,
    desc: *const ecs_vector_desc_t,
) ecs_entity_t;

pub extern fn ecs_struct_init(
    world: *ecs_world_t,
    desc: *const ecs_struct_desc_t,
) ecs_entity_t;

pub extern fn ecs_opaque_init(
    world: *ecs_world_t,
    desc: *const ecs_opaque_desc_t,
) ecs_entity_t;

pub extern fn ecs_unit_init(
    world: *ecs_world_t,
    desc: *const ecs_unit_desc_t,
) ecs_entity_t;

pub extern fn ecs_unit_prefix_init(
    world: *ecs_world_t,
    desc: *const ecs_unit_prefix_desc_t,
) ecs_entity_t;

pub extern fn ecs_quantity_init(
    world: *ecs_world_t,
    desc: *const ecs_entity_desc_t,
) ecs_entity_t;

pub extern fn FlecsMetaImport(
    world: *ecs_world_t,
) void;

pub extern const EcsConstant: ecs_entity_t;
pub extern const EcsQuantity: ecs_entity_t;

pub extern const FLECS__EEcsMetaType: ecs_entity_t;
pub extern const FLECS__EEcsMetaTypeSerialized: ecs_entity_t;
pub extern const FLECS__EEcsPrimitive: ecs_entity_t;
pub extern const FLECS__EEcsEnum: ecs_entity_t;
pub extern const FLECS__EEcsBitmask: ecs_entity_t;
pub extern const FLECS__EEcsMember: ecs_entity_t;
pub extern const FLECS__EEcsStruct: ecs_entity_t;
pub extern const FLECS__EEcsArray: ecs_entity_t;
pub extern const FLECS__EEcsVector: ecs_entity_t;
pub extern const FLECS__EEcsOpaque: ecs_entity_t;
pub extern const FLECS__EEcsUnit: ecs_entity_t;
pub extern const FLECS__EEcsUnitPrefix: ecs_entity_t;

pub extern const FLECS__Eecs_bool_t: ecs_entity_t;
pub extern const FLECS__Eecs_char_t: ecs_entity_t;
pub extern const FLECS__Eecs_byte_t: ecs_entity_t;
pub extern const FLECS__Eecs_u8_t: ecs_entity_t;
pub extern const FLECS__Eecs_u16_t: ecs_entity_t;
pub extern const FLECS__Eecs_u32_t: ecs_entity_t;
pub extern const FLECS__Eecs_u64_t: ecs_entity_t;
pub extern const FLECS__Eecs_uptr_t: ecs_entity_t;
pub extern const FLECS__Eecs_i8_t: ecs_entity_t;
pub extern const FLECS__Eecs_i16_t: ecs_entity_t;
pub extern const FLECS__Eecs_i32_t: ecs_entity_t;
pub extern const FLECS__Eecs_i64_t: ecs_entity_t;
pub extern const FLECS__Eecs_iptr_t: ecs_entity_t;
pub extern const FLECS__Eecs_f32_t: ecs_entity_t;
pub extern const FLECS__Eecs_f64_t: ecs_entity_t;
pub extern const FLECS__Eecs_string_t: ecs_entity_t;
pub extern const FLECS__Eecs_entity_t: ecs_entity_t;


// -------------------
// `FLECS_EXPR` addon.
// -------------------

pub const ecs_expr_var_t = extern struct {
    name: ?[*:0]u8,
    value: ecs_value_t,
    owned: bool,
};

pub const ecs_expr_var_scope_t = extern struct {
    var_index: ecs_hashmap_t,
    vars: ecs_vec_t,
    parent: ?*ecs_expr_var_scope_t,
};

pub const ecs_vars_t = extern struct {
    world: ?*ecs_world_t,
    root: ecs_expr_var_scope_t,
    cur: ?*ecs_expr_var_scope_t,
};

pub const ecs_parse_expr_desc_t = extern struct {
    name: ?[*:0]const u8,
    expr: ?[*:0]const u8,

    lookup_action: ?*const fn (
        world: *const ecs_world_t,
        value: [*:0]const u8,
        ctx: ?*anyopaque,
    ) callconv(.C) ecs_entity_t,
    lookup_ctx: ?*anyopaque,

    vars: ?*ecs_vars_t,
};

pub extern fn ecs_chresc(
    out: [*]u8,
    in: u8,
    delimiter: u8,
) [*]u8;

pub extern fn ecs_chrparse(
    in: [*]const u8,
    out: ?*u8,
) [*]const u8;

pub extern fn ecs_stresc(
    out: ?[*]u8,
    size: i32,
    delimiter: u8,
    in: [*:0]const u8,
) i32;

pub extern fn ecs_astresc(
    delimiter: u8,
    in: [*:0]const u8,
) [*:0]u8;

pub extern fn ecs_vars_init(
    world: *ecs_world_t,
    vars: *ecs_vars_t,
) void;

pub extern fn ecs_vars_fini(
    vars: *ecs_vars_t,
) void;

pub extern fn ecs_vars_push(
    vars: *ecs_vars_t,
) void;

pub extern fn ecs_vars_pop(
    vars: *ecs_vars_t,
) c_int;

pub extern fn ecs_vars_declare(
    vars: *ecs_vars_t,
    name: [*:0]const u8,
    type_: ecs_entity_t,
) *ecs_expr_var_t;

pub extern fn ecs_vars_declare_w_value(
    world: *ecs_vars_t,
    name: [*:0]const u8,
    value: *ecs_value_t,
) *ecs_expr_var_t;

pub extern fn ecs_vars_lookup(
    vars: *ecs_vars_t,
    name: [*:0]const u8,
) ?*ecs_expr_var_t;

pub extern fn ecs_parse_expr(
    world: *ecs_world_t,
    ptr: [*:0]const u8,
    value: *ecs_value_t,
    desc: ?*const ecs_parse_expr_desc_t,
) ?[*:0]const u8;

pub extern fn ecs_ptr_to_expr(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    data: *const anyopaque,
) ?[*:0]u8;

pub extern fn ecs_ptr_to_expr_buf(
    world: *const ecs_world_t,
    type_: ecs_entity_t,
    data: *const anyopaque,
    buf: *ecs_strbuf_t,
) c_int;

pub extern fn ecs_primitive_to_expr_buf(
    world: *const ecs_world_t,
    kind: ecs_primitive_kind_t,
    data: *const anyopaque,
    buf: *ecs_strbuf_t,
) c_int;

pub extern fn ecs_parse_expr_token(
    name: ?[*:0]const u8,
    expr: [*:0]const u8,
    ptr: [*:0]const u8,
    token: [*]u8,
) ?[*:0]const u8;


// --------------------
// `FLECS_PLECS` addon.
// --------------------

pub const EcsScript = extern struct {
    using: ecs_vec_t,
    script: ?[*:0]u8,
    prop_defaults: ecs_vec_t,
    world: ?*ecs_world_t,
};

pub const ecs_script_desc_t = extern struct {
    entity: ecs_entity_t,
    filename: ?[*:0]const u8,
    str: ?[*:0]const u8,
};

pub extern fn ecs_plecs_from_str(
    world: *ecs_world_t,
    name: ?[*:0]const u8,
    str: [*:0]const u8,
) c_int;

pub extern fn ecs_plecs_from_file(
    world: *ecs_world_t,
    filename: [*:0]const u8,
) c_int;

pub extern fn ecs_script_init(
    world: *ecs_world_t,
    desc: *const ecs_script_desc_t,
) ecs_entity_t;

pub extern fn ecs_script_update(
    world: *ecs_world_t,
    script: ecs_entity_t,
    instance: ecs_entity_t,
    str: [*:0]const u8,
    vars: ?*ecs_vars_t,
) c_int;

pub extern fn ecs_script_clear(
    world: *ecs_world_t,
    script: ecs_entity_t,
    instance: ecs_entity_t,
) void;

pub extern fn EcsScriptImport(
    world: *ecs_world_t,
) void;

pub extern var FLECS__EEcsScript: ecs_entity_t;


// --------------------
// `FLECS_RULES` addon.
// --------------------

pub extern fn ecs_rule_init(
    world: *ecs_world_t,
    desc: *const ecs_filter_desc_t,
) *ecs_rule_t;

pub extern fn ecs_rule_fini(
    rule: *ecs_rule_t,
) void;

pub extern fn ecs_rule_get_filter(
    rule: *const ecs_rule_t,
) *const ecs_filter_t;

pub extern fn ecs_rule_var_count(
    rule: *const ecs_rule_t,
) i32;

pub extern fn ecs_rule_find_var(
    rule: *const ecs_rule_t,
    name: [*:0]const u8,
) i32;

pub extern fn ecs_rule_var_name(
    rule: *const ecs_rule_t,
    var_id: i32,
) [*:0]const u8;

pub extern fn ecs_rule_var_is_entity(
    rule: *const ecs_rule_t,
    var_id: i32,
) bool;

pub extern fn ecs_rule_iter(
    world: *const ecs_world_t,
    rule: *const ecs_rule_t,
) ecs_iter_t;

pub extern fn ecs_rule_next(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_rule_next_instanced(
    it: *ecs_iter_t,
) bool;

pub extern fn ecs_rule_str(
    rule: *const ecs_rule_t,
) [*:0]u8;

pub extern fn ecs_rule_str_w_profile(
    rule: *const ecs_rule_t,
    it: *const ecs_iter_t,
) [*:0]u8;

pub extern fn ecs_rule_parse_vars(
    rule: *ecs_rule_t,
    it: *ecs_iter_t,
    expr: [*:0]const u8,
) ?[*:0]const u8;


// -----------------------
// `FLECS_SNAPSHOT` addon.
// -----------------------

pub const ecs_snapshot_t = opaque {};

pub extern fn ecs_snapshot_take(
    world: *ecs_world_t,
) *ecs_snapshot_t;

pub extern fn ecs_snapshot_take_w_iter(
    iter: *ecs_iter_t,
) *ecs_snapshot_t;

pub extern fn ecs_snapshot_restore(
    world: *ecs_world_t,
    snapshot: *ecs_snapshot_t,
) void;

pub extern fn ecs_snapshot_iter(
    snapshot: *ecs_snapshot_t,
) ecs_iter_t;

pub extern fn ecs_snapshot_next(
    iter: *ecs_iter_t,
) bool;

pub extern fn ecs_snapshot_free(
    snapshot: *ecs_snapshot_t,
) void;


// ---------------------
// `FLECS_PARSER` addon.
// ---------------------

pub extern fn ecs_parse_ws(
    ptr: [*:0]const u8,
) ?[*:0]const u8;

pub extern fn ecs_parse_w_eol(
    ptr: [*:0]const u8,
) ?[*:0]const u8;

pub extern fn ecs_parse_digit(
    ptr: [*:0]const u8,
    token: [*]u8,
) ?[*:0]const u8;

pub extern fn ecs_parse_token(
    name: ?[*:0]const u8,
    expr: [*:0]const u8,
    ptr: [*:0]const u8,
    token_out: [*]u8,
    delim: u8,
) ?[*:0]const u8;

pub extern fn ecs_parse_term(
    world: *const ecs_world_t,
    name: ?[*:0]const u8,
    expr: ?[*:0]const u8,
    ptr: [*:0]const u8,
    term_out: *ecs_term_t,
) ?[*:0]u8;


// -------------------
// `FLECS_HTTP` addon.
// -------------------

pub const ECS_HTTP_HEADER_COUNT_MAX = 32;

pub const ecs_http_server_t = opaque {};

pub const ecs_http_connection_t = extern struct {
    id: u64,
    server: ?*ecs_http_server_t,

    host: [128]u8,
    port: [16]u8,
};

pub const ecs_http_key_value_t = extern struct {
    key: ?[*:0]const u8,
    value: ?[*:0]const u8,
};

pub const ecs_http_method_t = enum(c_int) {
    EcsHttpGet,
    EcsHttpPost,
    EcsHttpPut,
    EcsHttpDelete,
    EcsHttpOptions,
    EcsHttpMethodUnsupported,
};

pub const ecs_http_request_t = extern struct {
    id: u64,

    method: ecs_http_method_t,
    path: ?[*:0]u8,
    body: ?[*:0]u8,
    headers: [ECS_HTTP_HEADER_COUNT_MAX]ecs_http_key_value_t,
    params: [ECS_HTTP_HEADER_COUNT_MAX]ecs_http_key_value_t,
    header_count: i32,
    param_count: i32,

    conn: ?*ecs_http_connection_t,
};

pub const ecs_http_reply_t = extern struct {
    code: c_int = 200,
    body: ecs_strbuf_t = .{},
    status: ?[*:0]const u8 = "OK",
    content_type: ?[*:0]const u8 = "application/json",
    headers: ecs_strbuf_t = .{},
};

pub const ecs_http_reply_action_t = *const fn (
    request: *const ecs_http_request_t,
    reply: *ecs_http_reply_t,
    ctx: ?*anyopaque,
) callconv(.C) bool;

pub const ecs_http_server_desc_t = extern struct {
    callback: ?ecs_http_reply_action_t,
    ctx: ?*anyopaque,
    port: u16,
    ipaddr: ?[*:0]const u8,
    send_queue_wait_ms: i32,
};

pub extern fn ecs_http_server_init(
    desc: *const ecs_http_server_desc_t,
) ?*ecs_http_server_t;

pub extern fn ecs_http_server_fini(
    server: *ecs_http_server_t,
) void;

pub extern fn ecs_http_server_start(
    server: *ecs_http_server_t,
) c_int;

pub extern fn ecs_http_server_dequeue(
    server: *ecs_http_server_t,
    delta_time: ecs_ftime_t,
) void;

pub extern fn ecs_http_server_stop(
    server: *ecs_http_server_t,
) void;

pub extern fn ecs_http_server_http_request(
    srv: *ecs_http_server_t,
    req: [*]const u8, // [*:0]const u8 if len isn't provided.
    len: i32,
    reply_out: *ecs_http_reply_t,
) c_int;

pub extern fn ecs_http_server_request(
    srv: *ecs_http_server_t,
    method: [*:0]const u8,
    req: [*:0]const u8,
    reply_out: *ecs_http_reply_t,
) c_int;

pub extern fn ecs_http_server_ctx(
    srv: *ecs_http_server_t,
) ?*anyopaque;

pub extern fn ecs_http_get_header(
    req: *const ecs_http_request_t,
    name: [*:0]const u8,
) ?[*:0]const u8;

pub extern fn ecs_http_get_param(
    req: *const ecs_http_request_t,
    name: [*:0]const u8,
) ?[*:0]const u8;


// --------------------------
// `FLECS_OS_API_IMPL` addon.
// --------------------------

pub extern fn ecs_set_os_api_impl() void;


// ---------------------
// `FLECS_MODULE` addon.
// ---------------------

pub extern fn ecs_import(
    world: *ecs_world_t,
    module: ecs_module_action_t,
    module_name: [*:0]const u8,
) ecs_entity_t;

pub extern fn ecs_import_c(
    world: *ecs_world_t,
    module: ecs_module_action_t,
    module_name_c: [*:0]const u8,
) ecs_entity_t;

pub extern fn ecs_import_from_library(
    world: *ecs_world_t,
    library_name: [*:0]const u8,
    module_name: ?[*:0]const u8,
) ecs_entity_t;

pub extern fn ecs_module_init(
    world: *ecs_world_t,
    c_name: [*:0]const u8,
    desc: *const ecs_component_desc_t,
) ecs_entity_t;


test {
    @setEvalBranchQuota(@typeInfo(@This()).Struct.decls.len * 2);

    const std = @import("std");
    comptime std.testing.refAllDecls(@This());
}
