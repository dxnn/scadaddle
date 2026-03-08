// Dragonfruit - Pineapple Party model definition
// Parameters are parsed by the JS viewer; modules render in OpenSCAD

/* [Model] */
name = "dragonfruit";
body_type = "sphere";

/* [Body] */
body_height = 60;
body_radius = 22;
body_y_scale = 1.3636;  // BH / (2 * BR)
body_color = "0xdd1177";
body_roughness = 0.45;
body_metalness = 0.05;

/* [Bumps] */
bump_type = "sphere";
bump_placement = "grid";
bump_size = 1.5;
bump_rows = 8;
bumps_per_row = 10;
bump_color = "0xee3388";
bump_roughness = 0.5;
bump_metalness = 0.05;
bump_scale = [1, 1, 1];
bump_stagger = true;

/* [Crown] */
crown_y = 30;  // BH / 2
leaf_width = 6;
leaf_thickness = 2;
leaf_length = 14;
leaf_color = "0x44bb44";
leaf_roughness = 0.4;
leaf_metalness = 0.0;
leaf_placement = "surface";

/* [Surface Scales] */
scale_rows = 6;
scales_per_row = 8;
scale_base_tilt = 55;
scale_tilt_per_row = 3;
scale_sx = 0.6;
scale_sy_min = 0.6;
scale_sy_max = 0.9;
scale_sz = 0.6;

/* [Tuft] */
tuft_count = 5;
tuft_tilt = 15;
tuft_scale = [0.5, 0.7, 0.5];
tuft_y_offset = -5;  // relative to BH/2

/* [Base] */
base_r1 = 9;
base_r2 = 11;

/* [Stem] */
has_stem = false;

/* [Resolution] */
$fn = 64;

// =====================================================
// OpenSCAD rendering
// =====================================================
module dragonfruit_body() {
    scale([1, 1, body_height / (2 * body_radius)])
        sphere(r = body_radius);
}

module scale_leaf(angle, tilt, sx, sy, sz) {
    rotate([0, 0, angle])
    rotate([tilt, 0, 0])
    scale([sx, sy, sz])
    hull() {
        scale([leaf_width/2, leaf_thickness/2, 1])
            sphere(r = 1, $fn = 8);
        translate([0, -3, leaf_length])
        scale([leaf_width/6, leaf_thickness/3, 1])
            sphere(r = 1, $fn = 8);
    }
}

module dragonfruit() {
    translate([0, 0, body_height/2]) {
        color([0.87, 0.07, 0.47])
        dragonfruit_body();

        // Scale leaves on surface
        color([0.27, 0.73, 0.27])
        for (row = [0 : scale_rows - 1]) {
            row_frac = (row + 0.5) / scale_rows;
            z_pos = -body_height/2 + row_frac * body_height;
            z_norm = z_pos / (body_height / 2);
            local_r = body_radius * sqrt(max(0, 1 - z_norm * z_norm));
            if (local_r > 4) {
                for (col = [0 : scales_per_row - 1]) {
                    angle_offset = (row % 2 == 0) ? 0 : (360 / scales_per_row / 2);
                    angle = col * (360 / scales_per_row) + angle_offset;
                    translate([local_r * cos(angle), local_r * sin(angle), z_pos])
                    scale_leaf(angle, scale_base_tilt + row * scale_tilt_per_row,
                        scale_sx, scale_sy_min + row_frac * (scale_sy_max - scale_sy_min), scale_sz);
                }
            }
        }

        // Top tuft
        color([0.27, 0.73, 0.27])
        for (i = [0 : tuft_count - 1])
            translate([0, 0, body_height/2 + tuft_y_offset])
            scale_leaf(i * (360 / tuft_count), tuft_tilt,
                tuft_scale[0], tuft_scale[1], tuft_scale[2]);
    }

    color([0.87, 0.07, 0.47])
    cylinder(h = 2, r1 = base_r2, r2 = base_r1, $fn = 32);
}

dragonfruit();
