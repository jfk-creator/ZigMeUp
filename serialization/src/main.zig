const std = @import("std");

const Player_t = enum (u8) {
    wizard = 0,
    techi,
    botanic
};

const Player = struct {
    health: u32,
    p_type: Player_t,
    
    pos: struct { x: f32, y: f32 },

    name_buf: [255]u8,
    name_len: usize,

    // --- Constructor ---
    pub fn init(health: u32, x: f32, y: f32, name: []const u8, p_type: Player_t) Player {
        // Safety: Truncate name if it's too long for our buffer
        const len = @min(name.len, 255);

        var p = Player{
            .health   = health,
            .p_type   = p_type,
            .pos      = .{ .x = x, .y = y },
            .name_buf = undefined, // We will fill this below
            .name_len = len,
        };

        // Copy only the actual name bytes into our buffer
        @memcpy(p.name_buf[0..len], name[0..len]);

        return p;
    }

    // --- Helper ---
    // Returns a clean slice of the name (ignoring the empty space in the buffer)
    pub fn getName(self: *const Player) []const u8 {
        return self.name_buf[0..self.name_len];
    }

    // --- The "Magic" Formatter ---
    // Instead of 'toString', we implement 'format'. 
    // This allows you to use std.debug.print("{}", .{player}) directly!
    pub fn format(
        self: Player,
        writer: anytype,
    ) !void {
        try writer.print("Player '{s}' [HP: {d}] pos:({d:.1}, {d:.1})\n", .{
            self.getName(), self.health, self.pos.x, self.pos.y
        });
    }
};

pub fn main() !void {
    std.debug.print("what's up boiiiiis\n", .{});

    const p1: Player = Player.init(100, 32.0, 64.0, "nano", Player_t.wizard);

    const file_name = "player.file";
    try writePlayerToFile(file_name, p1);
    std.debug.print("p1: {f}\n" , .{p1});
}

fn writePlayerToFile(filename: []const u8, player: Player) !void {
    var file = try std.fs.cwd().createFile(filename, .{});
    defer file.close();

    //var buffer: [4096]u8 = undefined;
    //const player_string = try std.fmt.bufPrint(&buffer, "{f}", .{player});
    //try writeToFile(player.getName(), player_string);
    try savePlayer(player, filename);
    std.debug.print("filename: {s}", .{filename});
}

fn savePlayer(player: Player, filename: []const u8) !void {
    const file = try std.fs.cwd().createFile(filename, .{ .truncate = true});
    defer file.close();

    var buffer: [4096]u8 = undefined;
    var file_writer = file.writer(&buffer); 

    //try std.json.Stringify.value(player, .{}, &file_writer.interface);
    //try file_writer.interface.flush();
    
    var s: std.json.Stringify = .{ .writer = &file_writer.interface, .options = .{} };
    try s.write(player);
    try file_writer.interface.flush();
}

fn writeToFile(filename: []const u8, data: []const u8) !void {
    const dir = std.fs.cwd();
    const file = try dir.createFile(filename, .{ .truncate = false});
    defer file.close();
    const end_pos = try file.getEndPos();
    try file.seekTo(end_pos);
    try file.writeAll(data);
    std.debug.print("written: {s} to file {s} at {d}\n", .{data, filename, end_pos});
}


