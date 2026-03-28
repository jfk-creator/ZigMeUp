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

    pub fn withX(self: Vec2, new_x: f32) Vec2 {
        return .{ .v = .{ new_x, self.y() } };
    }

    pub fn withY(self: Vec2, new_y: f32) Vec2 {
        return .{ .v = .{ self.x(), new_y } };
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

    pub fn cross(self: Vec2, other: Vec2) f32 {
        return self.x() * other.y() - self.y() * other.x();
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

    /// Angle in rads
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

    pub fn withX(self: Vec3, new_x: f32) Vec3 {
        return .{ .v = .{ new_x, self.y(), self.z() } };
    }

    pub fn withY(self: Vec3, new_y: f32) Vec3 {
        return .{ .v = .{ self.x(), new_y, self.z() } };
    }

    pub fn withZ(self: Vec3, new_z: f32) Vec3 {
        return .{ .v = .{ self.x(), self.y(), new_z } };
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

    pub fn withX(self: Vec4, new_x: f32) Vec4 {
        return .{ .v = .{ new_x, self.y(), self.z(), self.w() } };
    }

    pub fn withY(self: Vec4, new_y: f32) Vec4 {
        return .{ .v = .{ self.x(), new_y, self.z(), self.w() } };
    }

    pub fn withZ(self: Vec4, new_z: f32) Vec4 {
        return .{ .v = .{ self.x(), self.y(), new_z, self.w() } };
    }

    pub fn withW(self: Vec4, new_w: f32) Vec4 {
        return .{ .v = .{ self.x(), self.y(), self.z(), new_w } };
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

pub const Color = struct {
    v: @Vector(4, f32),

    /// Initialize directly with floats from 0.0 to 1.0
    pub fn init(rf32: f32, gf32: f32, bf32: f32, af32: f32) Color {
        return .{ .v = .{ rf32, gf32, bf32, af32 } };
    }

    /// Initialize with standard 0-255 bytes. 
    pub fn fromBytes(r_byte: u8, g_byte: u8, b_byte: u8, a_byte: u8) Color {
        return init(
            @as(f32, @floatFromInt(r_byte)) / 255.0,
            @as(f32, @floatFromInt(g_byte)) / 255.0,
            @as(f32, @floatFromInt(b_byte)) / 255.0,
            @as(f32, @floatFromInt(a_byte)) / 255.0,
        );
    }

    /// Initialize with a hex code (e.g. 0xRRGGBBAA)
    pub fn fromHex(hex: u32) Color {
        return fromBytes(
            @intCast((hex >> 24) & 0xFF),
            @intCast((hex >> 16) & 0xFF),
            @intCast((hex >> 8) & 0xFF),
            @intCast(hex & 0xFF),
        );
    }

    pub fn r(self: Color) f32 {
        return self.v[0];
    }
    
    pub fn g(self: Color) f32 {
        return self.v[1];
    }
    
    pub fn b(self: Color) f32 {
        return self.v[2];
    }
    
    pub fn a(self: Color) f32 {
        return self.v[3];
    }

    pub fn withR(self: Color, new_r: f32) Color {
        return .{ .v = .{ new_r, self.g(), self.b(), self.a() } };
    }

    pub fn withG(self: Color, new_g: f32) Color {
        return .{ .v = .{ self.r(), new_g, self.b(), self.a() } };
    }

    pub fn withB(self: Color, new_b: f32) Color {
        return .{ .v = .{ self.r(), self.g(), new_b, self.a() } };
    }

    pub fn withA(self: Color, new_a: f32) Color {
        return .{ .v = .{ self.r(), self.g(), self.b(), new_a } };
    }

    pub fn lerp(self: Color, other: Color, t: f32) Color {
        const diff = other.v - self.v;
        const splat_t: @Vector(4, f32) = @splat(t);
        return .{ .v = self.v + (diff * splat_t) };
    }

    pub fn format(self: Color, writer: anytype) !void {
        try writer.print("RGBA({d:.2}, {d:.2}, {d:.2}, {d:.2})", .{
            self.r(), self.g(), self.b(), self.a(),
        });
    }

    // =========================================================================
    // THE OPENTK / X11 COLOR PALETTE
    // =========================================================================
    
    pub const transparent = init(0.0, 0.0, 0.0, 0.0);

    // --- The Engine Essentials ---
    pub const white = fromBytes(255, 255, 255, 255);
    pub const black = fromBytes(0, 0, 0, 255);
    pub const red = fromBytes(255, 0, 0, 255);
    pub const green = fromBytes(0, 255, 0, 255);
    pub const blue = fromBytes(0, 0, 255, 255);
    pub const yellow = fromBytes(255, 255, 0, 255);
    pub const cyan = fromBytes(0, 255, 255, 255);
    pub const magenta = fromBytes(255, 0, 255, 255); // The "Missing Texture" classic
    pub const cornflower_blue = fromBytes(100, 149, 237, 255); // The XNA/OpenTK clear screen classic

    // --- Grayscale ---
    pub const dim_gray = fromBytes(105, 105, 105, 255);
    pub const gray = fromBytes(128, 128, 128, 255);
    pub const dark_gray = fromBytes(169, 169, 169, 255);
    pub const light_gray = fromBytes(211, 211, 211, 255);
    pub const silver = fromBytes(192, 192, 192, 255);
    pub const slate_gray = fromBytes(112, 128, 144, 255);

    // --- Blues ---
    pub const alice_blue = fromBytes(240, 248, 255, 255);
    pub const dodger_blue = fromBytes(30, 144, 255, 255);
    pub const deep_sky_blue = fromBytes(0, 191, 255, 255);
    pub const sky_blue = fromBytes(135, 206, 235, 255);
    pub const steel_blue = fromBytes(70, 130, 180, 255);
    pub const navy = fromBytes(0, 0, 128, 255);
    pub const midnight_blue = fromBytes(25, 25, 112, 255);
    pub const teal = fromBytes(0, 128, 128, 255);

    // --- Greens ---
    pub const lawn_green = fromBytes(124, 252, 0, 255);
    pub const lime_green = fromBytes(50, 205, 50, 255);
    pub const forest_green = fromBytes(34, 139, 34, 255);
    pub const dark_green = fromBytes(0, 100, 0, 255);
    pub const olive = fromBytes(128, 128, 0, 255);
    pub const yellow_green = fromBytes(154, 205, 50, 255);
    pub const sea_green = fromBytes(46, 139, 87, 255);

    // --- Reds / Oranges / Browns ---
    pub const orange = fromBytes(255, 165, 0, 255);
    pub const dark_orange = fromBytes(255, 140, 0, 255);
    pub const coral = fromBytes(255, 127, 80, 255);
    pub const tomato = fromBytes(255, 99, 71, 255);
    pub const firebrick = fromBytes(178, 34, 34, 255);
    pub const crimson = fromBytes(220, 20, 60, 255);
    pub const maroon = fromBytes(128, 0, 0, 255);
    pub const saddle_brown = fromBytes(139, 69, 19, 255);
    pub const chocolate = fromBytes(210, 105, 30, 255);
    pub const sandy_brown = fromBytes(244, 164, 96, 255);

    // --- Purples / Pinks ---
    pub const purple = fromBytes(128, 0, 128, 255);
    pub const indigo = fromBytes(75, 0, 130, 255);
    pub const dark_magenta = fromBytes(139, 0, 139, 255);
    pub const plum = fromBytes(221, 160, 221, 255);
    pub const hot_pink = fromBytes(255, 105, 180, 255);
    pub const deep_pink = fromBytes(255, 20, 147, 255);
};

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

