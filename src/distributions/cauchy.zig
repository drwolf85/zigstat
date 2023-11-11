const std = @import("std");
var rnd = std.rand.DefaultPrng.init(888);

pub export fn dcauchy(arg_x: f64, arg_m: f64, arg_s: f64) f64 {
    var x = arg_x;
    var s = arg_s;
    var z: f64 = undefined;
    if (s >= 0.0) {
        x -= arg_m;
        s = 1.0 / s;
        z = x * s;
    }
    z = 1.0 + (z * z);
    return (0.3183098861837907 * s) / z;
}

pub export fn pcauchy(arg_x: f64, arg_m: f64, arg_s: f64) f64 {
    var x = arg_x;
    var z: f64 = undefined;
    if (arg_s >= 0.0) {
        x -= arg_m;
        z = x / arg_s;
    }
    return 0.5 + (std.math.atan(z) * 0.3183098861837907);
}

pub export fn qcauchy(arg_p: f64, arg_m: f64, arg_s: f64) f64 {
    var z: f64 = undefined;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and (arg_s >= 0.0)) {
        z = std.math.pi * (arg_p - 0.5);
    }
    z = @tan(z);
    return (arg_s * z) + arg_m;
}

pub export fn rcauchy(arg_mu: f64, arg_sd: f64) f64 {
    var u: u32 = rnd.random().int(u32);
    var m: u32 = ~@as(u32, 1 << 31);
    return qcauchy(std.math.ldexp(@as(f64, @floatFromInt(u & m)), -31), arg_mu, arg_sd);
}

// zig test cauchy.zig -lm # Run this line on the terminal to test the following function
test "\nBasic functions for the Cauchy distribution" {
    std.debug.print("\ndcauchy(-1.64, 0.0, 1.0) = {}\n", .{dcauchy(-1.64, 0.0, 1.0)});
    std.debug.print("pcauchy(-1.64, 0.0, 1.0) = {}\n", .{pcauchy(-1.64, 0.0, 1.0)});
    std.debug.print("qcauchy(0.95, 0.0, 1.0) = {}\n", .{qcauchy(0.95, 0.0, 1.0)});
    std.debug.print("rcauchy(0, 1): ", .{});
    for (0..7) |_| {
        std.debug.print("{d:.4}, ", .{rcauchy(0.0, 1.0)});
    }
    std.debug.print("{d:.4}\n", .{rcauchy(0.0, 1.0)});
}

