const std = @import("std");
const testing = std.testing;

pub export fn median(len:usize, x: [*]const f64) f64 {
  @setFloatMode(.Optimized);
  var res: f64 = 0.0;
  return res;
}

test "basic median functionality" {
  const a = [_] f64 {0.1, -0.2, -0.5, 1.2, 1.5};
  std.debug.print("\nMedian {}\n", .{median(a.len, &a)});
}
