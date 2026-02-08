const std = @import("std");

const cli_arguments = enum {
    port,
    ip,
    usage,
    help
};

pub fn usageMsg() void {
    std.debug.print("echoServer --ip 127.0.0.1 --port 43300", .{});
}

pub fn main() !void {
    std.log.info("------ NanoEcho ------\n", .{});
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    const host = .{127, 0, 0, 1};
    var port: u16 = 43333;
    var args = std.process.args();
    var arg_slice = args.next();
    var i: usize = 0;
    while(arg_slice != null) {
        if(std.mem.eql(u8, arg_slice.?, "--port")) {
            arg_slice = args.next();
            if(arg_slice == null) {
                usageMsg();
                return; 
            }
            port = std.fmt.parseUnsigned(u16, arg_slice.?, 10) catch {
                usageMsg();
                return;
            };
        }
        arg_slice = args.next();
        i += 1; 
    }
    const addr = std.net.Address.initIp4(host, port);
    var server = try addr.listen(.{ .reuse_address = true });
    defer server.deinit();

    std.log.info("Listening on port {d}", .{port});
    while (true) {
        const client = try server.accept();
        var buffer: [15]u8 = undefined;
        std.debug.print("Connection established with {s}\n", .{ip4ToSlice(&buffer, client.address.in)});
        var pool: std.Thread.Pool = undefined;
        try pool.init(.{ .allocator = allocator});
        try pool.spawn(handleClient, .{ client });
    }
}

pub fn ip4ToSlice(buffer: *[15]u8, addr: std.net.Ip4Address) []u8{
    const c_addr: [4]u8 = @bitCast(addr.sa.addr);
    const slice = std.fmt.bufPrint(buffer, "{d}.{d}.{d}.{d}:{d}", .{c_addr[0], c_addr[1], c_addr[2], c_addr[3], addr.getPort()}) catch unreachable; 
    return slice;
}

pub fn handleClient(client: std.net.Server.Connection) void {
    defer client.stream.close();
            
    var fmt_buffer: [15]u8 = undefined;
    const user_addr = ip4ToSlice(&fmt_buffer, client.address.in); 

    while(true){
        const buff_limit: usize = std.heap.pageSize();
        var read_buffer: [buff_limit]u8 = undefined;
        var write_buffer: [buff_limit]u8 = undefined;
        var send_buffer: [buff_limit]u8 = undefined;

        var writer = std.fs.File.stdout().writer(&write_buffer).interface;
        var reader = client.stream.reader(&read_buffer);
        var in: *std.io.Reader = reader.interface(); 
        const rv_bytes = in.streamDelimiterLimit(&writer, '\n', .limited(buff_limit)) catch |e| {
            switch (e) {
                error.ReadFailed => std.log.info("user: {s} disconnected.", .{ user_addr }),
                else => {
                    std.log.err("error in handleClient: {}", .{e});
                    break;
                }
            }
            break;
        };
        if(rv_bytes > 0){
            std.debug.print("{s}: {s}\n", .{user_addr, write_buffer[0..rv_bytes]});
            var send = client.stream.writer(&send_buffer);
            var out: *std.io.Writer = &send.file_writer.interface;
            _ = out.write(write_buffer[0..rv_bytes]) catch |e| { std.log.err("couldn't write buffer content, with error: {}", .{e}); return; };
            _ = out.write("\n") catch |e| std.log.err("couldn't write newLine, with error: {}", .{e});
            out.flush() catch std.debug.panic("didn't flush\n", .{});
        }
    }
}
