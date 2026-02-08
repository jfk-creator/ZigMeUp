const std = @import("std");

pub fn build(b: *std.Build) void {
    const name = "webServer";
    const exe = b.addExecutable(.{
        .name = name, 
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = b.graph.host,
        }), 
    });

    b.installArtifact(exe);

    var run_exe = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_exe.addArgs(args);
    }

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}
