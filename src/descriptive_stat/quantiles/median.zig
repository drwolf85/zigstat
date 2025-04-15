const std = @import("std");
const testing = std.testing;

pub fn median(comptime T: type, a: [*]T, len: usize) T {
    var res: T = undefined;
    const x = a[0..len];
    const pos: usize = len >> 1;
    std.mem.sort(T, x, {}, std.sort.asc(T));
    res = x[pos];
    if (len > 1 and (len & 1) == 0) {
        res += x[pos - 1];
        res *= 0.5;
    }
    return res;
}

test "Median function" {
    const mft: type = f64;
    var a = [_]mft{ 0.1, -0.1, -0.2, 1.5, 1.7 };
    var b = [_]mft{ -0.1, -0.2, 1.5, 1.7 };
    std.debug.print("Median: {}\n", .{median(mft, &a, a.len)});
    std.debug.print("Median: {}\n", .{median(mft, &b, b.len)});
}
