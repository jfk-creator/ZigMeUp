const std = @import("std");
const argon2 = std.crypto.pwhash.argon2;

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    var buffer: [255]u8 = undefined;
    const hash = try setPassword(alloc, "Swordfish00", &buffer);
    std.debug.print("pw1: {s}\n", .{hash});
    if(argon2.strVerify(hash, "Swordfish00", .{ .allocator = alloc})) |_| {
        std.debug.print("success", .{});
    } else |err| {
        switch (err) {
            error.PasswordVerificationFailed => std.debug.print("Wrong Password\n", .{}),
            else => std.debug.print("Error Loggin in: {}", .{err}) 
        }
    }
}

pub fn setPassword(allocator: std.mem.Allocator, password: []const u8, buffer: *[255]u8) ![]const u8 {
    const params = argon2.Params.owasp_2id;
    const mode =   argon2.Mode.argon2id;
    const hash =  try argon2.strHash(password, .{ .allocator = allocator, .params = params, .mode = mode}, buffer);
    std.debug.print("pw1: {s}\n", .{hash});
    return hash;
}


pub fn readFromStdIn(buffer: []u8) ![]u8 {
    const stdin = std.fs.File.stdin();
    defer stdin.close();
    var reader = stdin.reader(buffer);
    const input = try reader.interface.takeDelimiterExclusive('\n'); 
    reader.interface.toss(1);
    return input;
}
