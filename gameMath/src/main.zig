const std = @import("std");

const testing = std.testing;
const expect = testing.expect;
const expectApproxEqAbs = testing.expectApproxEqAbs;

const Vec2 = @import("vec.zig").Vec2;
const Vec3 = @import("vec.zig").Vec3;
const Vec4 = @import("vec.zig").Vec4;
const Mat3 = @import("vec.zig").Mat3;

pub fn main() !void {
    var p: Vec2 = Vec2.init(0, 0);
    var v = Vec2.init(1, 1);
    const a = Vec2.init(1, 0);

    std.log.info("p: {any}", .{p});

    try expect(p.x() == 0 and p.y() == 0);

    p.v += v.v;
    v.v *= a.v;
    try expect(p.x() == 1 and p.y() == 1);
    p.v += v.v;
    try expect(p.x() == 2 and p.y() == 1);

    p = p.add(v);
    try expect(p.x() == 3 and p.y() == 1);

    v = v.scale(50);
    p = p.add(v);
    try expect(p.x() == 53 and p.y() == 1);

    v = v.normalize();
    p = p.add(v);
    try expect(p.x() == 54 and p.y() == 1);
    try expect(v.length() == 1);

    p = Vec2.init(9, 0);
    std.log.info("p: {any}", .{p});

    const length = p.length();
    try expect(length == 9);

    std.log.info("length: {d}", .{length});

    const left = Vec2.init(-1, 0);
    const right = Vec2.init(1, 0);
    const down = Vec2.init(0, -1);
    const up = Vec2.init(0, 1);
    try expect(left.dot(right) == -1);
    try expect(left.dot(down) == 0);
    try expect(up.dot(up) == 1);
    try expect(left.distance(right) == 2);
    try expect(left.lerp(right, 0.5).x() == 0);

    const matrix = Mat3.identity();
    std.debug.print("matrix {f}", .{matrix});
}

test "Vec2 - Init und Getter" {
    const v = Vec2.init(1.5, -2.5);
    try expect(v.x() == 1.5);
    try expect(v.y() == -2.5);
}

test "Vec2 - Grundrechenarten" {
    const v1 = Vec2.init(2.0, 3.0);
    const v2 = Vec2.init(1.0, -1.0);

    const sum = v1.add(v2);
    try expect(sum.x() == 3.0 and sum.y() == 2.0);

    const diff = v1.sub(v2);
    try expect(diff.x() == 1.0 and diff.y() == 4.0);

    const scaled = v1.scale(2.0);
    try expect(scaled.x() == 4.0 and scaled.y() == 6.0);
}

test "Vec2 - P5 Utilities (Length, Normalize, Limit)" {
    const v = Vec2.init(3.0, 4.0); // 3-4-5 Dreieck
    try expectApproxEqAbs(v.lengthSq(), 25.0, 0.001);
    try expectApproxEqAbs(v.length(), 5.0, 0.001);

    const norm = v.normalize();
    try expectApproxEqAbs(norm.length(), 1.0, 0.001);

    const limited = v.limit(2.0);
    try expectApproxEqAbs(limited.length(), 2.0, 0.001);

    const mag = v.setMag(10.0);
    try expectApproxEqAbs(mag.length(), 10.0, 0.001);
}

test "Vec2 - Math & Angles" {
    const v1 = Vec2.init(1.0, 0.0); // Zeigt nach rechts
    const v2 = Vec2.init(0.0, 1.0); // Zeigt nach oben

    try expectApproxEqAbs(v1.dot(v2), 0.0, 0.001); // Senkrecht = Dot 0
    try expectApproxEqAbs(v1.distance(v2), @sqrt(2.0), 0.001);

    // Winkel (90 Grad = PI / 2)
    try expectApproxEqAbs(v2.heading(), std.math.pi / 2.0, 0.001);
    try expectApproxEqAbs(v1.angleBetween(v2), std.math.pi / 2.0, 0.001);
}

