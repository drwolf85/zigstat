const std = @import("std");
var rnd = std.Random.DefaultPrng.init(888);

pub export fn dlaplace(arg_x: f64, arg_m: f64, arg_s: f64) f64 {
    var s = arg_s;
    var z: f64 = arg_m - arg_x;
    s = 1.0 / s;
    z = @exp(-2.0 * @abs(z * s)) * s;
    return z;
}

pub export fn plaplace(arg_x: f64, arg_m: f64, arg_s: f64) f64 {
    var z: f64 = arg_m - arg_x;
    z /= arg_s;
    z = @exp(-2.0 * @abs(z));
    if (arg_x < arg_m) {
       z *= 0.5;
    } 
    else {
        z *= -1.0;
        z += 1.0;
    }
    return z;
}

pub export fn qlaplace(arg_p: f64, arg_m: f64, arg_s: f64) f64 {
    var z: f64 = undefined;
    var sgn: f64 = 1.0;
    if (arg_p >= 0.5) sgn = -1.0;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and (arg_s >= 0.0)) {
        z = 2.0 * @abs(arg_p - 0.5);
    }
    return ((arg_s * sgn) * std.math.log1p(-z)) + arg_m;
}

pub export fn rlaplace(arg_mu: f64, arg_sd: f64) f64 {
    const u: u32 = rnd.random().int(u32);
    const m: u32 = ~@as(u32, 1 << 31);
    const z: f64 = std.math.ldexp(@as(f64, @floatFromInt(u & m)), -31);
    return qlaplace(z, arg_mu, arg_sd);
}

//  zig test laplace.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Laplace distribution" {
    std.debug.print("\ndlaplace(-1.64, 0, 1) = {}\n", .{dlaplace(-1.64, 0.0, 1.0)});
    std.debug.print("plaplace(-1.64, 0, 1) = {}\n", .{plaplace(-1.64, 0.0, 1.0)});
    std.debug.print("qlaplace(0.95, 0, 1) = {}\n", .{qlaplace(0.95, 0.0, 1.0)});
    std.debug.print("rlaplace(0, 1):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.6}, ", .{rlaplace(0.0, 1.0)});
    }
    std.debug.print("{d:.5}\n", .{rlaplace(0.0, 1.0)});
}

