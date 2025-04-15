const std = @import("std");
var rnd = std.Random.DefaultPrng.init(888);

pub fn dlogis(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var s = arg_s;
    var z: T = undefined;
    if (s >= 0.0) {
        z = arg_x - arg_m;
        s = 1.0 / s;
        z *= s;
    }
    z = 1.0 / (1.0 + @exp(z));
    return (z * (1.0 - z)) * s;
}

pub fn plogis(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var z: T = undefined;
    if (arg_s >= 0.0) {
        z = arg_x - arg_m;
        z /= arg_s;
    }
    z = 1.0 + @exp(-z);
    return 1.0 / z;
}

pub fn qlogis(comptime T: type, arg_p: T, arg_m: T, arg_s: T) T {
    var z: T = undefined;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and (arg_s >= 0.0)) {
        z = @log(arg_p / (1.0 - arg_p));
    }
    return (arg_s * z) + arg_m;
}

pub fn rlogis(comptime T: type, arg_mu: T, arg_sd: T) T {
    var u: u32 = rnd.random().int(u32);
    const m: u32 = ~@as(u32, 1 << 31);
    var z: T = undefined;
    u &= m;
    z = @as(T, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(u)), -31)));
    return qlogis(T, z, arg_mu, arg_sd);
}

// zig test logistic.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Logistic distribution" {
    const mft: type = f64;
    std.debug.print("\ndlogis(-1.64, 0.0, 1.0) = {}\n", .{dlogis(mft, -1.64, 0.0, 1.0)});
    std.debug.print("plogis(-1.64, 0.0, 1.0) = {}\n", .{plogis(mft, -1.64, 0.0, 1.0)});
    std.debug.print("qlogis(0.95, 0.0, 1.0) = {}\n", .{qlogis(mft, 0.95, 0.0, 1.0)});
    std.debug.print("rlogis(0, 1): ", .{});
    for (0..7) |_| {
        std.debug.print("{d:.5}, ", .{rlogis(mft, 0.0, 1.0)});
    }
    std.debug.print("{d:.5}\n", .{rlogis(mft, 0.0, 1.0)});
}
