const std = @import("std");
const pwd = @import("pwd.zig");

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const stdin = std.fs.File.stdin();
    defer stdin.close();
    var buffer: [255]u8 = undefined;
    var readBuffer: [255]u8 = undefined;

    std.debug.print("Enter your password: ", .{});
    const pw =  try readFromStdIn(stdin, &readBuffer);
    const hash = try pwd.hashPassword(alloc, pw, &buffer);
    
    std.debug.print("Login: ", .{});
    const pw2 =  try readFromStdIn(stdin, &readBuffer);
    if(pwd.verifyPassword(alloc, pw2, hash)) std.debug.print("success\n", .{});
}


pub fn readFromStdIn(stdin: std.fs.File, buffer: []u8) ![]u8 {
    var reader = stdin.reader(buffer);
    const input = try reader.interface.takeDelimiterExclusive('\n'); 
    reader.interface.toss(1);
    return input;
}
