const std = @import("std");

const Data = struct {
    int: i32, 
    string: []const u8,
};

pub fn main(init: std.process.Init) !void {
    _ = init;

    const a: Data = .{
        .string = "Ich bin a",
        .int = 5,
    };

    const b: Data = .{
        .string = "Ich bin b",
        .int = 5,
    };

    std.log.debug("a == b: {any}", .{std.meta.eql(a, b)});
}

