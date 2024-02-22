// Parameters for the base and the helical cutout
base_height = 40; // Height of the joystick base
base_radius = 20; // Radius of the joystick base
helix_turns = 5; // Number of turns in the helix
helix_radius = base_radius - 5; // Radius for the helix, slightly smaller than the base radius
helix_thread_thickness = 2; // Thickness of the helix thread

module helical_cutaway(height, turns, outer_radius, inner_radius, thread_thickness) {
    helix_angle = 360 * turns; // Total number of degrees to rotate over the height
    slices = 100 * turns; // Number of slices, more slices for a smoother helix

    for (i = [0:slices]) {
        h = height * i / slices;
        angle = helix_angle * i / slices;

        // Outer cylinder (helix thread)
        translate([0, 0, h])
        rotate([0, 0, angle])
        translate([outer_radius, 0, 0])
        cylinder(h = height/slices + 0.1, d = thread_thickness, center = true); // Add a slight overlap to ensure clean cut
        
        // Inner cylinder to make the thread only 1mm deep
        translate([0, 0, h])
        rotate([0, 0, angle])
        translate([inner_radius, 0, 0])
        cylinder(h = height/slices + 0.2, d = thread_thickness - 2, center = true); // Subtract to create the thread depth
    }
}

module joystick_base() {

$fn=100; // Setting high fragment number for smooth curves

// Convert inches to mm (since OpenSCAD uses mm by default)
inch_to_mm = 25.4;
shaft_length = 2 * inch_to_mm; // 2 inches converted to mm
shaft_outer_diameter = 30; // Outer diameter of the shaft
shaft_inner_diameter = shaft_outer_diameter - 4; // Assuming a 2mm wall thickness for the shaft
hole_diameter = 6.2; // Central hole diameter
base_outer_diameter = 80; // Outer diameter of the base
base_inner_diameter = base_outer_diameter - 4; // Assuming a 2mm wall thickness for the base
base_height = 15; // Height for the base
rounded_top_height = shaft_outer_diameter / 1; // Height of the rounded top
    // Parameters for the helical cutout
    helix_turns = 7; // Number of turns in the helix
    helix_thread_thickness = 6; // Thickness of the helix thread

    // Create the shaft with the helical cutaway
    difference() {
        cylinder(h = shaft_length, d = shaft_outer_diameter, center = true);
        translate([0, 0, -shaft_length/2])
            cylinder(h = shaft_length * 2, d = hole_diameter, center = true); // Make the hole through the entire length
        // Helical cutaway
         helical_cutaway(
            shaft_length, // height of the helix
            helix_turns, // number of turns in the helix
            (shaft_outer_diameter / 2), // outer radius for the helix, same as the shaft radius
            (shaft_outer_diameter / 2) - .5, // inner radius for the helix, 1mm less than the shaft radius
            helix_thread_thickness // thickness of the helix thread
        );
    }

// Create the hollow conical base
difference() {
    translate([0, 0, -shaft_length/2 - base_height/2])
        cylinder(h = base_height, d1 = base_outer_diameter, d2 = shaft_outer_diameter, center = true);
    translate([0, 0, -shaft_length/2 - base_height/2])
        cylinder(h = base_height + 1, d1 = base_inner_diameter, d2 = shaft_inner_diameter - 2, center = true); // 1mm extra height for clean subtraction
}

// Create the rounded top for the knob
difference() {
    translate([0, 0, shaft_length/2])
        sphere(d = shaft_outer_diameter);
    translate([0, 0, shaft_length/2 + rounded_top_height])
        cylinder(h = rounded_top_height, d1 = shaft_outer_diameter, d2 = 0, center = true);
}


}



module xiao_pin_holder() {
    $fn=100; // Setting high fragment number for smooth curves

    // Pin dimensions
    pin_height = 1.5; // The height of the plastic pins
    pin_diameter = 1.1; // The diameter of the pins to fit into the Xiao's holes
    pin_spacing = 2.54; // The distance between the centers of the pins
    num_pins = 7; // Number of pins in a row
    row_spacing = 17; // The distance between the centers of the two rows

    // Pin positions
    pin_row_1_y = -row_spacing / 2;
    pin_row_2_y = row_spacing / 2;

    // Distance from the edge of the board to the first pin (half the difference of total length and length covered by pins)
    edge_to_first_pin = (21 - (num_pins - 1) * pin_spacing) / 2;

    // Create two rows of pins
    for (i = [0 : num_pins - 1]) {
        translate([(i * pin_spacing) + edge_to_first_pin, pin_row_1_y, pin_height / 2])
            cylinder(h = pin_height, d = pin_diameter, center=true);
        
        translate([(i * pin_spacing) + edge_to_first_pin, pin_row_2_y, pin_height / 2])
            cylinder(h = pin_height, d = pin_diameter, center=true);
    }
}


module n_shaped_cover() {
    // Dimensions
    cover_length = 21 + 2;  // Total length of the cover
    cover_width = 17.8 + 2;  // Total width of the cover
    cover_thickness = 2;  // Thickness of the top part of the cover
    lip_height = 5;  // Height of the lips on the sides
    lip_thickness = 1;  // Thickness of the lips on the sides
    
    // Main top part
    translate([0, 0, lip_height])
    cube([cover_length, cover_width, cover_thickness], center=true);
    
    // Side lips
    translate([-cover_length/2 + lip_thickness/2, 0, lip_height/2])
    cube([lip_thickness, cover_width, lip_height], center=true);
    
    translate([cover_length/2 - lip_thickness/2, 0, lip_height/2])
    cube([lip_thickness, cover_width, lip_height], center=true);
}

// To place the pin holder underneath the conical part of the joystick, 
// you will need to translate and rotate the pin holder appropriately.
// Here's an example call to place it underneath:

joystick_base(); // Render the joystick base
conical_base_center_x = -35;
conical_base_center_y = 0;
conical_base_height = 40;
pin_height = 1;
cover_thickness = 2;
lip_height=3;
translate([conical_base_center_x, conical_base_center_y, -conical_base_height - pin_height]) 
rotate([0, -30, 0]) // Flip the pin holder upside down
xiao_pin_holder();


