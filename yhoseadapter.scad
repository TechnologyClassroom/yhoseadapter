// yhoseadapter.scad for splitting oxygen hoses.

// Copyright © Michael McMahon 2020. Except where otherwise specified,
// the design and code on yhoseadapter by Michael McMahon is licensed
// under the Creative Commons Attribution-ShareAlike License 4.0
// (International) (CC-BY-SA 4.0).
// https://creativecommons.org/licenses/by-sa/4.0/

// Code is based on the CC0 example CSG-modules.scad by Marius Kintel.

// Change this to false to remove the helper geometry
debug = false;

// Global resolution
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm
// $fa = 1;    // Don't generate larger angles than 1 degrees // RENDER
$fa = 5;    // Don't generate larger angles than 5 degrees // PREVIEW

// Main geometry
difference() {
    intersection() {
        body();
        intersector();
    }
    holes();
}

// Helpers
if (debug) helpers();

// Core geometric primitives.
// These can be modified to create variations of the final object

module body() {
    // Scale is 22/19 so that the outside of the Y should fit into the bottom of the Y.
    scale(1.157894737) color("Blue") holes();
}

module intersector() {
    color("Red") translate([0,0,-21]) cube([30,30,70], center=true);
    color("Red") translate([0,0,10]) rotate([0,45,0]) cube([55,30,55], center=true);
}

module holeObject19() {
    color("Lime") cylinder(h=60, r=9.5, center=true);
}

module holeObject1922() {
    color("Lime") cylinder(h=30, r1=11, r2=9.5, center=true);
}

module holeObject22() {
    color("Lime") cylinder(h=30, r=11, center=true);
}

// Various modules for visualizing intermediate components

module intersected() {
    intersection() {
        body();
        intersector();
    }
}

module holeA() rotate([0,-45,0]) holeObject19();
module holeB() rotate([0,45,0]) holeObject19();
module holeC() holeObject1922();
module holeD() holeObject22();

module holes() {
    union() {
        p=21;
        translate([-p,0,p]) holeA();
        translate([p,0,p]) holeB();
        translate([0,0,-15]) holeC();
        translate([0,0,-44]) holeD();
    }
}

module helpers() {
    // Inner module since it's only needed inside helpers
    module line() color("Black") cylinder(r=1, h=10, center=true);

    // Bottom
    scale(0.5) {
        // Left
        translate([-40,0,-150]) {
            intersected();
            translate([-100,0,-100]) body();
            translate([0,0,-100]) intersector();
            // translate([-7.5,0,-17.5]) rotate([0,30,0]) line();
            // translate([7.5,0,-17.5]) rotate([0,-30,0]) line();
        }
        
        // Right
        translate([50,0,-150]) {
            holes();
            translate([0,0,-100]) holeA();
            translate([40,0,-100]) holeB();
            translate([80,0,-100]) holeC();
            translate([120,0,-100]) holeD();
            // translate([5,0,-17.5]) rotate([0,-20,0]) line();
            // translate([-5,0,-17.5]) rotate([0,30,0]) line();
            // translate([15,0,-17.5]) rotate([0,-45,0]) line();
        }
        // translate([-20,0,-22.5]) rotate([0,45,0]) line();
        // translate([20,0,-22.5]) rotate([0,-45,0]) line();
    }
}

echo(version=version());
