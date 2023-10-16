const std = @import("std");
const testing = std.testing;

pub export fn vrnc(n:usize, x: [*]const f64) f64 {
  @setFloatMode(.Optimized);
  var e1: f64 = 0.0;
  var e2: f64 = 0.0;
  var nf: f64 = @as(f64, @floatFromInt(n));
  for (x, 0..n) |_, i| {
    e1 += x[i];
    e2 += x[i] * x[i];
  }
  e2 -= e1 * e1 / nf;
  return e2 / (nf - 1.0);
}

test "basic variance functionality" {
  const a = [_] f64 {0.1, -0.2, -0.5, 1.2, 1.5};
  std.debug.print("\nVariance {}\n", .{vrnc(a.len, &a)});
}

