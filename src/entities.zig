// -----------------------------
// Core entities and components.
// -----------------------------

pub const Component = @import("c.zig").EcsComponent;
pub const Identifier = @import("c.zig").EcsIdentifier;
pub const Iterable = @import("c.zig").EcsIterable;
pub const Poly = @import("c.zig").EcsPoly;
pub const Target = @import("c.zig").EcsTarget;

pub const QueryTag = struct {};
pub const ObserverTag = struct {};
pub const SystemTag = struct {};
pub const Flecs = struct {};
pub const FlecsCore = struct {};
pub const WorldEntity = struct {};
pub const Wildcard = struct {};
pub const Any = struct {};
pub const This = struct {};
pub const Variable = struct {};
pub const Transitive = struct {};
pub const Reflexive = struct {};
pub const Final = struct {};
pub const DontInherit = struct {};
pub const AlwaysOverride = struct {};
pub const Symmetric = struct {};
pub const Exclusive = struct {};
pub const Acyclic = struct {};
pub const Traversable = struct {};
pub const With = struct {};
pub const OneOf = struct {};
pub const Tag = struct {};
pub const Name = struct {};
pub const Symbol = struct {};
pub const Alias = struct {};
pub const ChildOf = struct {};
pub const IsA = struct {};
pub const DependsOn = struct {};
pub const SlotOf = struct {};
pub const Module = struct {};
pub const Private = struct {};
pub const Prefab = struct {};
pub const Disabled = struct {};
pub const OnAdd = struct {};
pub const OnRemove = struct {};
pub const OnSet = struct {};
pub const UnSet = struct {};
pub const Monitor = struct {};
pub const OnDelete = struct {};
pub const OnTableCreate = struct {};
pub const OnTableEmpty = struct {};
pub const OnTableFill = struct {};
pub const OnDeleteTarget = struct {};
pub const Remove = struct {};
pub const Delete = struct {};
pub const Panic = struct {};
pub const Flatten = struct {};
pub const DefaultChildComponent = struct {};
pub const PredEq = struct {};
pub const PredMatch = struct {};
pub const PredLookup = struct {};
pub const Empty = struct {};
pub const OnStart = struct {};
pub const PreFrame = struct {};
pub const OnLoad = struct {};
pub const PostLoad = struct {};
pub const PreUpdate = struct {};
pub const OnUpdate = struct {};
pub const OnValidate = struct {};
pub const PostUpdate = struct {};
pub const PreStore = struct {};
pub const OnStore = struct {};
pub const PostFrame = struct {};
pub const Phase = struct {};


// -------------------
// `FLECS_REST` addon.
// -------------------

pub const Rest = @import("c.zig").EcsRest;


// --------------------
// `FLECS_TIMER` addon.
// --------------------

pub const Timer = @import("c.zig").EcsTimer;
pub const RateFilter = @import("c.zig").EcsRateFilter;


// ---------------------
// `FLECS_SYSTEM` addon.
// ---------------------

pub const TickSource = @import("c.zig").EcsTickSource;


// ----------------------
// `FLECS_MONITOR` addon.
// ----------------------

pub const Period1s = struct {};
pub const Period1m = struct {};
pub const Period1h = struct {};
pub const Period1d = struct {};
pub const Period1w = struct {};

pub const FlecsMonitor = struct {};

pub const WorldStats = @import("c.zig").EcsWorldStats;
pub const PipelineStats = @import("c.zig").EcsPipelineStats;


// ------------------
// `FLECS_DOC` addon.
// ------------------

pub const DocBrief = struct {};
pub const DocDetail = struct {};
pub const DocLink = struct {};
pub const DocColor = struct {};
pub const DocDescription = @import("c.zig").EcsDocDescription;


// --------------------
// `FLECS_UNITS` addon.
// --------------------

pub const UnitPrefixes = struct {};

pub const Yocto = struct {};
pub const Zepto = struct {};
pub const Atto = struct {};
pub const Femto = struct {};
pub const Pico = struct {};
pub const Nano = struct {};
pub const Micro = struct {};
pub const Milli = struct {};
pub const Centi = struct {};
pub const Deci = struct {};
pub const Deca = struct {};
pub const Hecto = struct {};
pub const Kilo = struct {};
pub const Mega = struct {};
pub const Giga = struct {};
pub const Tera = struct {};
pub const Peta = struct {};
pub const Exa = struct {};
pub const Zetta = struct {};
pub const Yotta = struct {};

pub const Kibi = struct {};
pub const Mebi = struct {};
pub const Gibi = struct {};
pub const Tebi = struct {};
pub const Exbi = struct {};
pub const Zebi = struct {};
pub const Yobi = struct {};

