// Banana - Pineapple Party model definition
// Parameters are parsed by the JS viewer; modules render in OpenSCAD

/* [Model] */
name = "banana";
body_type = "tube";

/* [Body] */
body_height = 80;
body_radius = 12;
body_color = "0xffe135";
body_roughness = 0.4;
body_metalness = 0.05;

/* [Tube] */
tube_bend = 18;
tube_flatten_z = 0.85;

/* [Bumps] */
bump_type = "sphere";
bump_placement = "curve";
bump_size = 1.2;
bump_rows = 10;
bumps_per_row = 8;
bump_color = "0xd4b82a";
bump_roughness = 0.5;
bump_metalness = 0.05;
bump_scale = [1, 1, 1];
bump_stagger = true;

/* [Crown] */
crown_y = 80;  // BH
leaf_width = 5;
leaf_thickness = 1.5;
leaf_length = 6;
leaf_color = "0x8b6914";
leaf_roughness = 0.6;
leaf_metalness = 0.0;
leaf_placement = "crown";
leaf_rings = [];

/* [Stem] */
has_stem = true;
stem_r1 = 1.5;
stem_r2 = 2.5;
stem_height = 6;
stem_color = "0x8b6914";
stem_y = 80;
stem_tilt = 0;

/* [Nub] */
has_nub = true;
nub_radius = 2;

/* [Base] */
base_r1 = 6;
base_r2 = 8;

/* [Resolution] */
$fn = 64;

// =====================================================
// OpenSCAD rendering
// =====================================================
module banana_body() {
    // Banana as a curved, tapered cylinder
    steps = 40;
    for (i = [0 : steps - 1]) {
        t0 = i / steps;
        t1 = (i + 1) / steps;
        y0 = t0 * body_height;
        y1 = t1 * body_height;
        x0 = sin(t0 * 180) * tube_bend;
        x1 = sin(t1 * 180) * tube_bend;
        taper0 = sin(t0 * 180) * 0.7 + 0.3;
        taper1 = sin(t1 * 180) * 0.7 + 0.3;
        r0 = body_radius * taper0;
        r1 = body_radius * taper1;

        hull() {
            translate([x0, 0, y0])
            scale([1, tube_flatten_z, 1])
            sphere(r = r0, $fn = 16);

            translate([x1, 0, y1])
            scale([1, tube_flatten_z, 1])
            sphere(r = r1, $fn = 16);
        }
    }
}

module banana() {
    color([1, 0.88, 0.21])
    banana_body();

    // Stem
    color([0.55, 0.41, 0.08])
    translate([sin(180) * tube_bend, 0, body_height])
    cylinder(h = stem_height, r1 = stem_r2, r2 = stem_r1, $fn = 8);

    // Bottom nub
    color([0.55, 0.41, 0.08])
    translate([0, 0, 0])
    sphere(r = nub_radius, $fn = 8);

    // Base
    color([1, 0.88, 0.21])
    cylinder(h = 2, r1 = base_r2, r2 = base_r1, $fn = 32);
}

banana();
