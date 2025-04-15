const std = @import("std");
const testing = std.testing;

pub fn mean(comptime T: type, n: usize, x: [*]const T) T {
    var res: T = 0.0;
    for (0..n) |i| {
        res += x[i];
    }
    return res / @as(T, @floatFromInt(n));
}

test "basic mean functionality" {
    const mft: type = f64;
    const a = [_]mft{ 0.1, -0.2, -0.5, 1.2, 1.5 };
    std.debug.print("\nMean {}\n", .{mean(mft, a.len, &a)});
}
