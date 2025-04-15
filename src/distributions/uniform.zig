const std = @import("std");
var rnd = std.Random.DefaultPrng.init(888);

pub fn dunif(comptime T: type, arg_x: T, arg_a: T, arg_b: T) T {
    var z: T = undefined;
    if (arg_b > arg_a) {
        z = 0.0;
        if (arg_x >= arg_a and arg_x <= arg_b) {
            z = 1.0 / (arg_b - arg_a);
        }
    }
    return z;
}

pub fn punif(comptime T: type, arg_x: T, arg_a: T, arg_b: T) T {
    var z: T = undefined;
    if (arg_b > arg_a) {
        if (arg_x > arg_a and arg_x < arg_b) {
            z = (arg_x - arg_a) / (arg_b - arg_a);
        } else if (arg_x >= arg_b) {
            z = 1.0;
        } else {
            z = 0.0;
        }
    }

    return z;
}

pub fn qunif(comptime T: type, arg_p: T, arg_a: T, arg_b: T) T {
    var z: T = undefined;
    if (((arg_b > arg_a) and (arg_p >= 0.0)) and (arg_p <= 1.0)) {
        z = (arg_p * (arg_b - arg_a)) + arg_a;
    }
    return z;
}

pub fn runif(comptime T: type, arg_a: T, arg_b: T) T {
    var z: T = undefined;
    const u: u32 = rnd.random().int(u32);
    const m: u32 = ~@as(u32, 1 << 31);
    if (arg_b > arg_a) {
        z = @as(T, @floatCast(std.math.ldexp(@as(T, @floatFromInt(u & m)), -31)));
        z *= arg_b - arg_a;
        z += arg_a;
    }
    return z;
}

//  zig test uniform.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Uniform distribution" {
    const mft: type = f64;
    std.debug.print("\ndunif(1.64, 0.0, 2.0) = {}\n", .{dunif(mft, 1.64, 0.0, 2.0)});
    std.debug.print("punif(1.64, 0.0, 2.0) = {}\n", .{punif(mft, 1.64, 0.0, 2.0)});
    std.debug.print("qunif(0.95, 0.0, 1.0) = {}\n", .{qunif(mft, 0.95, 0.0, 1.0)});
    std.debug.print("runif(-1, 1):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.8}, ", .{runif(mft, -1.0, 1.0)});
    }
    std.debug.print("{d:.8}\n", .{runif(mft, -1.0, 1.0)});
}
