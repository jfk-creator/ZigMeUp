const std = @import("std");

pub fn main() !void {
    var buffer: [1024]u8 = undefined;
    const stdin = std.fs.File.stdin();
    defer stdin.close();

    std.debug.print("Encrypt Ceasar\nRotations: ", .{});
    const userInput = try readFromStdin(stdin, &buffer);
    const rotN = try std.fmt.parseInt(u8, userInput, 10);
    std.debug.print("Text will be rotated by {d} characters\n", .{rotN});
    std.debug.print("Input: ", .{});
    const userString = try readFromStdin(stdin, &buffer);
    const enc = rotateString(userString, rotN);
    std.debug.print("Encrypted Text: {s}\n", .{enc});
}

// ASCII Alphabet: 065 - 122
fn rotateString(in: []u8, n: u8) []u8 {
    if(in.len == 0) return in;

    for(in) |*c| {
        if(std.ascii.isLower(c.*)){
            var temp = c.* - 97; 
            temp += n;  
            temp = temp % 26;
            c.* = temp + 97; 
        }
        if(std.ascii.isUpper(c.*)){
            var temp = c.* - 65; 
            temp += n;  
            temp = temp % 26;
            c.* = temp + 65; 
        }
    }

    return in;
}

fn readFromStdin(stdin: std.fs.File, buffer: []u8) ![]u8 {
    var reader = stdin.reader(buffer).interface;
    const input = try reader.takeDelimiterExclusive('\n');
    reader.toss(1);
    return input;
}
