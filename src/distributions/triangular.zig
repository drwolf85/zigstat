const std = @import("std");
var rnd = std.Random.DefaultPrng.init(888);

inline fn bool2float(arg_x: bool) f64 {
    return @as(f64, @floatFromInt(@intFromBool(arg_x)));
}

pub export fn dtriang(arg_x: f64, arg_m: f64, arg_s: f64) f64 {
    var s = arg_s;
    var z: f64 = undefined;
    if (arg_s >= 0.0) {
        z = arg_x - arg_m;
        s = 1.0 / arg_s;
    }
    z *= s;
    z = @as(f64, @floatFromInt(@intFromBool(z >= -1.0) * @intFromBool(z <= 1.0))) * (1.0 - @abs(z));
    return z * s;
}

pub export fn ptriang(arg_x: f64, arg_m: f64, arg_s: f64) f64 {
    var x = arg_x;
    var z: f64 = undefined;
    x -= arg_m;
    if (arg_s >= 0.0) {
        x /= arg_s;
        z = 1.0 - @abs(x);
    }
    z *= bool2float(z > 0.0) * z * 0.5;
    z += bool2float(x >= 0.0) * (1.0 - (2.0 * z));
    return z;
}

pub export fn qtriang(arg_p: f64, arg_m: f64, arg_s: f64) f64 {
    var z: f64 = undefined;
    const v: f64 = bool2float(arg_p >= 0.5) * (1.0 - (2.0 * arg_p));
    const sgn: f64 = 2.0 * bool2float(arg_p > 0.5) - 1.0;
    if (((arg_p >= 0.0) and (arg_p <= 1.0)) and (arg_s >= 0.0)) {
        z = arg_p + v;
    }
    z = sgn * (1.0 - @sqrt(2.0 * z));
    return (arg_s * z) + arg_m;
}

pub export fn rtriang(arg_mu: f64, arg_sd: f64) f64 {
    const u: u32 = rnd.random().int(u32);
    var m: u32 = (1 << 16) - 1;
    const v: u32 = (((u >> 16) & m) | ((u & m) << 16));
    m = ~@as(u32, 1 << 31);
    const a: f64 = std.math.ldexp(@as(f64, @floatFromInt(u & m)), -31);
    const b: f64 = std.math.ldexp(@as(f64, @floatFromInt(v & m)), -31);
    return ((a - b) * arg_sd) + arg_mu;
}

//  zig test triangular.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Triangular distribution" {
    std.debug.print("\ndtriang(0.64, 0.0, 1.0) = {d:.1}\n", .{dtriang(0.64, 0.0, 1.0)});
    std.debug.print("ptriang(0.64, 0.0, 1.0) = {d:.4}\n", .{ptriang(0.64, 0.0, 1.0)});
    std.debug.print("qtriang(0.9352, 0.0, 1.0) = {d:.2}\n", .{qtriang(0.9352, 0.0, 1.0)});
    std.debug.print("rtriang(0, 1):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.8}, ", .{rtriang(0.0, 1.0)});
    }
    std.debug.print("{d:.8}\n", .{rtriang(0.0, 1.0)});
}
