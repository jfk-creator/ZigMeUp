const std = @import("std");

const User = struct {
    user_name: []const u8, 
    user_id: i64, 
    secrete: []const u8,
    address_id: i64,
};

const Address = struct {
    street_name: []const u8, 
    street_number: i64, 
};

pub fn main() !void {
    printStructName(User);
}

pub fn printStructName(comptime T: type) void {
    const info = @typeInfo(T);
    switch (info) {
        .@"struct" => |struct_info| {
            inline for (struct_info.fields) |field| {
                std.debug.print("{s}: ", .{field.name});
                if(field.type == []const u8) {
                    std.debug.print("TEXT", .{});
                } else if (field.type == i64) {
                    std.debug.print("INTEGER", .{});
                } else {
                    const field_info = @typeInfo(field.type);
                    switch (field_info) {
                        .@"struct" => |_| {
                            std.debug.print("\n", .{});
                            printStructName(field.type);
                        },
                        else => { std.debug.print("TYPE NOT FOUND\n", .{}); }
                    }
                }
                std.debug.print("\n", .{});
            }
        },
        else => std.debug.print("Not a struct broh\n", .{})
    }
}

