const std = @import("std");
const testing = std.testing;

fn bin_search(comptime T: type, v: T, a: []T, len: usize) usize {
    var l: usize = 0;
    var m: usize = len >> 1;
    var u: usize = len - 1;
    var s: usize = m;
    while (s > 0) {
        if (a[m] < v) l = m;
	if (a[m] >= v) u = m;
	s >>= 1;
	m = l + s;
    }
    return l;
}

pub fn smooth_ecdf_adimari(comptime T: type, v: T, a: [*]T, len: usize) T {
    var res: T = undefined;
    var pos: usize = undefined;
    const x = a[0..len];
    std.mem.sort(T, x, {}, std.sort.asc(T));
    if (len == 0) return res;
    if (v < x[0]) return 0.0;
    if (v >= x[len - 1]) return 1.0;
    const invn: T = 1.0 / @as(T, @floatFromInt(len));
    pos = bin_search(T, v, x, len);
    res = (@as(T, @floatFromInt(pos + 1)) - 0.5) * invn;
    if (v == x[pos]) return res;
    const lambda: T = (v - x[pos]) / (x[pos + 1] - x[pos]);
    res += lambda * invn;
    return res;
}

test "Binary search" {
     const mft: type = f64;
     var a = [_]mft{ 0.1, 0.2, 0.3, 0.5, 0.6, 0.7, 0.8};
     std.debug.print("Position: {}\n", .{bin_search(mft, 0.144, &a, a.len)});
}

test "Smooth empirical cumulative distribution function" {
    const mft: type = f64;
    var a = [_]mft{ 0.1, -0.1, -0.2, 1.5, 1.7 };

    std.debug.print("ECDF: {}\n", .{smooth_ecdf_adimari(mft, -0.1999, &a, a.len)});
    std.debug.print("ECDF: {}\n", .{smooth_ecdf_adimari(mft, 0.0001, &a, a.len)});
    std.debug.print("ECDF: {}\n", .{smooth_ecdf_adimari(mft, 0.3, &a, a.len)});
    std.debug.print("ECDF: {}\n", .{smooth_ecdf_adimari(mft, 0.5, &a, a.len)});
    std.debug.print("ECDF: {}\n", .{smooth_ecdf_adimari(mft, 1.6999999999998, &a, a.len)});
    std.debug.print("ECDF: {}\n", .{smooth_ecdf_adimari(mft, 1.7, &a, a.len)});
}

