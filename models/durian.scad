// Durian - Pineapple Party model definition
// Parameters are parsed by the JS viewer; modules render in OpenSCAD

/* [Model] */
name = "durian";
body_type = "sphere";

/* [Body] */
body_height = 65;
body_radius = 28;
body_y_scale = 1.1607;  // BH / (2 * BR)
body_color = "0x8b9a3c";
body_roughness = 0.7;
body_metalness = 0.05;

/* [Bumps] */
bump_type = "cone";
bump_placement = "grid";
bump_size = 2.5;
bump_rows = 12;
bumps_per_row = 14;
bump_color = "0x6b7a2c";
bump_roughness = 0.8;
bump_metalness = 0.1;
bump_scale = [1, 1, 1];
bump_stagger = true;
cone_height = 8;
cone_radius = 2.5;
cone_random_scale = 0.4;

/* [Crown] */
crown_y = 63;  // BH - 2
leaf_width = 5;
leaf_thickness = 1.5;
leaf_length = 12;
leaf_color = "0x5a6b22";
leaf_roughness = 0.6;
leaf_metalness = 0.0;
leaf_placement = "crown";
leaf_rings = [[4, 0, 50, 0.6, 0.5, 0.6]];

/* [Stem] */
has_stem = true;
stem_r1 = 3;
stem_r2 = 5;
stem_height = 8;
stem_color = "0x7a6b3c";
stem_y = 67;  // crown_y + 4
stem_tilt = 0;

/* [Base] */
base_r1 = 10;
base_r2 = 12;

/* [Resolution] */
$fn = 64;

// =====================================================
// OpenSCAD rendering
// =====================================================
module durian_body() {
    scale([1, 1, body_height / (2 * body_radius)])
        sphere(r = body_radius);
}

module spike(row, col) {
    row_frac = (row + 0.5) / bump_rows;
    z_pos = -body_height/2 + row_frac * body_height;
    z_norm = z_pos / (body_height / 2);
    local_r = body_radius * sqrt(max(0, 1 - z_norm * z_norm));
    angle_offset = (row % 2 == 0) ? 0 : (360 / bumps_per_row / 2);
    angle = col * (360 / bumps_per_row) + angle_offset;

    if (local_r > 4) {
        sx = local_r * cos(angle);
        sy = local_r * sin(angle);
        sz = z_pos;

        // Direction from center to surface point
        translate([sx, sy, sz])
        // Orient spike outward (approximate)
        rotate([0, 0, angle])
        rotate([0, -acos(sz / sqrt(sx*sx + sy*sy + sz*sz + 0.001)), 0])
        cylinder(h = cone_height, r1 = cone_radius, r2 = 0, $fn = 6);
    }
}

module durian_spikes() {
    for (row = [0 : bump_rows - 1])
        for (col = [0 : bumps_per_row - 1])
            spike(row, col);
}

module durian() {
    translate([0, 0, body_height/2]) {
        color([0.55, 0.60, 0.24])
        union() {
            durian_body();
            durian_spikes();
        }

        // Stem
        color([0.48, 0.42, 0.24])
        translate([0, 0, body_height/2 - 2])
        cylinder(h = stem_height, r1 = stem_r2, r2 = stem_r1, $fn = 8);

        // Crown leaves
        color([0.35, 0.42, 0.13])
        translate([0, 0, body_height/2 - 2]) {
            for (i = [0 : 3]) {
                rotate([0, 0, i * 90])
                rotate([50, 0, 0])
                translate([0, 0, 6])
                scale([0.6, 0.5, 0.6])
                hull() {
                    scale([leaf_width/2, leaf_thickness/2, 1])
                        sphere(r = 1, $fn = 8);
                    translate([0, -3, leaf_length])
                    scale([leaf_width/6, leaf_thickness/3, 1])
                        sphere(r = 1, $fn = 8);
                }
            }
        }
    }

    color([0.55, 0.60, 0.24])
    cylinder(h = 2, r1 = base_r2, r2 = base_r1, $fn = 32);
}

durian();
