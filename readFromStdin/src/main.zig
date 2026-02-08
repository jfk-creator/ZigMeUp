const std = @import("std");

pub fn main() !void {
    var buffer: [1024]u8 = undefined;
    std.debug.print("you typed: {s}\n", .{try readFromStdIn(&buffer)});
}

// don't try reading from NVIM bruh, pls stop.
pub fn readFromStdIn(buffer: []u8) ![]u8 {
    const stdin = std.fs.File.stdin();
    defer stdin.close();
    var reader = stdin.reader(buffer);
    const input = try reader.interface.takeDelimiterExclusive('\n'); 
    reader.interface.toss(1);
    return input;
}
