const std = @import("std");
const math = std.math;
const testing = std.testing;

pub fn lbeta(comptime T: type, a: T, b: T) T {
    var res: T = @as(T, @floatCast(math.lgamma(f64, @as(f64, @floatCast(a)))));
    res += @as(T, @floatCast(math.lgamma(f64, @as(f64, @floatCast(b)))));
    res -= @as(T, @floatCast(math.lgamma(f64, @as(f64, @floatCast(a + b)))));
    return res;
}

pub fn beta(comptime T: type, a: T, b: T) T {
    const res = lbeta(T, a, b);
    return @exp(res);
}

test "Beta-related functions" {
    const mft: type = f64;
    std.debug.print("lbeta(5, 2) = {}\n", .{lbeta(mft, 5.0, 2.0)});
    std.debug.print("beta(5, 2) = {}\n", .{beta(mft, 5.0, 2.0)});
}
