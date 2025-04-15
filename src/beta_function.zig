const std = @import("std");
const math = std.math;
const testing = std.testing;


pub export fn lbeta(a: f64, b: f64) f64 {
    var res : f64 = math.lgamma(f64, a);
    res += math.lgamma(f64, b);
    res -= math.lgamma(f64, a + b);
    return res;
}

pub export fn beta(a: f64, b: f64) f64 {
    const res = lbeta(a, b);
    return @exp(res);
}

test "Beta-related functions" {
    std.debug.print("lbeta(5, 2) = {}\n", .{lbeta(5.0,2.0)});
    std.debug.print("beta(5, 2) = {}\n", .{beta(5.0,2.0)});
}
