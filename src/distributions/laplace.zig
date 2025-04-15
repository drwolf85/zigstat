const std = @import("std");
var rnd = std.Random.DefaultPrng.init(888);

pub fn dlaplace(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var s = arg_s;
    var z: T = arg_m - arg_x;
    s = 1.0 / s;
    z = @exp(-2.0 * @abs(z * s)) * s;
    return z;
}

pub fn plaplace(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var z: T = arg_m - arg_x;
    z /= arg_s;
    z = @exp(-2.0 * @abs(z));
    if (arg_x < arg_m) {
        z *= 0.5;
    } else {
        z *= -1.0;
        z += 1.0;
    }
    return z;
}

pub fn qlaplace(comptime T: type, arg_p: T, arg_m: T, arg_s: T) T {
    var z: T = undefined;
    var sgn: T = 1.0;
    if (arg_p >= 0.5) sgn = -1.0;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and (arg_s >= 0.0)) {
        z = 2.0 * @abs(arg_p - 0.5);
    }
    const nz: f64 = -@as(f64, @floatCast(z));
    return ((arg_s * sgn) * @as(T, @floatCast(std.math.log1p(nz)))) + arg_m;
}

pub fn rlaplace(comptime T: type, arg_mu: T, arg_sd: T) T {
    const u: u32 = rnd.random().int(u32);
    const m: u32 = ~@as(u32, 1 << 31);
    const z: T = @as(T, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(u & m)), -31)));
    return qlaplace(T, z, arg_mu, arg_sd);
}

//  zig test laplace.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Laplace distribution" {
    const mft: type = f64;
    std.debug.print("\ndlaplace(-1.64, 0, 1) = {}\n", .{dlaplace(mft, -1.64, 0.0, 1.0)});
    std.debug.print("plaplace(-1.64, 0, 1) = {}\n", .{plaplace(mft, -1.64, 0.0, 1.0)});
    std.debug.print("qlaplace(0.95, 0, 1) = {}\n", .{qlaplace(mft, 0.95, 0.0, 1.0)});
    std.debug.print("rlaplace(0, 1):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.6}, ", .{rlaplace(mft, 0.0, 1.0)});
    }
    std.debug.print("{d:.5}\n", .{rlaplace(mft, 0.0, 1.0)});
}
