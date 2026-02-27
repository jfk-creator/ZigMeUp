const std = @import("std");
const HttpServer = @import("httpServer.zig").HttpServer;

pub fn main() !void {
    const host: [4]u8 = .{127, 0, 0, 1};
    const port = 6969;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const check = gpa.deinit();
        if(check == .leak) {
            std.log.err("Memoy leak detected!\n", .{});
        }
    }

    const alloc = gpa.allocator();

    var httpServer = try HttpServer.init(alloc, host, port);
    defer httpServer.deinit();

    try httpServer.acceptRoutine();
}

// pub fn handleConnection(connection: std.net.Server.Connection) !void {
//     defer connection.stream.close();
//
//     var rbuf: [1024]u8 = [_]u8{0} ** 1024;
//     var wbuf: [1024]u8 = [_]u8{0} ** 1024;
//
//     var conReader = connection.stream.reader(&rbuf);
//     var conWriter = connection.stream.writer(&wbuf);
//
//     var httpServer = http.Server.init(conReader.interface(), &conWriter.interface);
//
//
//     var request = httpServer.receiveHead() catch |err| switch (err) {
//         error.HttpConnectionClosing => return,
//         else => return err, 
//     };
//
//     std.debug.print("Received {s} request for: {s}\n", 
//         .{ @tagName(request.head.method), request.head.target });
//
//     if(request.head.method == .OPTIONS) {
//         try request.respond("", .{ 
//             .status = .no_content, 
//             // .extra_headers = &cors_headers, // only for localhost, nginx is doing this for us
//             .keep_alive = false});
//         return;
//     }
//
//     if (request.head.method == .POST) {
//         try handlePost(&request);
//     }
// }
//
// const Login = struct {
//     user: []const u8, 
//     secret: []const u8
// };
//
// pub fn handlePost(request: *http.Server.Request) !void {
//
//     var transfer_buffer: [8192]u8 = undefined;
//     var body_reader = request.server.reader.bodyReader(
//         &transfer_buffer, 
//         .none, 
//         request.head.content_length
//     );
//
//     var body_buffer: [8192]u8 = undefined;
//     var bytes_read: usize = 0;
//     while (true) {
//         const size = try body_reader.readSliceShort(body_buffer[bytes_read..]);
//         if (size == 0) break; 
//
//         bytes_read += size;
//         if (request.head.content_length) |c_len| {
//             if (bytes_read >= c_len) break;
//         }
//
//         if (bytes_read >= body_buffer.len) break; 
//     }
//
//     const body = body_buffer[0..bytes_read];
//
//     std.debug.print("Received POST body: {s}\n", .{body});
//
//     var debugAlloc = std.heap.DebugAllocator(.{}).init;
//     defer {
//         const heapCheck = debugAlloc.deinit();
//         if(heapCheck == .leak) std.debug.print("Leaking Memory in handlePost", .{});
//     }
//     const allocator = debugAlloc.allocator();
//
//
//
//     const parsed = try std.json.parseFromSlice(Login, allocator, body, .{});
//     defer parsed.deinit();
//     const loginData = parsed.value;
//
//     std.debug.print("username: {s}, secret: {s}\n", .{loginData.user, loginData.secret});
//
//     try request.respond("{\"key\": \"SuperSecretKey\"}", .{
//         .status = .ok,
//         .keep_alive = false,
//     });
//     return;
// }
