const std = @import("std");
var rnd = std.rand.DefaultPrng.init(888);
extern "c" fn erf(f64) f64;

const sqrt2pi: f64 = @sqrt(2.0 * std.math.pi);
const sqrt2: f64 = @sqrt(2.0);

pub export fn dnorm(arg_x: f64, arg_m: f64, arg_s: f64) f64 {    
    var z: f64 = arg_x - arg_m;
    z /= arg_s;
    z = @exp((-0.5 * z) * z);
    z /= arg_s * sqrt2pi;
    return z;
}

pub export fn pnorm(arg_x: f64, arg_m: f64, arg_s: f64) f64 {
    var z: f64 = arg_x - arg_m;
    z /= arg_s * sqrt2;
    z = 0.5 + (0.5 * erf(z));
    return z;
}

pub export fn qnorm(arg_p: f64, arg_m: f64, arg_s: f64) f64 {
    var old: f64 = undefined;
    var z: f64 = 0.25 * @log(arg_p / (1.0 - arg_p));
    var sdv: f64 = dnorm(z, 0.0, 1.0);
    while (true) {
        old = z;
        z += (arg_p - pnorm(z, 0.0, 1.0)) / sdv;
        sdv = dnorm(z, 0.0, 1.0);
        if (!((sdv > 0.000000001) and (@abs(old - z) > 0.000000000001))) break;
    }
    return (arg_s * z) + arg_m;
}

pub export fn rnorm(arg_mu: f64, arg_sd: f64) f64 {
    var m: u32 = (1 << 16) - 1;
    var u: u32 = rnd.random().int(u32);
    var v: u32 = (((u >> 16) & m) | ((u & m) << 16));
    m = ~@as(u32, 1 << 31);
    u &= m;
    v &= m;
    var a: f64 = std.math.ldexp(@as(f64, @floatFromInt(u)), -30) - 1.0;
    var s: f64 = a * a;
    var b: f64 = std.math.ldexp(@as(f64, @floatFromInt(v)), -30) - 1.0;
    s += b * b * (1.0 - s);
    s = -2.0 * @log(s) / s;
    a = b * @sqrt(s);
    return arg_mu + arg_sd * a;
}

//  zig test normal.zig -lm # Run this line on the terminal to test the following function
test "\nBasic functions for the Normal distribution" {
    std.debug.print("\ndnorm(0, 0, 1) = {}\n", .{dnorm(0.0, 0.0, 1.0)});
    std.debug.print("pnorm(1.96, 0, 1) = {}\n", .{pnorm(1.96, 0.0, 1.0)});
    std.debug.print("qnorm(0.95, 0, 1) = {}\n", .{qnorm(0.95, 0.0, 1.0)});
    std.debug.print("rnorm(0, 1):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.6}, ", .{rnorm(0.0, 1.0)});
    }
    std.debug.print("{d:.5}\n", .{rnorm(0.0, 1.0)});
}