test "Vec2 - Format" {
    const v = Vec2.init(1.234, 5.678);
    var buf: [64]u8 = undefined;
    const str = try std.fmt.bufPrint(&buf, "{f}", .{v});
    try testing.expectEqualStrings("(1.234, 5.678)", str);
}

test "Vec3 - Init und Math" {
    const v1 = Vec3.init(1.0, 2.0, 3.0);
    const v2 = Vec3.init(4.0, 5.0, 6.0);

    const sum = v1.add(v2);
    try expect(sum.x() == 5.0 and sum.y() == 7.0 and sum.z() == 9.0);

    const scaled = v1.scale(0.5);
    try expect(scaled.x() == 0.5 and scaled.y() == 1.0 and scaled.z() == 1.5);
}

test "Vec3 - Cross Product (Kreuzprodukt)" {
    const x_axis = Vec3.init(1.0, 0.0, 0.0);
    const y_axis = Vec3.init(0.0, 1.0, 0.0);

    // X kreuz Y muss Z ergeben
    const z_axis = x_axis.cross(y_axis);
    try expect(z_axis.x() == 0.0 and z_axis.y() == 0.0 and z_axis.z() == 1.0);
}

test "Vec3 - Length & Normalize" {
    const v = Vec3.init(2.0, -3.0, 6.0);
    try expectApproxEqAbs(v.length(), 7.0, 0.001);

    const norm = v.normalize();
    try expectApproxEqAbs(norm.length(), 1.0, 0.001);
}

test "Vec4 - Init und Math" {
    const v1 = Vec4.init(1.0, 2.0, 3.0, 4.0);
    const v2 = Vec4.init(1.0, 1.0, 1.0, 1.0);

    const sum = v1.add(v2);
    try expect(sum.x() == 2.0 and sum.w() == 5.0);
}

test "Vec4 - Dot und Length" {
    const v = Vec4.init(1.0, 1.0, 1.0, 1.0);
    try expectApproxEqAbs(v.lengthSq(), 4.0, 0.001);
    try expectApproxEqAbs(v.length(), 2.0, 0.001);

    const v2 = Vec4.init(2.0, 0.0, 0.0, 0.0);
    try expectApproxEqAbs(v.dot(v2), 2.0, 0.001);
}

test "Vec4 - Lerp (Farb-Überblendung)" {
    const colorA = Vec4.init(1.0, 0.0, 0.0, 1.0); // Rot
    const colorB = Vec4.init(0.0, 0.0, 1.0, 1.0); // Blau

    // 50% Mix = Lila
    const mix = colorA.lerp(colorB, 0.5);
    try expectApproxEqAbs(mix.x(), 0.5, 0.001);
    try expectApproxEqAbs(mix.z(), 0.5, 0.001);
    try expectApproxEqAbs(mix.w(), 1.0, 0.001);
}

test "Mat3 - Identity" {
    const id = Mat3.identity();
    const v = Vec3.init(5.0, -2.0, 3.0);

    // Matrix * Vektor muss den Vektor unverändert lassen
    const res = id.mulVec(v);
    try expect(res.x() == 5.0 and res.y() == -2.0 and res.z() == 3.0);
}

test "Mat3 - Translation (Verschiebung in 2D)" {
    const trans = Mat3.translation(10.0, -5.0);
    const point = Vec3.init(2.0, 2.0, 1.0); // 1.0 für Punkt (wird verschoben)
    const dir = Vec3.init(2.0, 2.0, 0.0); // 0.0 für Richtung (wird NICHT verschoben)

    const p_res = trans.mulVec(point);
    try expectApproxEqAbs(p_res.x(), 12.0, 0.001);
    try expectApproxEqAbs(p_res.y(), -3.0, 0.001);

    const d_res = trans.mulVec(dir);
    try expectApproxEqAbs(d_res.x(), 2.0, 0.001);
    try expectApproxEqAbs(d_res.y(), 2.0, 0.001);
}

