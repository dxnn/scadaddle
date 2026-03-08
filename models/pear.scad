// Pear - Pineapple Party model definition
// Parameters are parsed by the JS viewer; modules render in OpenSCAD

/* [Model] */
name = "pear";
body_type = "lathe";

/* [Body] */
body_height = 65;
body_radius = 22;
body_color = "0xb5c327";
body_roughness = 0.55;
body_metalness = 0.05;

/* [Lathe Profile] */
profile_center = 0.3;
profile_width = 0.05;
profile_taper_scale = 0.35;

/* [Bumps] */
bump_type = "sphere";
bump_placement = "grid";
bump_size = 1.8;
bump_rows = 12;
bumps_per_row = 12;
bump_color = "0x8a9420";
bump_roughness = 0.65;
bump_metalness = 0.05;
bump_scale = [1, 1, 1];
bump_stagger = true;

/* [Crown] */
crown_y = 64;  // BH - 1
leaf_width = 5;
leaf_thickness = 1.5;
leaf_length = 18;
leaf_color = "0x1a5c1a";
leaf_roughness = 0.5;
leaf_metalness = 0.0;
leaf_placement = "crown";
leaf_rings = [[1, 30, 35, 1, 1, 1], [1, 210, 40, 0.8, 0.9, 0.8]];

/* [Base] */
base_r1 = 8;
base_r2 = 10;

/* [Stem] */
has_stem = true;
stem_r1 = 0.8;
stem_r2 = 1.2;
stem_height = 8;
stem_color = "0x5c3a1e";
stem_y = 67;  // BH + 2
stem_tilt = 0.15;

/* [Resolution] */
$fn = 64;

// =====================================================
// OpenSCAD rendering
// =====================================================
module pear_profile_radius(t) {
    // Returns radius at fraction t along height
    bottom = exp(-pow(t - profile_center, 2) / profile_width) * body_radius;
    taper = body_radius * profile_taper_scale * (1 - t) * sqrt(max(0, t));
    r = max(bottom, taper);
    r2 = (t > 0.85) ? r * (1 - t) / 0.15 : r;
    r3 = (t < 0.03) ? r2 * t / 0.03 : r2;
}

module pear_body() {
    steps = 20;
    pts = [for (i = [0:steps]) let(
        t = i / steps,
        bottom = exp(-pow(t - 0.3, 2) / 0.05) * body_radius,
        taper = body_radius * 0.35 * (1 - t) * sqrt(max(0, t)),
        r0 = max(bottom, taper),
        r1 = (t > 0.85) ? r0 * (1 - t) / 0.15 : r0,
        r = (t < 0.03) ? r1 * t / 0.03 : r1
    ) [max(r, 0), t * body_height]];

    rotate_extrude($fn = 48)
        polygon(concat([[0, 0]], pts, [[0, body_height]]));
}

module pear() {
    // Body
    color([0.71, 0.76, 0.15])
    pear_body();

    // Stem
    color([0.36, 0.23, 0.12])
    translate([0, 0, body_height + 2])
    rotate([0, stem_tilt * 180 / 3.14159, 0])
    cylinder(h = stem_height, r1 = stem_r2, r2 = stem_r1, $fn = 8);

    // Base
    color([0.71, 0.76, 0.15])
    cylinder(h = 2, r1 = base_r2, r2 = base_r1, $fn = 32);
}

pear();
