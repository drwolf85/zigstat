const std = @import("std");
var prng = std.Random.DefaultPrng.init(888);
const rnd = prng.random();
extern "c" fn erf(f64) f64;

const sqrt2pi = @sqrt(2.0 * std.math.pi);
const sqrt2 = @sqrt(2.0);

pub fn dnorm(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var z: T = arg_x - arg_m;
    z /= arg_s;
    z = @exp((-0.5 * z) * z);
    z /= arg_s * @as(T, @floatCast(sqrt2pi));
    return z;
}

pub fn pnorm(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var z: T = arg_x - arg_m;
    z /= arg_s * @as(T, @floatCast(sqrt2));
    const z64: f64 = @as(f64, @floatCast(z));
    z = 0.5 + (0.5 * @as(T, @floatCast(erf(z64))));
    return z;
}

pub fn qnorm(comptime T: type, arg_p: T, arg_m: T, arg_s: T) T {
    var old: f128 = undefined;
    var z: f128 = 0.25 * @log(arg_p / (1.0 - arg_p));
    var sdv: f128 = dnorm(f128, z, 0.0, 1.0);
    while (true) {
        old = z;
        z += (arg_p - pnorm(f128, z, 0.0, 1.0)) / sdv;
        sdv = dnorm(f128, z, 0.0, 1.0);
        if (!((sdv > 0.000000001) and (@abs(old - z) > 0.000000000001))) break;
    }
    return @as(T, @floatCast((arg_s * z) + arg_m));
}

pub fn rnorm(comptime T: type, arg_mu: T, arg_sd: T) T {
    var a: T = undefined;
    if (T != f128) {
	@branchHint(.unlikely);
        a = rnd.floatNorm(T);
    }
    else {
        var m: u32 = (1 << 16) - 1;
        var u: u32 = rnd.int(u32);
        var v: u32 = (((u >> 16) & m) | ((u & m) << 16));
        m = ~@as(u32, 1 << 31);
        u &= m;
        v &= m;
        a = @as(T, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(u)), -30) - 1.0));
        var s: T = a * a;
        const b: T = @as(T, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(v)), -30) - 1.0));
        s += b * b * (1.0 - s);
        s = -2.0 * @log(s) / s;
        a = b * @sqrt(s);
    }
    return arg_mu + arg_sd * a;
}

//  zig test normal.zig -lm # Run this line on the terminal to test the following function
test "\nBasic functions for the Normal distribution" {
    const myPreferredType: type = f64;
    std.debug.print("\ndnorm(0, 0, 1) = {}\n", .{dnorm(myPreferredType, 0.0, 0.0, 1.0)});
    std.debug.print("pnorm(1.96, 0, 1) = {}\n", .{pnorm(myPreferredType, 1.96, 0.0, 1.0)});
    std.debug.print("qnorm(0.95, 0, 1) = {}\n", .{qnorm(myPreferredType, 0.95, 0.0, 1.0)});
    std.debug.print("rnorm(0, 1):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.6}, ", .{rnorm(myPreferredType, 0.0, 1.0)});
    }
    std.debug.print("{d:.5}\n", .{rnorm(myPreferredType, 0.0, 1.0)});
}
