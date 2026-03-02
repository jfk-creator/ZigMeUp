const std = @import("std");
const Db = @import("db.zig").Db;

pub fn main() !void {
    var db = try Db.init();
    defer db.deinit();
    db.createTable();
    db.getUser();
}
