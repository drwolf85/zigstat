const std = @import("std");
const math = std.math;
const testing = std.testing;

pub fn factorial(comptime T: type, x: T) T {
    var r: f64 = @as(f64, @floatCast(x)) + 1.0;
    r = math.lgamma(f64, r);
    const res: T = @as(T, @floatCast(r));
    return @exp(res);
}

pub fn stirling(comptime T: type, x: T) T {
    var res = x * @log(x) - x;
    res += 0.5 * @log(math.pi * 2.0 * x);
    return @exp(res);
}

pub fn gosper(comptime T: type, x: T) T {
    var res = x * @log(x) - x;
    res += 0.5 * @log(math.pi * (2.0 * x + 1.0 / 3.0));
    return @exp(res);
}

test "Factorial-related functions" {
    const mft: type = f64;
    std.debug.print("Factorial(0.5) = {}\n", .{factorial(mft, 0.5)});
    std.debug.print("Stirling approx = {}\n", .{stirling(mft, 0.5)});
    std.debug.print("Gosper approx = {}\n", .{gosper(mft, 0.5)});
}
