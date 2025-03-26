const std = @import("std");
extern "c" fn lgamma(f64) f64;
var rnd = std.Random.DefaultPrng.init(888);

inline fn bool2float(arg_x: bool) f64 {
    return @as(f64, @floatFromInt(@intFromBool(arg_x)));
}

inline fn binom(arg_n: u32, arg_k: u32) f64 {
    var res: f64 = lgamma(@as(f64, @floatFromInt(arg_n + 1)));
    res -= lgamma(@as(f64, @floatFromInt(arg_k + 1)));
    res -= lgamma(@as(f64, @floatFromInt(arg_n - arg_k + 1)));
    return @exp(res);
}

pub export fn dbinom(arg_x: u32, arg_n: u32, arg_prob: f64) f64 {
    var z: f64 = undefined;
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = binom(arg_n, arg_x);
        z *= std.math.pow(f64, arg_prob, @as(f64, @floatFromInt(arg_x)));
        z *= std.math.pow(f64, 1.0 - arg_prob, @as(f64, @floatFromInt(arg_n - arg_x)));
    }
    return z;
}

pub export fn pbinom(arg_x: u32, arg_n: u32, arg_prob: f64) f64 {
    var i: u32 = 1;
    var z: f64 = undefined;
    if (((arg_x >= 0) and (arg_x <= arg_n)) and ((arg_prob >= 0.0) and (arg_prob <= 1.0))) {
        z = dbinom(0, arg_n, arg_prob);
        while (i <= arg_x) : (i += 1) {
            z += dbinom(i, arg_n, arg_prob);
        }
    }
    return z;
}

pub export fn qbinom(arg_p: f64, arg_n: u32, arg_prob: f64) f64 {
    var i: u32 = 1;
    var z: f64 = undefined;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and ((arg_prob >= 0.0) and (arg_prob <= 1.0))) {
        z = dbinom(0, arg_n, arg_prob);
        while (i <= arg_n) : (i += 1) {
            z += dbinom(i, arg_n, arg_prob);
            if (z > arg_p) break;
        }
        z = @as(f64, @floatFromInt(i));
    }
    return z;
}

pub export fn rbinom(arg_n: u32, arg_prob: f64) f64 {
    var i: u32 = 0;
    var z: f64 = undefined;
    var u: u32 = undefined;
    const m: u32 = ~@as(u32, 1 << 31);
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = 0.0;
        while (i < arg_n) : (i += 1) {
            u = rnd.random().int(u32) & m;
            z += bool2float(std.math.ldexp(@as(f64, @floatFromInt(u)), -31) < arg_prob);
        }
    }
    return z;
}

// zig test binomial.zig -lm # Run this line on the terminal to test the following function
test "\nBasic functions for the Binomail distribution" {
    std.debug.print("choose(5, 3) = {d:.0}\n", .{binom(5, 3)});
    std.debug.print("dbinom(1, 5, 0.25) = {d:.8}\n", .{dbinom(1, 5, 0.25)});
    std.debug.print("pbinom(1, 5, 0.75) = {d:.8}\n", .{pbinom(1, 5, 0.75)});
    std.debug.print("qbinom(0.95, 5, 0.777) = {d:.0}\n", .{qbinom(0.95, 5, 0.888)});
    std.debug.print("rbinom(5, 0.234):\n", .{});
    for (0..22) |_| {
        std.debug.print("{d:.0}, ", .{rbinom(5, 0.234)});
    }
    std.debug.print("{d:.0}\n", .{rbinom(5, 0.234)});
}
