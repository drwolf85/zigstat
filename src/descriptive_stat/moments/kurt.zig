const std = @import("std");

pub fn kurt(comptime T: type, n: usize, x: [*]const T) T {
    var e1: T = 0.0;
    var e2: T = 0.0;
    var e3: T = 0.0;
    var e4: T = 0.0;
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
        v *= x[i];
        e4 += v;
    }
    e2 -= e1 * e1 * in;
    e1 *= in;
    e3 *= in;
    e4 *= in;
    v = 6.0 * e1 * e2 * in - 4.0 * e3;
    e4 += (v + 3.0 * e1 * e1 * e1) * e1;
    e2 /= (nf - 1.0);
    return e4 / e2;
}

test "basic kurtosis functionality" {
    const mft: type = f64;
    const a = [_]mft{ 0.1, -0.2, -0.5, 1.2, 1.5 };
    std.debug.print("\nKurtosis {}\n", .{kurt(mft, a.len, &a)});
}
