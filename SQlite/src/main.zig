const std = @import("std");
const sqlite = @cImport({
    @cInclude("sqlite3.h");
});

pub fn main() !void {
    std.debug.print("Hello World\n", .{});

    var db: ?*sqlite.sqlite3 = null; 
    var err_msg: [*c]u8 = null; 

    //init
    const open_fd = sqlite.sqlite3_open("mydata.db", &db);
    if(open_fd != sqlite.SQLITE_OK) {
        std.debug.print("Failed to load file: {s}\n", .{sqlite.sqlite3_errmsg(db)});
        return; 
    } else {
        std.debug.print("success: Opened Database.\n", .{});
    }

    defer {
        _ = sqlite.sqlite3_close(db);
        std.debug.print("success: Database closed.\n", .{});
    }

    //create table and insert user
    const sql = \\CREATE TABLE IF NOT EXISTS Users(Id INT PRIMARY KEY, Name TEXT); 
                \\INSERT OR IGNORE INTO Users VALUES(1, 'Alice');
    ;
    const exec_rc = sqlite.sqlite3_exec(db, sql, null, null, &err_msg);
    if (exec_rc != sqlite.SQLITE_OK) {
        std.debug.print("SQL error: {s}\n", .{err_msg});
        sqlite.sqlite3_free(err_msg);
    } else {
        std.debug.print("success: Table created and data inserted\n", .{});
    }

    //query data
    const query = "SELECT Id, Name FROM Users WHERE Id = 1;";
    var stmt: ?*sqlite.sqlite3_stmt = null;

    if(sqlite.sqlite3_prepare_v2(db, query, -1, &stmt, null) 
        == sqlite.SQLITE_OK) {
       
        defer _ = sqlite.sqlite3_finalize(stmt);

        while (sqlite.sqlite3_step(stmt) == sqlite.SQLITE_ROW) {
            const id = sqlite.sqlite3_column_int(stmt, 0);
            const name_ptr = sqlite.sqlite3_column_text(stmt, 1);

            const name = std.mem.span(name_ptr);

            std.debug.print("User found: ID={d}, Name={s}\n", .{id, name});
        }

    }

}

