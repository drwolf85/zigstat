const std = @import("std");
const print = std.debug.print;

pub export fn deriv1(x0: f64, h: f64, htype: f64, f: ?*const fn (f64) callconv(.C) f64) f64 {
    var res: f64 = 0.0;
    var xl: f64 = x0;
    var xr: f64 = x0;    
    xl += h * (1.0 - htype);
    xr -= h * htype;
    res = f.?(xl) - f.?(xr);
    return res / h;
}

pub extern fn exp(__x: f64) f64;

test "Testing first derivatives" {
    print("\nFirst derivative of exp(x) in x = 1: {}\n",
              .{deriv1(1.0, 0.000000000001, 0.5, &exp)});
}