pub const Duration = struct {};
pub const PicoSeconds = struct {};
pub const NanoSeconds = struct {};
pub const MicroSeconds = struct {};
pub const MilliSeconds = struct {};
pub const Seconds = struct {};
pub const Minutes = struct {};
pub const Hours = struct {};
pub const Days = struct {};

pub const Time = struct {};
pub const Date = struct {};

pub const Mass = struct {};
pub const Grams = struct {};
pub const KiloGrams = struct {};

pub const ElectricCurrent = struct {};
pub const Ampere = struct {};

pub const Amount = struct {};
pub const Mole = struct {};

pub const LuminousIntensity = struct {};
pub const Candela = struct {};

pub const Force = struct {};
pub const Newton = struct {};

pub const Length = struct {};
pub const Meters = struct {};
pub const PicoMeters = struct {};
pub const NanoMeters = struct {};
pub const MicroMeters = struct {};
pub const MilliMeters = struct {};
pub const CentiMeters = struct {};
pub const KiloMeters = struct {};
pub const Miles = struct {};
pub const Pixels = struct {};

pub const Pressure = struct {};
pub const Pascal = struct {};
pub const Bar = struct {};

pub const Temperature = struct {};
pub const Kelvin = struct {};
pub const Celsius = struct {};
pub const Fahrenheit = struct {};

pub const Data = struct {};
pub const Bits = struct {};
pub const KiloBits = struct {};
pub const MegaBits = struct {};
pub const GigaBits = struct {};
pub const Bytes = struct {};
pub const KiloBytes = struct {};
pub const MegaBytes = struct {};
pub const GigaBytes = struct {};
pub const KibiBytes = struct {};
pub const MebiBytes = struct {};
pub const GibiBytes = struct {};

pub const DataRate = struct {};
pub const BitsPerSecond = struct {};
pub const KiloBitsPerSecond = struct {};
pub const MegaBitsPerSecond = struct {};
pub const GigaBitsPerSecond = struct {};
pub const BytesPerSecond = struct {};
pub const KiloBytesPerSecond = struct {};
pub const MegaBytesPerSecond = struct {};
pub const GigaBytesPerSecond = struct {};

pub const Angle = struct {};
pub const Radians = struct {};
pub const Degrees = struct {};

pub const Frequency = struct {};
pub const Hertz = struct {};
pub const KiloHertz = struct {};
pub const MegaHertz = struct {};
pub const GigaHertz = struct {};

pub const Uri = struct {};
pub const UriHyperlink = struct {};
pub const UriImage = struct {};
pub const UriFile = struct {};

pub const Acceleration = struct {};
pub const Percentage = struct {};
pub const Bel = struct {};
pub const DeciBel = struct {};


// -------------------
// `FLECS_META` addon.
// -------------------

pub const Constant = struct {};
pub const Quantity = struct {};

pub const MetaType = @import("c.zig").EcsMetaType;
pub const MetaTypeSerialized = @import("c.zig").EcsMetaTypeSerialized;
pub const Primitive = @import("c.zig").EcsPrimitive;
pub const Enum = @import("c.zig").EcsEnum;
pub const Bitmask = @import("c.zig").EcsBitmask;
pub const Member = @import("c.zig").EcsMember;
pub const Struct = @import("c.zig").EcsStruct;
pub const Array = @import("c.zig").EcsArray;
pub const Vector = @import("c.zig").EcsVector;
pub const Opaque = @import("c.zig").EcsOpaque;
pub const Unit = @import("c.zig").EcsUnit;
pub const UnitPrefix = @import("c.zig").EcsUnitPrefix;

pub const @"bool" = extern struct { bool };

pub const char = extern struct { u8 };
pub const byte = extern struct { u8 };
pub const string = extern struct { ?[*:0]u8 };

pub const @"u8" = extern struct { u8 };
pub const @"u16" = extern struct { u16 };
pub const @"u32" = extern struct { u32 };
pub const @"u64" = extern struct { u64 };
pub const uptr = extern struct { usize };

pub const @"i8" = extern struct { i8 };
pub const @"i16" = extern struct { i16 };
pub const @"i32" = extern struct { i32 };
pub const @"i64" = extern struct { i64 };
pub const iptr = extern struct { isize };

pub const @"f32" = extern struct { f32 };
pub const @"f64" = extern struct { f64 };


// --------------------
// `FLECS_PLECS` addon.
// --------------------

pub const Script = @import("c.zig").EcsScript;


test {
    @setEvalBranchQuota(@typeInfo(@This()).Struct.decls.len * 2);

    const std = @import("std");
    comptime std.testing.refAllDecls(@This());
}
