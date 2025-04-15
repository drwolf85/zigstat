const std = @import("std");
var rnd = std.Random.DefaultPrng.init(888);

pub fn dcauchy(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var x = arg_x;
    var s = arg_s;
    var z: T = undefined;
    if (s >= 0.0) {
        x -= arg_m;
        s = 1.0 / s;
        z = x * s;
    }
    z = 1.0 + (z * z);
    return (0.3183098861837907 * s) / z;
}

pub fn pcauchy(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var x = arg_x;
    var z: T = undefined;
    if (arg_s >= 0.0) {
        x -= arg_m;
        z = x / arg_s;
    }
    const z64: f64 = @as(f64, @floatCast(z));
    return 0.5 + (@as(T, @floatCast(std.math.atan(z64))) * 0.3183098861837907);
}

pub fn qcauchy(comptime T: type, arg_p: T, arg_m: T, arg_s: T) T {
    var z: T = undefined;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and (arg_s >= 0.0)) {
        z = std.math.pi * (arg_p - 0.5);
    }
    z = @tan(z);
    return (arg_s * z) + arg_m;
}

pub fn rcauchy(comptime T: type, arg_mu: T, arg_sd: T) T {
    const u: u32 = rnd.random().int(u32);
    const m: u32 = ~@as(u32, 1 << 31);
    return qcauchy(T, @as(T, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(u & m)), -31))), arg_mu, arg_sd);
}

// zig test cauchy.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Cauchy distribution" {
    const mft: type = f64;
    std.debug.print("\ndcauchy(-1.64, 0.0, 1.0) = {}\n", .{dcauchy(mft, -1.64, 0.0, 1.0)});
    std.debug.print("pcauchy(-1.64, 0.0, 1.0) = {}\n", .{pcauchy(mft, -1.64, 0.0, 1.0)});
    std.debug.print("qcauchy(0.95, 0.0, 1.0) = {}\n", .{qcauchy(mft, 0.95, 0.0, 1.0)});
    std.debug.print("rcauchy(0, 1): ", .{});
    for (0..7) |_| {
        std.debug.print("{d:.4}, ", .{rcauchy(mft, 0.0, 1.0)});
    }
    std.debug.print("{d:.4}\n", .{rcauchy(mft, 0.0, 1.0)});
}
