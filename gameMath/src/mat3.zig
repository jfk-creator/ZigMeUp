const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;

pub const Mat3 = struct {
    columns: [3]Vec3,

    /// Creates a new 3x3 matrix with 3 columns
    pub fn init(col0: Vec3, col1: Vec3, col2: Vec3) Mat3 {
        return .{ .columns = .{ col0, col1, col2 } };
    }

    pub fn identity() Mat3 {
        return init(
            Vec3.init(1.0, 0.0, 0.0), // x-axis
            Vec3.init(0.0, 1.0, 0.0), // y-axis
            Vec3.init(0.0, 0.0, 1.0), // z-axis
        );
    }

    pub fn mulVec(self: Mat3, v: Vec3) Vec3 {
        const x_axis = self.columns[0].scale(v.x());
        const y_axis = self.columns[1].scale(v.y());
        const z_axis = self.columns[2].scale(v.z());

        return x_axis.add(y_axis).add(z_axis);
    }

    pub fn mul(self: Mat3, other: Mat3) Mat3 {
        return init(
            self.mulVec(other.columns[0]),
            self.mulVec(other.columns[1]),
            self.mulVec(other.columns[2]),
        );
    }

    pub fn translation(x: f32, y: f32) Mat3 {
        var mat = identity();
        mat.columns[2] = Vec3.init(x, y, 1.0);
        return mat;
    }

    pub fn scaling(sx: f32, sy: f32) Mat3 {
        return init(
            Vec3.init(sx, 0.0, 0.0),
            Vec3.init(0.0, sy, 0.0),
            Vec3.init(0.0, 0.0, 1.0),
        );
    }

    pub fn rotation(angle: f32) Mat3 {
        const s = @sin(angle);
        const c = @cos(angle);
        return init(
            Vec3.init(c, s, 0.0),
            Vec3.init(-s, c, 0.0),
            Vec3.init(0.0, 0.0, 1.0),
        );
    }

    pub fn format(self: Mat3, writer: anytype) !void {
        const c0 = self.columns[0];
        const c1 = self.columns[1];
        const c2 = self.columns[2];

        try writer.print("Mat3(\n", .{});
        try writer.print("  [{d:>7.3}, {d:>7.3}, {d:>7.3}]\n", .{ c0.x(), c1.x(), c2.x() });
        try writer.print("  [{d:>7.3}, {d:>7.3}, {d:>7.3}]\n", .{ c0.y(), c1.y(), c2.y() });
        try writer.print("  [{d:>7.3}, {d:>7.3}, {d:>7.3}]\n", .{ c0.z(), c1.z(), c2.z() });
        try writer.print(")\n", .{});
    }
};
