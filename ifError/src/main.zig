const std = @import("std");
const argon2 = std.crypto.pwhash.argon2;

pub fn main() !void {
    if(tester(1,2)) |msg| {
        std.debug.print("tester: {s}\n", .{msg});
    } else |e| {
        std.debug.print("testing failed: {}\n", .{e});
    } 
}

pub fn tester(a: u32, b: u32) ![]const u8 {
    if(a == b) return "Correct";
    return error.NumbersDontMatch;
}

