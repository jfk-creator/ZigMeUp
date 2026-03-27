const std = @import("std");

pub const Vec4 = struct {
    v: @Vector(4, f32),

    pub fn init(xf32: f32, yf32: f32, zf32: f32, wf32: f32) Vec4 {
        return .{ .v = .{ xf32, yf32, zf32, wf32 } };
    }

    pub fn x(self: Vec4) f32 {
        return self.v[0];
    }
    pub fn y(self: Vec4) f32 {
        return self.v[1];
    }
    pub fn z(self: Vec4) f32 {
        return self.v[2];
    }
    pub fn w(self: Vec4) f32 {
        return self.v[3];
    }

    pub fn add(self: Vec4, other: Vec4) Vec4 {
        return .{ .v = self.v + other.v };
    }

    pub fn sub(self: Vec4, other: Vec4) Vec4 {
        return .{ .v = self.v - other.v };
    }

    pub fn scale(self: Vec4, scalar: f32) Vec4 {
        const splat_scalar: @Vector(4, f32) = @splat(scalar);
        return .{ .v = self.v * splat_scalar };
    }

    pub fn dot(self: Vec4, other: Vec4) f32 {
        const mul = self.v * other.v;
        return @reduce(.Add, mul);
    }

    pub fn lengthSq(self: Vec4) f32 {
        return self.dot(self);
    }

    pub fn length(self: Vec4) f32 {
        return @sqrt(self.lengthSq());
    }

    pub fn distance(self: Vec4, other: Vec4) f32 {
        return self.sub(other).length();
    }

    pub fn normalize(self: Vec4) Vec4 {
        const len = self.length();
        if (len == 0.0) return self;
        return self.scale(1.0 / len);
    }

    pub fn lerp(self: Vec4, other: Vec4, t: f32) Vec4 {
        const diff = other.sub(self);
        return self.add(diff.scale(t));
    }

    pub fn format(self: Vec4, writer: anytype) !void {
        try writer.print("({d:.3}, {d:.3}, {d:.3}, {d:.3})", .{
            self.x(), self.y(), self.z(), self.w(),
        });
    }
};
