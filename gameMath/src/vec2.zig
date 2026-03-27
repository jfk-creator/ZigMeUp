const std = @import("std");

pub const Vec2 = struct {
    v: @Vector(2, f32),

    pub fn init(xf32: f32, yf32: f32) Vec2 {
        return .{ .v = .{ xf32, yf32 } };
    }

    pub fn x(self: Vec2) f32 {
        return self.v[0];
    }
    pub fn y(self: Vec2) f32 {
        return self.v[1];
    }

    pub fn add(self: Vec2, other: Vec2) Vec2 {
        return .{ .v = self.v + other.v };
    }

    pub fn sub(self: Vec2, other: Vec2) Vec2 {
        return .{ .v = self.v - other.v };
    }

    pub fn scale(self: Vec2, scalar: f32) Vec2 {
        return .{ .v = self.v * @as(@Vector(2, f32), @splat(scalar)) };
    }

    pub fn dot(self: Vec2, other: Vec2) f32 {
        return @reduce(.Add, self.v * other.v);
    }

    pub fn lengthSq(self: Vec2) f32 {
        return self.dot(self);
    }

    pub fn length(self: Vec2) f32 {
        return @sqrt(self.lengthSq());
    }

    pub fn distance(self: Vec2, other: Vec2) f32 {
        return self.sub(other).length();
    }

    pub fn normalize(self: Vec2) Vec2 {
        const len = self.length();
        if (len == 0) return self;
        return self.scale(1.0 / len);
    }

    pub fn setMag(self: Vec2, mag: f32) Vec2 {
        return self.normalize().scale(mag);
    }

    /// Max Length
    pub fn limit(self: Vec2, max: f32) Vec2 {
        if (self.lengthSq() > max * max) {
            return self.setMag(max);
        }
        return self;
    }

    /// Angle in rads
    pub fn heading(self: Vec2) f32 {
        return std.math.atan2(self.y(), self.x());
    }

    pub fn lerp(self: Vec2, other: Vec2, t: f32) Vec2 {
        const diff = other.sub(self);
        return self.add(diff.scale(t));
    }

    pub fn angleBetween(self: Vec2, other: Vec2) f32 {
        const d = self.dot(other);
        const l = self.length() * other.length();
        if (l == 0) return 0;
        return std.math.acos(std.math.clamp(d / l, -1.0, 1.0));
    }

    pub fn random2D(random: std.Random) Vec2 {
        const angle = random.float(f32) * std.math.tau;
        return Vec2.init(@cos(angle), @sin(angle));
    }

    pub fn format(self: Vec2, writer: anytype) !void {
        try writer.print("({d:.3}, {d:.3})", .{ self.x(), self.y() });
    }
};
