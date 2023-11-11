const std = @import("std");
var rnd = std.rand.DefaultPrng.init(888);

pub export fn dunif(arg_x: f64, arg_a: f64, arg_b: f64) f64 {
    var z: f64 = undefined;
    if (arg_b > arg_a) {
        z = 0.0;
        if (arg_x >= arg_a and arg_x <= arg_b) {
            z = 1.0 / (arg_b - arg_a);
        }
    }
    return z;
}

pub export fn punif(arg_x: f64, arg_a: f64, arg_b: f64) f64 {
    var z: f64 = undefined;
    if (arg_b > arg_a) {
        if (arg_x > arg_a and arg_x < arg_b) {
            z = (arg_x - arg_a) / (arg_b - arg_a);
        }
        else if (arg_x >= arg_b) {
            z = 1.0;
        }
        else {
            z = 0.0;
        }
    }

    return z;
}

pub export fn qunif(arg_p: f64, arg_a: f64, arg_b: f64) f64 {
    var z: f64 = undefined;
    if (((arg_b > arg_a) and (arg_p >= 0.0)) and (arg_p <= 1.0)) {
        z = (arg_p * (arg_b - arg_a)) + arg_a;
    }
    return z;
}

pub export fn runif(arg_a: f64, arg_b: f64) f64 {
    var z: f64 = undefined;
    var u: u32 = rnd.random().int(u32);
    var m: u32 = ~@as(u32, 1 << 31);
    if (arg_b > arg_a) {
        z = std.math.ldexp(@as(f64, @floatFromInt(u & m)), -31);
        z *= arg_b - arg_a;
        z += arg_a;
    }
    return z;
}

//  zig test uniform.zig # Run this line on the terminal to test the following function
test "\nBasic functions for the Uniform distribution" {
    std.debug.print("\ndunif(1.64, 0.0, 2.0) = {}\n", .{dunif(1.64, 0.0, 2.0)});
    std.debug.print("punif(1.64, 0.0, 2.0) = {}\n", .{punif(1.64, 0.0, 2.0)});
    std.debug.print("qunif(0.95, 0.0, 1.0) = {}\n", .{qunif(0.95, 0.0, 1.0)});
    std.debug.print("runif(-1, 1):\n", .{});
    for (0..7) |_| {
        std.debug.print("{d:.8}, ", .{runif(-1.0, 1.0)});
    }
    std.debug.print("{d:.8}\n", .{runif(-1.0, 1.0)});
}

