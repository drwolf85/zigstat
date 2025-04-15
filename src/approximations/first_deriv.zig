const std = @import("std");
const print = std.debug.print;

pub fn deriv1(comptime T: type, x0: T, h: T, htype: T, f: ?*const fn (f64) callconv(.C) f64) T {
    var xl: T = x0;
    var xr: T = x0;
    xl += h * (1.0 - htype);
    xr -= h * htype;
    const d64: f64 = f.?(@as(f64, @floatCast(xl))) - f.?(@as(f64, @floatCast(xr)));
    return @as(T, @floatCast(d64)) / h;
}

pub extern fn exp(__x: f64) f64;

test "Testing first derivatives" {
    const mft: type = f64;
    print("\nTrue first derivative of exp(x) in x = 1: {}", .{@exp(@as(mft, 1.0))});
    print("\nFirst derivative of exp(x) in x = 1: {}\n", .{deriv1(mft, 1.0, 0.0000005, 0.5, &exp)});
}
