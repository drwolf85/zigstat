const std = @import("std");
const print = std.debug.print;

pub fn absolute_error(comptime T: type, approx: T, truth: T) T {
    return approx - truth;
}

pub fn relative_error(comptime T: type, approx: T, truth: T) T {
    const err: T = approx - truth;
    return err / truth;
}

pub fn approx_value(comptime T: type, truth: T, rel_err: T) T {
    return truth * (1.0 + rel_err);
}

test "\nBasic error functions" {
    const mft: type = f64;
    print("\nAbs. err. (3 vs 2): {}\n", .{absolute_error(mft, 3.0, 2.0)});
    print("Rel. err. (3 vs 2): {}\n", .{relative_error(mft, 3.0, 2.0)});
    print("Approx. val. (2.0, 1%): {}\n", .{approx_value(mft, 2.0, 0.01)});
}
