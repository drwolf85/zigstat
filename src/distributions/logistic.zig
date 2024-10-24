const std = @import("std");
var rnd = std.rand.DefaultPrng.init(888);

pub export fn dlogis(arg_x: f64, arg_m: f64, arg_s: f64) f64 {
    var s = arg_s;
    var z: f64 = undefined;
    if (s >= 0.0) {
        z = arg_x - arg_m;
        s = 1.0 / s;
        z *= s;
    }
    z = 1.0 / (1.0 + @exp(z));
    return (z * (1.0 - z)) * s;
}

pub export fn plogis(arg_x: f64, arg_m: f64, arg_s: f64) f64 {
    var z: f64 = undefined;
    if (arg_s >= 0.0) {
        z = arg_x - arg_m;
        z /= arg_s;
    }
    z = 1.0 + @exp(-z);
    return 1.0 / z;
}

pub export fn qlogis(arg_p: f64, arg_m: f64, arg_s: f64) f64 {
    var z: f64 = undefined;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and (arg_s >= 0.0)) {
        z = @log(arg_p / (1.0 - arg_p));
    }
    return (arg_s * z) + arg_m;
}

pub export fn rlogis(arg_mu: f64, arg_sd: f64) f64 {
    var u: u32 = rnd.random().int(u32);
    var m: u32 = ~@as(u32, 1 << 31);
    var z: f64 = undefined;
    u &= m;
    z = std.math.ldexp(@as(f64, @floatFromInt(u)), -31);
    return qlogis(z, arg_mu, arg_sd);
}

// zig test logistic.zig -lm # Run this line on the terminal to test the following function
test "\nBasic functions for the Logistic distribution" {
    std.debug.print("\ndlogis(-1.64, 0.0, 1.0) = {}\n", .{dlogis(-1.64, 0.0, 1.0)});
    std.debug.print("plogis(-1.64, 0.0, 1.0) = {}\n", .{plogis(-1.64, 0.0, 1.0)});
    std.debug.print("qlogis(0.95, 0.0, 1.0) = {}\n", .{qlogis(0.95, 0.0, 1.0)});
    std.debug.print("rlogis(0, 1): ", .{});
    for (0..7) |_| {
        std.debug.print("{d:.5}, ", .{rlogis(0.0, 1.0)});
    }
    std.debug.print("{d:.5}\n", .{rlogis(0.0, 1.0)});
}

