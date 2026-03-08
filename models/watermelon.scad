// Watermelon Wedge - Pineapple Party model definition
// Parameters are parsed by the JS viewer; modules render in OpenSCAD

/* [Model] */
name = "watermelon";
body_type = "extrude";

/* [Body] */
body_height = 50;
body_radius = 30;
body_color = "0xff3355";
body_roughness = 0.4;
body_metalness = 0.0;

/* [Extrude] */
slice_depth = 12;
has_rind = true;
rind_thickness = 3;

/* [Bumps] */
bump_type = "seed";
bump_placement = "random";
bump_size = 1.2;
bump_rows = 5;
bumps_per_row = 4;
bump_count = 20;
bump_random_seed = 42;
bump_color = "0x222222";
bump_roughness = 0.3;
bump_metalness = 0.2;
bump_scale = [0.7, 1.2, 0.4];
bump_stagger = false;

/* [Crown] */
crown_y = 60;  // BR * 2
leaf_width = 1;
leaf_thickness = 1;
leaf_length = 1;
leaf_color = "0x2d8a2d";
leaf_roughness = 0.5;
leaf_metalness = 0.0;
leaf_placement = "crown";
leaf_rings = [];

/* [Base] */
base_r1 = 10;
base_r2 = 12;

/* [Stem] */
has_stem = false;

/* [Resolution] */
$fn = 64;

// =====================================================
// OpenSCAD rendering
// =====================================================
module watermelon_body() {
    // Half-disc watermelon slice
    linear_extrude(height = slice_depth)
    difference() {
        // Full semicircle with rind
        circle(r = body_radius + rind_thickness, $fn = 64);
        // Cut bottom half
        translate([-body_radius - rind_thickness - 1, -body_radius - rind_thickness - 1, 0])
        square([(body_radius + rind_thickness) * 2 + 2, body_radius + rind_thickness + 1]);
    }
}

module watermelon_flesh() {
    linear_extrude(height = slice_depth)
    intersection() {
        circle(r = body_radius, $fn = 64);
        translate([-(body_radius + 1), 0, 0])
        square([(body_radius + 1) * 2, body_radius + 1]);
    }
}

module seed(x, y) {
    translate([x, y, -0.5])
    scale([0.7, 1.2, 0.4])
    sphere(r = bump_size, $fn = 8);
}

module watermelon() {
    // Rind (green)
    color([0.18, 0.54, 0.18])
    translate([0, 0, body_radius])
    rotate([90, 0, 0])
    watermelon_body();

    // Flesh (red)
    color([1, 0.2, 0.33])
    translate([0, 0, body_radius])
    rotate([90, 0, 0])
    watermelon_flesh();

    // Base
    color([0.18, 0.54, 0.18])
    cylinder(h = 2, r1 = base_r2, r2 = base_r1, $fn = 32);
}

watermelon();
