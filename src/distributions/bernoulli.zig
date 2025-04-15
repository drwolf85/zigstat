const std = @import("std");
var rnd = std.Random.DefaultPrng.init(888);

inline fn bool2float(comptime T: type, arg_x: bool) T {
    return @as(T, @floatFromInt(@intFromBool(arg_x)));
}

pub fn dbern(comptime T: type, arg_x: bool, arg_prob: T) T {
    var z: T = undefined;
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = bool2float(T, !arg_x) * (1.0 - arg_prob);
        z += bool2float(T, arg_x) * arg_prob;
    }
    return z;
}

pub fn pbern(comptime T: type, arg_x: bool, arg_prob: T) T {
    var z: T = undefined;
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = bool2float(T, !arg_x) * (1.0 - arg_prob);
        z += bool2float(T, arg_x);
    }
    return z;
}

pub fn qbern(comptime T: type, arg_p: T, arg_prob: T) u8 {
    var z: u1 = undefined;
    if ((((arg_prob >= 0.0) and (arg_prob <= 1.0)) and (arg_p >= 0.0)) and (arg_p <= 1.0)) {
        z = @intFromBool(arg_p <= arg_prob);
    }
    return @as(u8, z);
}

pub fn rbern(comptime T: type, arg_prob: T) u8 {
    const u: u32 = rnd.random().int(u32);
    const m: u32 = ~@as(u32, 1 << 31);
    var z: u1 = undefined;
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = @intFromBool(std.math.ldexp(@as(f64, @floatFromInt(u & m)), -31) <= arg_prob);
    }
    return @as(u8, z);
}

//  zig test bernoulli.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Bernoulli distribution" {
    const myFavoriteType: type = f64;
    std.debug.print("\ndbern(true, 0.5) = {}\n", .{dbern(myFavoriteType, true, 0.5)});
    std.debug.print("pbern(true, 0.750) = {}\n", .{pbern(myFavoriteType, true, 0.75)});
    std.debug.print("qbern(0.95, 0.444) = {}\n", .{qbern(myFavoriteType, 0.95, 0.444)});
    std.debug.print("rbern(0.5): ", .{});
    for (0..7) |_| {
        std.debug.print("{}, ", .{rbern(myFavoriteType, 0.5)});
    }
    std.debug.print("{}\n", .{rbern(myFavoriteType, 0.5)});
}
