const std = @import("std");

pub export fn skew(n:usize, x: [*]const f64) f64 {
  @setFloatMode(.Optimized);
  var e1: f64 = 0.0;
  var e2: f64 = 0.0;
  var e3: f64 = 0.0;
  var v: f64 = undefined;
  const nf: f64 = @as(f64, @floatFromInt(n));
  const in: f64 = 1.0 / nf;
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
  const a = [_] f64 {0.1, -0.2, -0.5, 1.2, 1.5};
  std.debug.print("\nSkewness {}\n", .{skew(a.len, &a)}); // 0.1761853
}


