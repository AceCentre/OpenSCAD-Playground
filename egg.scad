// Parameters
length = 70; // Oval length in mm
width = 40; // Oval width in mm
domeHeight = 15; // Height of the dome in mm
baseHeight = 1; // Height of the base in mm, adjust if needed

// Function to create a half-sphere
module halfSphere(r) {
    difference() {
        sphere(r, $fn=100);
        translate([0, 0, -r]) cube([2*r, 2*r, 2*r], center=true);
    }
}

// Create the oval base$
module ovalBase() {
    scale([length/20, width/20, 2])
    cylinder(h = baseHeight, r=10, center=true, $fn=100);
}

// Create the dome by scaling a half-sphere
module dome() {
    translate([0, 0, 0.5]) // Position the dome on top of the base
    scale([length/40, width/40, domeHeight/20])
    halfSphere(20);
}

// Combine the base and the dome
module halfEgg() {
    ovalBase(); // Create the base
    dome(); // Create and position the dome
}

// Render the half-egg shape
halfEgg();
