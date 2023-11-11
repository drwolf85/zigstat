const std = @import("std");
const print = std.debug.print;

export fn absolute_error(approx: f64, truth: f64) f64 {
    return approx - truth;
}

export fn relative_error(approx: f64, truth: f64) f64 {
    var err: f64 = approx - truth;
    return err / truth;
}

export fn approx_value(truth: f64, rel_err: f64) f64 {
    var aprx: f64 = truth * (1.0 + rel_err);
    return aprx;
}



test "\nBasic error functions" {
    print("\nAbs. err. (3 vs 2): {}\n",
              .{absolute_error(3.0, 2.0)});
    print("Rel. err. (3 vs 2): {}\n",
              .{relative_error(3.0, 2.0)});
    print("Approx. val. (2.0, 1%): {}\n", 
              .{approx_value(2.0, 0.01)});
}
