const std = @import("std");
const net = std.net;
const http = std.http;

pub fn main() !void {
    const host: [4]u8 = .{127, 0, 0, 1};
    const port = 6969;
    const addr = net.Address.initIp4(host, port);
    var server = try addr.listen(.{ .reuse_address = true});
    defer server.deinit();
    std.debug.print("HttpServer is running on port: {d}\n", .{port});
    while (true) {
        const connection = try server.accept();
        std.debug.print("connection accepted\n", .{});
        try handleConnection(connection);
    }
}

pub fn handleConnection(connection: std.net.Server.Connection) !void {
    defer connection.stream.close();


    var rbuf: [1024]u8 = [_]u8{0} ** 1024;
    var wbuf: [1024]u8 = [_]u8{0} ** 1024;

    var conReader = connection.stream.reader(&rbuf);
    var conWriter = connection.stream.writer(&wbuf);

    var httpServer = http.Server.init(conReader.interface(), &conWriter.interface);

    var request = httpServer.receiveHead() catch |err| switch (err) {
        error.HttpConnectionClosing => return,
        else => return err, 
    };

    std.debug.print("Received {s} request for: {s}\n", 
        .{ @tagName(request.head.method), request.head.target });

    const cors_headers = [_]std.http.Header{
        .{ .name = "Access-Control-Allow-Origin", .value = "*" }, 
        .{ .name = "Access-Control-Allow-Methods", .value = "GET, POST, OPTIONS" },
        .{ .name = "Access-Control-Allow-Headers", .value = "Content-Type, Authorization" },
    };

    if(request.head.method == .OPTIONS) {
        try request.respond("", .{ 
            .status = .no_content, 
            .extra_headers = &cors_headers, 
            .keep_alive = false});
        return;
    }

    if (request.head.method == .POST) {
        try handlePost(&request, cors_headers);
    }
}

const Login = struct {
    user: []const u8, 
    secret: []const u8
};

pub fn handlePost(request: *http.Server.Request, cors_headers: [3]std.http.Header) !void {

    var transfer_buffer: [8192]u8 = undefined;
    var body_reader = request.server.reader.bodyReader(
        &transfer_buffer, 
        .none, 
        request.head.content_length
    );
    var body_buffer: [8192]u8 = undefined;
    var bytes_read: usize = 0;
    while (true) {
        const size = try body_reader.readSliceShort(body_buffer[bytes_read..]);
        if (size == 0) break; 

        bytes_read += size;
        if (request.head.content_length) |c_len| {
            if (bytes_read >= c_len) break;
        }

        if (bytes_read >= body_buffer.len) break; 
    }

    const body = body_buffer[0..bytes_read];

    std.debug.print("Received POST body: {s}\n", .{body});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    const parsed = try std.json.parseFromSlice(Login, allocator, body, .{});
    const loginData = parsed.value;

    std.debug.print("username: {s}, secret: {s}\n", .{loginData.user, loginData.secret});

    try request.respond("{\"key\": \"superSecretKey\"}", .{
        .status = .ok,
        .extra_headers = &cors_headers, 
        .keep_alive = false,
    });
    return;
}
