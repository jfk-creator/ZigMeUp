const std = @import("std");

pub const Vec3 = struct {
    v: @Vector(3, f32),

    pub fn init(xf32: f32, yf32: f32, zf32: f32) Vec3 {
        return .{ .v = .{ xf32, yf32, zf32 } };
    }

    pub fn x(self: Vec3) f32 {
        return self.v[0];
    }
    pub fn y(self: Vec3) f32 {
        return self.v[1];
    }
    pub fn z(self: Vec3) f32 {
        return self.v[2];
    }

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return .{ .v = self.v + other.v };
    }

    pub fn sub(self: Vec3, other: Vec3) Vec3 {
        return .{ .v = self.v - other.v };
    }

    pub fn scale(self: Vec3, scalar: f32) Vec3 {
        const splat_scalar: @Vector(3, f32) = @splat(scalar);
        return .{ .v = self.v * splat_scalar };
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        const mul = self.v * other.v;
        return @reduce(.Add, mul);
    }

    pub fn cross(self: Vec3, other: Vec3) Vec3 {
        return Vec3.init(
            self.y() * other.z() - self.z() * other.y(),
            self.z() * other.x() - self.x() * other.z(),
            self.x() * other.y() - self.y() * other.x(),
        );
    }

    pub fn lengthSq(self: Vec3) f32 {
        return self.dot(self);
    }

    pub fn length(self: Vec3) f32 {
        return @sqrt(self.lengthSq());
    }

    pub fn distance(self: Vec3, other: Vec3) f32 {
        return self.sub(other).length();
    }

    pub fn normalize(self: Vec3) Vec3 {
        const len = self.length();
        if (len == 0.0) return self;
        return self.scale(1.0 / len);
    }

    pub fn lerp(self: Vec3, other: Vec3, t: f32) Vec3 {
        const diff = other.sub(self);
        return self.add(diff.scale(t));
    }

    pub fn format(self: Vec3, writer: anytype) !void {
        try writer.print("({d:.3}, {d:.3}, {d:.3})", .{ self.x(), self.y(), self.z() });
    }
};
