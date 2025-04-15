const std = @import("std");
var rnd = std.Random.DefaultPrng.init(888);
extern "c" fn erf(f64) f64;

const sqrt2pi = @sqrt(2.0 * std.math.pi);
const sqrt2 = @sqrt(2.0);

pub fn dlognorm(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var z: T = @log(arg_x) - arg_m;
    z /= arg_s;
    z = @exp((-0.5 * z) * z);
    z /= arg_x * arg_s * sqrt2pi;
    return z;
}

pub fn plognorm(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var z: T = @log(arg_x) - arg_m;
    z /= arg_s * sqrt2;
    z = 0.5 + (0.5 * @as(T, @floatCast(erf(@as(f64, @floatCast(z))))));
    return z;
}

pub fn qlognorm(comptime T: type, arg_p: T, arg_m: T, arg_s: T) T {
    var old: f128 = undefined;
    var z: f128 = 0.25 * @log(arg_p / (1.0 - arg_p));
    var sdv: f128 = dlognorm(f128, @exp(z), 0.0, 1.0);
    while (true) {
        old = z;
        z += (arg_p - plognorm(f128, z, 0.0, 1.0)) / sdv;
        sdv = dlognorm(f128, z, 0.0, 1.0);
        if (!((sdv > 0.000000001) and (@abs(old - z) > 0.000000000001))) break;
    }
    return @as(T, @floatCast((arg_s * z) + arg_m));
}

pub fn rlognorm(comptime T: type, arg_mu: T, arg_sd: T) T {
    var m: u32 = (1 << 16) - 1;
    var u: u32 = rnd.random().int(u32);
    var v: u32 = (((u >> 16) & m) | ((u & m) << 16));
    m = ~@as(u32, 1 << 31);
    u &= m;
    v &= m;
    var a: T = @as(T, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(u)), -30) - 1.0));
    var s: T = a * a;
    const b: T = @as(T, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(v)), -30) - 1.0));
    s += b * b * (1.0 - s);
    s = -2.0 * @log(s) / s;
    a = b * @sqrt(s);
    return @exp(arg_mu + arg_sd * a);
}

//  zig test lognormal.zig -lm # Run this line on the terminal to test the following function
test "\nBasic functions for the Log-Normal distribution" {
    const mft: type = f64;
    std.debug.print("\ndlognorm(1.64, 0, 1) = {}\n", .{dlognorm(mft, 1.64, 0.0, 1.0)});
    std.debug.print("plognorm(1.64, 0, 1) = {}\n", .{plognorm(mft, 1.64, 0.0, 1.0)});
    std.debug.print("qlognorm(0.95, 0, 1) = {}\n", .{qlognorm(mft, 0.95, 0.0, 1.0)});
    std.debug.print("rlognorm(0, 1):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.6}, ", .{rlognorm(mft, 0.0, 1.0)});
    }
    std.debug.print("{d:.5}\n", .{rlognorm(mft, 0.0, 1.0)});
}
