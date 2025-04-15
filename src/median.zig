const std = @import("std");
const testing = std.testing;

pub export fn median(a: [*]f64, len: usize) f64 {
        var res : f64 = undefined;
        const x = a[0..len];
        const pos : usize = len >> 1;
        std.mem.sort(f64, x, {}, std.sort.asc(f64));
        res = x[pos];
        if (len > 1 and (len & 1) == 0) {
                res += x[pos-1];
                res *= 0.5;
        }
        return res;
}

test "Median function" {
        var a = [_]f64 {0.1, -0.1, -0.2, 1.5, 1.7};
        var b = [_]f64 {-0.1, -0.2, 1.5, 1.7};
        std.debug.print("Median: {}\n", .{median(&a, a.len)});
        std.debug.print("Median: {}\n", .{median(&b, b.len)});
}
