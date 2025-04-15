const std = @import("std");
const testing = std.testing;

pub fn vrnc(comptime T: type, n: usize, x: [*]const T) T {
    var e1: T = 0.0;
    var e2: T = 0.0;
    const nf: T = @as(T, @floatFromInt(n));
    for (x, 0..n) |_, i| {
        e1 += x[i];
        e2 += x[i] * x[i];
    }
    e2 -= e1 * e1 / nf;
    return e2 / (nf - 1.0);
}

test "basic variance functionality" {
    const mft: type = f64;
    const a = [_]mft{ 0.1, -0.2, -0.5, 1.2, 1.5 };
    std.debug.print("\nVariance {}\n", .{vrnc(mft, a.len, &a)});
}
