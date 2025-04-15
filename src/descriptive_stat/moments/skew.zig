const std = @import("std");

pub fn skew(comptime T: type, n: usize, x: [*]const T) T {
    var e1: T = 0.0;
    var e2: T = 0.0;
    var e3: T = 0.0;
    var v: T = undefined;
    const nf: T = @as(T, @floatFromInt(n));
    const in: T = 1.0 / nf;
    for (0..n) |i| {
        v = x[i];
        e1 += v;
        v *= x[i];
        e2 += v;
        v *= x[i];
        e3 += v;
    }
    e2 -= e1 * e1 * in;
    e1 *= in;
    e3 *= in;
    e3 -= e1 * (3.0 * e2 * in + e1 * e1);
    e2 /= (nf - 1.0);
    return e3 / e2;
}

test "basic skewness functionality" {
    const mft: type = f64;
    const a = [_]mft{ 0.1, -0.2, -0.5, 1.2, 1.5 };
    std.debug.print("\nSkewness {}\n", .{skew(mft, a.len, &a)}); // 0.1761853
}
