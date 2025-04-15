const std = @import("std");
const testing = std.testing;

pub export fn mean(n:usize, x: [*]const f64) f64 {
  @setFloatMode(.Optimized);
  var res: f64 = 0.0;
  for (0..n) |i| {
    res += x[i];
  }
  return res / @as(f64, @floatFromInt(len));
}

test "basic mean functionality" {
  const a = [_] f64 {0.1, -0.2, -0.5, 1.2, 1.5};
  std.debug.print("\nMean {}\n", .{mean(a.len, &a)});
}
