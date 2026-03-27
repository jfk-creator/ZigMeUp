const std = @import("std");
const expect = std.testing.expect;

pub fn main() !void {
    std.debug.print("Hello World\n", .{});
    const a = try some_math();
    _ = a;
}

fn some_math() !u32 {
    return std.math.maxInt(u32) - 1;
}

test "succeed" {
    try expect(true);
}

test "math_function" {
    const a = try some_math();
    try expect(a > std.math.maxInt(u32));
}
