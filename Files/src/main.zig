const std = @import("std");
const Io = std.Io;

const ZigMeUp = @import("ZigMeUp");

pub fn main(init: std.process.Init) !void {
    const alloc = init.gpa;
    const content = "Ich bin ein Satz.";
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(init.io, "myFile.txt", .{ .truncate = true, .read = true });
    defer file.close(init.io);

    var buffer: [content.len]u8 = undefined;
    var file_writer: std.Io.File.Writer = file.writer(init.io, &buffer);
    const writer = &file_writer.interface;
    const bytes_written = try writer.write(content);
    try file_writer.flush();
    std.log.debug("written: {d} bytes", .{bytes_written});

    const file_length = try file.length(init.io);
    std.log.debug("file length: {d}", .{file_length});
    const read_buffer: []u8 = try alloc.alloc(u8, file_length);
    defer alloc.free(read_buffer);

    var file_reader = file.reader(init.io, read_buffer);
    const reader = &file_reader.interface;
    try reader.readSliceAll(read_buffer);
    std.log.debug("file content: {s}", .{read_buffer});
    std.log.debug("file content len: {d}", .{buffer.len});
}

