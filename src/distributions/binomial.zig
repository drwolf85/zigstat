const std = @import("std");
const math = std.math;
var rnd = std.Random.DefaultPrng.init(888);

inline fn bool2float(comptime T: type, arg_x: bool) T {
    return @as(T, @floatFromInt(@intFromBool(arg_x)));
}

inline fn binom(comptime Tr: type, comptime Ti: type, arg_n: Ti, arg_k: Ti) Tr {
    var res: Tr = @as(Tr, @floatCast(math.lgamma(f64, @floatFromInt(arg_n + 1))));
    res -= @as(Tr, @floatCast(math.lgamma(f64, @floatFromInt(arg_k + 1))));
    res -= @as(Tr, @floatCast(math.lgamma(f64, @floatFromInt(arg_n - arg_k + 1))));
    return @exp(res);
}

pub fn dbinom(comptime Tr: type, comptime Ti: type, arg_x: Ti, arg_n: Ti, arg_prob: Tr) Tr {
    var z: Tr = undefined;
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = binom(Tr, Ti, arg_n, arg_x);
        z *= @as(Tr, @floatCast(std.math.pow(f64, @as(f64, @floatCast(arg_prob)), @as(f64, @floatFromInt(arg_x)))));
        z *= @as(Tr, @floatCast(std.math.pow(f64, @as(f64, @floatCast(1.0 - arg_prob)), @as(f64, @floatFromInt(arg_n - arg_x)))));
    }
    return z;
}

pub fn pbinom(comptime Tr: type, comptime Ti: type, arg_x: Ti, arg_n: Ti, arg_prob: Tr) Tr {
    var i: Ti = 1;
    var z: Tr = undefined;
    if (((arg_x >= 0) and (arg_x <= arg_n)) and ((arg_prob >= 0.0) and (arg_prob <= 1.0))) {
        z = dbinom(Tr, Ti, 0, arg_n, arg_prob);
        while (i <= arg_x) : (i += 1) {
            z += dbinom(Tr, Ti, i, arg_n, arg_prob);
        }
    }
    return z;
}

pub fn qbinom(comptime Tr: type, comptime Ti: type, arg_p: Tr, arg_n: Ti, arg_prob: Tr) Tr {
    var i: Ti = 1;
    var z: Tr = undefined;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and ((arg_prob >= 0.0) and (arg_prob <= 1.0))) {
        z = dbinom(Tr, Ti, 0, arg_n, arg_prob);
        while (i <= arg_n) : (i += 1) {
            z += dbinom(Tr, Ti, i, arg_n, arg_prob);
            if (z > arg_p) break;
        }
        z = @as(Tr, @floatFromInt(i));
    }
    return z;
}

pub fn rbinom(comptime Tr: type, comptime Ti: type, arg_n: Ti, arg_prob: Tr) Tr {
    var i: Ti = 0;
    var z: Tr = undefined;
    var u: u32 = undefined;
    const m: u32 = ~@as(u32, 1 << 31);
    if ((arg_prob >= 0.0) and (arg_prob <= 1.0)) {
        z = 0.0;
        while (i < arg_n) : (i += 1) {
            u = rnd.random().int(u32) & m;
            z += bool2float(Tr, @as(Tr, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(u)), -31))) < arg_prob);
        }
    }
    return z;
}

// zig test binomial.zig -lm # Run this line on the terminal to test the following function
test "\nBasic functions for the Binomail distribution" {
    const mfr: type = f64;
    const mfi: type = u32;
    std.debug.print("choose(5, 3) = {d:.0}\n", .{binom(mfr, mfi, 5, 3)});
    std.debug.print("dbinom(1, 5, 0.25) = {d:.8}\n", .{dbinom(mfr, mfi, 1, 5, 0.25)});
    std.debug.print("pbinom(1, 5, 0.75) = {d:.8}\n", .{pbinom(mfr, mfi, 1, 5, 0.75)});
    std.debug.print("qbinom(0.95, 5, 0.777) = {d:.0}\n", .{qbinom(mfr, mfi, 0.95, 5, 0.888)});
    std.debug.print("rbinom(5, 0.234):\n", .{});
    for (0..22) |_| {
        std.debug.print("{d:.0}, ", .{rbinom(mfr, mfi, 5, 0.234)});
    }
    std.debug.print("{d:.0}\n", .{rbinom(mfr, mfi, 5, 0.234)});
}
