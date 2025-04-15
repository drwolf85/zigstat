const std = @import("std");
const math = std.math;
const testing = std.testing;

pub export fn factorial(x: f64) f64 {
	var res : f64 = x + 1.0;
	res = math.lgamma(f64, res);
	return @exp(res);
}

pub export fn stirling(x: f64) f64 {
	var res = x * @log(x) - x;
	res += 0.5 * @log(math.pi * 2.0 * x);
	return @exp(res);
}

pub export fn gosper(x: f64) f64 {
	var res = x * @log(x) - x;
	res += 0.5 * @log(math.pi * (2.0 * x + 1.0 / 3.0));
	return @exp(res);
}

test "Factorial-related functions" {
	std.debug.print("Factorial(0.5) = {}\n", .{factorial(0.5)});
	std.debug.print("Stirling approx = {}\n", .{stirling(0.5)});
	std.debug.print("Gosper approx = {}\n", .{gosper(0.5)});
}
