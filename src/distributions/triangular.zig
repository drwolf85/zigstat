const std = @import("std");
var rnd = std.Random.DefaultPrng.init(888);

inline fn bool2float(comptime T: type, arg_x: bool) T {
    return @as(T, @floatFromInt(@intFromBool(arg_x)));
}

pub fn dtriang(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var s = arg_s;
    var z: T = undefined;
    if (arg_s >= 0.0) {
        z = arg_x - arg_m;
        s = 1.0 / arg_s;
    }
    z *= s;
    z = @as(T, @floatFromInt(@intFromBool(z >= -1.0) * @intFromBool(z <= 1.0))) * (1.0 - @abs(z));
    return z * s;
}

pub fn ptriang(comptime T: type, arg_x: T, arg_m: T, arg_s: T) T {
    var x = arg_x;
    var z: T = undefined;
    x -= arg_m;
    if (arg_s >= 0.0) {
        x /= arg_s;
        z = 1.0 - @abs(x);
    }
    z *= bool2float(T, z > 0.0) * z * 0.5;
    z += bool2float(T, x >= 0.0) * (1.0 - (2.0 * z));
    return z;
}

pub fn qtriang(comptime T: type, arg_p: T, arg_m: T, arg_s: T) T {
    var z: T = undefined;
    const v: T = bool2float(T, arg_p >= 0.5) * (1.0 - (2.0 * arg_p));
    const sgn: T = 2.0 * bool2float(T, arg_p > 0.5) - 1.0;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and (arg_s >= 0.0)) {
        z = arg_p + v;
    }
    z = sgn * (1.0 - @sqrt(2.0 * z));
    return (arg_s * z) + arg_m;
}

pub fn rtriang(comptime T: type, arg_mu: T, arg_sd: T) T {
    const u: u32 = rnd.random().int(u32);
    var m: u32 = (1 << 16) - 1;
    const v: u32 = (((u >> 16) & m) | ((u & m) << 16));
    m = ~@as(u32, 1 << 31);
    const a: T = @as(T, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(u & m)), -31)));
    const b: T = @as(T, @floatCast(std.math.ldexp(@as(f64, @floatFromInt(v & m)), -31)));
    return ((a - b) * arg_sd) + arg_mu;
}

//  zig test triangular.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Triangular distribution" {
    const mft: type = f64;
    std.debug.print("\ndtriang(0.64, 0.0, 1.0) = {d:.1}\n", .{dtriang(mft, 0.64, 0.0, 1.0)});
    std.debug.print("ptriang(0.64, 0.0, 1.0) = {d:.4}\n", .{ptriang(mft, 0.64, 0.0, 1.0)});
    std.debug.print("qtriang(0.9352, 0.0, 1.0) = {d:.2}\n", .{qtriang(mft, 0.9352, 0.0, 1.0)});
    std.debug.print("rtriang(0, 1):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.8}, ", .{rtriang(mft, 0.0, 1.0)});
    }
    std.debug.print("{d:.8}\n", .{rtriang(mft, 0.0, 1.0)});
}
