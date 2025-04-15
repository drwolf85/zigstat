const std = @import("std");
const mln2x31 = 31.0 * 0.6931471805599453;

var rnd = std.Random.DefaultPrng.init(888);

pub fn dexp(comptime T: type, arg_x: T, arg_lambda: T) T {
    var z: T = undefined;
    if (arg_lambda >= 0.0) {
        z = 0.0;
        if (arg_x >= 0.0) {
            z = arg_lambda * @exp(-arg_lambda * arg_x);
        }
    }
    return z;
}

pub fn pexp(comptime T: type, arg_x: T, arg_lambda: T) T {
    var z: T = undefined;
    if (arg_lambda >= 0.0) {
        z = 0.0;
        if (arg_x > 0.0) {
            z = 1.0 - @exp(-arg_lambda * arg_x);
        }
    }
    return z;
}

pub fn qexp(comptime T: type, arg_p: T, arg_lambda: T) T {
    var z: T = undefined;
    if (((arg_lambda >= 0.0) and (arg_p >= 0.0)) and (arg_p <= 1.0)) {
        const ap64: f64 = @as(f64, @floatCast(-arg_p));
        z = -@as(T, @floatCast(std.math.log1p(ap64))) / arg_lambda;
    }
    return z;
}

pub fn rexp(comptime T: type, arg_lambda: T) T {
    var u: u32 = rnd.random().int(u32);
    const m: u32 = ~@as(u32, 1 << 31);
    var z: T = undefined;
    if (arg_lambda >= 0.0) {
        u &= m;
        z = mln2x31;
        z -= @log(@as(T, @floatFromInt(u)));
        z /= arg_lambda;
    }
    return z;
}

//  zig test exponential.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Exponential distribution" {
    const mft: type = f64;
    std.debug.print("\ndexp(1.64, 2) = {}\n", .{dexp(mft, 1.64, 2.0)});
    std.debug.print("pexp(1.64, 2) = {}\n", .{pexp(mft, 1.64, 2.0)});
    std.debug.print("qexp(0.95, 1) = {}\n", .{qexp(mft, 0.95, 1.0)});
    std.debug.print("rexp(2):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.6}, ", .{rexp(mft, 2.0)});
    }
    std.debug.print("{d:.5}\n", .{rexp(mft, 2.0)});
}
