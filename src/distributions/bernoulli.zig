const std = @import("std");
var rnd = std.rand.DefaultPrng.init(888);

inline fn bool2float(arg_x: bool) f64 {
    return @as(f64, @floatFromInt(@intFromBool(arg_x)));
}

pub export fn dbern(arg_x: bool, arg_prob: f64) f64 {
    var z: f64 = undefined;
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = bool2float(!arg_x) * (1.0 - arg_prob);
        z += bool2float(arg_x) * arg_prob;
    }
    return z;
}

pub export fn pbern(arg_x: bool, arg_prob: f64) f64 {
    var z: f64 = undefined;
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = bool2float(!arg_x) * (1.0 - arg_prob);
        z += bool2float(arg_x);
    }
    return z;
}

pub export fn qbern(arg_p: f64, arg_prob: f64) u8 {
    var z: u1 = undefined;
    if ((((arg_prob >= 0.0) and (arg_prob <= 1.0)) and (arg_p >= 0.0)) and (arg_p <= 1.0)) {
        z = @intFromBool(arg_p <= arg_prob);
    }
    return @as(u8, z);
}

pub export fn rbern(arg_prob: f64) u8 {
    var u: u32 = rnd.random().int(u32);
    var m: u32 = ~@as(u32, 1 << 31);
    var z: u1 = undefined;
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = @intFromBool(std.math.ldexp(@as(f64, @floatFromInt(u & m)), -31) <= arg_prob);
    }
    return @as(u8, z);
}

//  zig test bernoulli.zig -lm # Run this line on the terminal to test the following function
test "\nBasic functions for the Bernoulli distribution" {
    std.debug.print("\ndbern(true, 0.5) = {}\n", .{dbern(true, 0.5)});
    std.debug.print("pbern(true, 0.750) = {}\n", .{pbern(true, 0.75)});
    std.debug.print("qbern(0.95, 0.444) = {}\n", .{qbern(0.95, 0.444)});
    std.debug.print("rbern(0.5): ", .{});
    for (0..7) |_| {
        std.debug.print("{}, ", .{rbern(0.5)});
    }
    std.debug.print("{}\n", .{rbern(0.5)});
}
