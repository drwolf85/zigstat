const std = @import("std");

pub export fn kurt(n:usize, x: [*]const f64) f64 {
  @setFloatMode(.Optimized);
  var e1: f64 = 0.0;
  var e2: f64 = 0.0;
  var e3: f64 = 0.0;
  var e4: f64 = 0.0;
  var v: f64 = undefined;
  const nf: f64 = @as(f64, @floatFromInt(n));
  const in: f64 = 1.0 / nf;
  for (0..n) |i| {
    v  = x[i]; e1 += v;
    v *= x[i]; e2 += v;
    v *= x[i]; e3 += v;
    v *= x[i]; e4 += v;
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
  const a = [_] f64 {0.1, -0.2, -0.5, 1.2, 1.5};
  std.debug.print("\nKurtosis {}\n", .{kurt(a.len, &a)});
}

