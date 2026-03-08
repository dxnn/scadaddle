// Pineapple - Pineapple Party model definition
// Parameters are parsed by the JS viewer; modules render in OpenSCAD

/* [Model] */
name = "pineapple";
body_type = "sphere";

/* [Body] */
body_height = 70;
body_radius = 25;
body_y_scale = 1.4;  // BH / (2 * BR)
body_color = "0xdaa520";
body_roughness = 0.6;
body_metalness = 0.1;

/* [Bumps] */
bump_type = "sphere";
bump_placement = "grid";
bump_size = 3.5;
bump_rows = 10;
bumps_per_row = 14;
bump_color = "0xc8951a";
bump_roughness = 0.7;
bump_metalness = 0.05;
bump_scale = [1, 1.3, 1];
bump_stagger = true;

/* [Crown] */
crown_y = 67;  // BH - 3
leaf_width = 8;
leaf_thickness = 2;
leaf_length = 40;
leaf_color = "0x2e8b2e";
leaf_roughness = 0.5;
leaf_metalness = 0.0;
leaf_placement = "crown";
leaf_rings = [[6, 0, 8, 1, 1, 1], [12, 15, 22, 1, 1, 1], [12, 0, 40, 1.1, 0.85, 1.1]];

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
module pineapple_body() {
    scale([1, 1, body_height / (2 * body_radius)])
        sphere(r = body_radius);
}

module bump(row, col) {
    row_frac = (row + 0.5) / bump_rows;
    z_pos = -body_height/2 + row_frac * body_height;
    z_norm = z_pos / (body_height / 2);
    local_r = body_radius * sqrt(max(0, 1 - z_norm * z_norm));
    angle_offset = (row % 2 == 0) ? 0 : (360 / bumps_per_row / 2);
    angle = col * (360 / bumps_per_row) + angle_offset;

    if (local_r > bump_size) {
        translate([
            local_r * cos(angle),
            local_r * sin(angle),
            z_pos
        ])
        scale([1, 1, 1.3])
        sphere(r = bump_size, $fn = 12);
    }
}

module pineapple_bumps() {
    for (row = [0 : bump_rows - 1])
        for (col = [0 : bumps_per_row - 1])
            bump(row, col);
}

module leaf(angle, tilt, curl) {
    rotate([0, 0, angle])
    rotate([tilt, 0, 0])
    hull() {
        scale([leaf_width/2, leaf_thickness/2, 1])
            sphere(r = 1, $fn = 8);
        translate([0, -curl, leaf_length])
        scale([leaf_width/6, leaf_thickness/3, 1])
            sphere(r = 1, $fn = 8);
    }
}

module crown() {
    translate([0, 0, body_height/2 - 3]) {
        for (i = [0 : 5])
            leaf(i * 60, 8, 3);
        for (i = [0 : 11])
            leaf(i * 30 + 15, 22, 5);
        for (i = [0 : 11])
            scale([1.1, 1.1, 0.85])
            leaf(i * 30, 40, 8);
    }
}

module pineapple() {
    translate([0, 0, body_height/2]) {
        color("gold")
        union() {
            pineapple_body();
            pineapple_bumps();
        }
        color("green")
        crown();
    }
    color("gold")
    cylinder(h = 2, r1 = base_r2, r2 = base_r1, $fn = 32);
}

pineapple();
