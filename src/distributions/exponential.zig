const std = @import("std");
const mln2x31 = 31.0 * 0.6931471805599453;

var rnd = std.rand.DefaultPrng.init(888);

pub export fn dexp(arg_x: f64, arg_lambda: f64) f64 {
    var z: f64 = undefined;
    if (arg_lambda >= 0.0) {
        z = 0.0;
        if (arg_x >= 0.0) {
            z = arg_lambda * @exp(-arg_lambda * arg_x);
        }
    }
    return z;
}

pub export fn pexp(arg_x: f64, arg_lambda: f64) f64 {
    var z: f64 = undefined;
    if (arg_lambda >= 0.0) {
        z = 0.0;
        if (arg_x > 0.0) {
            z = 1.0 - @exp(-arg_lambda * arg_x);
        }
    }
    return z;
}

pub export fn qexp(arg_p: f64, arg_lambda: f64) f64 {
    var z: f64 = undefined;
    if (((arg_lambda >= 0.0) and (arg_p >= 0.0)) and (arg_p <= 1.0)) {
        z = -std.math.log1p(-arg_p) / arg_lambda;
    }
    return z;
}

pub export fn rexp(arg_lambda: f64) f64 {
    var u: u32 = rnd.random().int(u32);
    var m: u32 = ~@as(u32, 1 << 31);
    var z: f64 = undefined;
    if (arg_lambda >= 0.0) {
        u &= m;
        z = mln2x31;
        z -= @log(@as(f64, @floatFromInt(u)));
        z /= arg_lambda;
    }
    return z;
}

//  zig test exponential.zig -lm # Run this line on the terminal to test the following function
test "\nBasic functions for the Exponential distribution" {
    std.debug.print("\ndexp(1.64, 2) = {}\n", .{dexp(1.64, 2.0)});
    std.debug.print("pexp(1.64, 2) = {}\n", .{pexp(1.64, 2.0)});
    std.debug.print("qexp(0.95, 1) = {}\n", .{qexp(0.95, 1.0)});
    std.debug.print("rexp(2):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.6}, ", .{rexp(2.0)});
    }
    std.debug.print("{d:.5}\n", .{rexp(2.0)});
}