test "Mat3 - Scaling" {
    const scale = Mat3.scaling(2.0, 0.5);
    const point = Vec3.init(10.0, 10.0, 1.0);

    const res = scale.mulVec(point);
    try expectApproxEqAbs(res.x(), 20.0, 0.001);
    try expectApproxEqAbs(res.y(), 5.0, 0.001);
}

test "Mat3 - Rotation" {
    // 90 Grad Drehung (PI / 2)
    const rot = Mat3.rotation(std.math.pi / 2.0);
    const point = Vec3.init(1.0, 0.0, 1.0); // Punkt auf der X-Achse

    const res = rot.mulVec(point);
    // Nach 90 Grad Drehung sollte der Punkt auf der Y-Achse liegen
    try expectApproxEqAbs(res.x(), 0.0, 0.001);
    try expectApproxEqAbs(res.y(), 1.0, 0.001);
}

test "Mat3 - Matrix Multiplikation (Kombination)" {
    const trans = Mat3.translation(10.0, 0.0);
    const scale = Mat3.scaling(2.0, 2.0);

    // Erst skalieren, dann verschieben
    const combined = trans.mul(scale);
    const point = Vec3.init(5.0, 0.0, 1.0);

    // 5 * 2 = 10, dann +10 = 20
    const res = combined.mulVec(point);
    try expectApproxEqAbs(res.x(), 20.0, 0.001);
}

test "Vec2 - Fuzzing / Property-Based Testing" {
    // 1. Setup für reproduzierbare Zufallszahlen
    // Wir nutzen einen festen Seed (0x12345678), damit der Test bei jedem
    // Durchlauf dieselben "zufälligen" Zahlen generiert. Wenn er fehlschlägt,
    // schlägt er also verlässlich fehl und wir können den Fehler suchen.
    var prng = std.Random.DefaultPrng.init(0x12345678);
    const random = prng.random();

    const iterations = 10_000;

    for (0..iterations) |_| {
        // 2. Generiere wilde, zufällige Vektoren (von -1000.0 bis +1000.0)
        const v1 = Vec2.init(
            (random.float(f32) - 0.5) * 2000.0,
            (random.float(f32) - 0.5) * 2000.0,
        );
        const v2 = Vec2.init(
            (random.float(f32) - 0.5) * 2000.0,
            (random.float(f32) - 0.5) * 2000.0,
        );

        // --- INVARIANTE 1: Kommutativität (v1 + v2 == v2 + v1) ---
        const sum1 = v1.add(v2);
        const sum2 = v2.add(v1);
        try testing.expectApproxEqAbs(sum1.x(), sum2.x(), 0.001);
        try testing.expectApproxEqAbs(sum1.y(), sum2.y(), 0.001);

        // --- INVARIANTE 2: Subtraktion kehrt Addition um ---
        // (v1 + v2) - v2 muss wieder v1 sein
        const restored = sum1.sub(v2);
        try testing.expectApproxEqAbs(restored.x(), v1.x(), 0.01);
        try testing.expectApproxEqAbs(restored.y(), v1.y(), 0.01);

        // --- INVARIANTE 3: Normalisierung ---
        // Die Länge eines normalisierten Vektors muss 1.0 sein.
        // (Wir überspringen den Test für Vektoren, die extrem nah an 0 sind,
        // da normalize() bei 0 den Vektor unverändert lässt).
        if (v1.length() > 0.001) {
            const norm = v1.normalize();
            try testing.expectApproxEqAbs(norm.length(), 1.0, 0.001);
        }

        // --- INVARIANTE 4: Skalarprodukt mit sich selbst ---
        try testing.expectApproxEqAbs(v1.lengthSq(), v1.dot(v1), 0.001);

        // --- INVARIANTE 5: Limit ---
        // Ein auf X limitierter Vektor darf niemals länger als X sein.
        const max_len = random.float(f32) * 100.0;
        const limited = v1.limit(max_len);
        // Wir prüfen, ob die Länge kleiner ODER ungefähr gleich dem Limit ist
        const is_valid = limited.length() <= max_len or std.math.approxEqAbs(f32, limited.length(), max_len, 0.01);
        try testing.expect(is_valid);
    }
}
