// yhoseadapter.scad for splitting oxygen hoses.

// Copyright © Michael McMahon 2020. Except where otherwise specified,
// the design and code on yhoseadapter by Michael McMahon is licensed
// under the Creative Commons Attribution-ShareAlike License 4.0
// (International) (CC-BY-SA 4.0).
// https://creativecommons.org/licenses/by-sa/4.0/

// Code is based on the CC0 example CSG-modules.scad by Marius Kintel.

// The last value will overwrite prior values.
// Comment out lines with PREVIEW before making a render.

// Helper shapes that help understand the concepts that make the shape.
// Change this to false to remove the helper geometry
// TODO: Make debug conditional for preview.
debug = false;  // RENDER
debug = true;  // PREVIEW

// Global resolution
// TODO: Make the resolution conditional for preview and render.
$fs = 0.01;  // Don't generate smaller facets than 0.1 mm // RENDER
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm // PREVIEW
$fa = 1;    // Don't generate larger angles than 1 degrees // RENDER
$fa = 5;    // Don't generate larger angles than 5 degrees // PREVIEW

// Variables
EXTRAD=11;  // Exterior Radius
INTRAD=9.5;  // Interior Radius - Cannot be more than EXTRAD
// HEIGHT=25;  // Height of hole segments
CONNECT=20;  // Height of connection segment
TRANSIT=8;  // Height of transition between the intersecion point and the bottom of the Y's connection
SPLITS=2;  // 2 or 4
SCALE=EXTRAD/INTRAD;  // Controls the thickness
SPACE=(CONNECT+TRANSIT)*3.5;  // Space for debugging


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
    // Scale is 1.157894737=22/19 so that the outside of the Y should fit into the bottom of the Y.
    scale(SCALE) color("Blue") holes();
}

module intersector() {
    // TODO make the measurements in this section relational to the variables.
    BOXL=40;
    if (SPLITS==4) {
        BOXL=50;
    }
    BOXW=EXTRAD*2.5;
    color("Red") translate([0,0,-10]) cube([BOXW,BOXW,36-0.01], center=true);
    color("Red") translate([10,0,10]) rotate([0,45,0]) cube([BOXW,BOXW,BOXL], center=true);
    color("Red") translate([-10,0,10]) rotate([0,-45,0]) cube([BOXW,BOXW,BOXL], center=true);
    // 4 Way
    if (SPLITS==4) {
        color("Red") translate([0,10,10]) rotate([0,45,90]) cube([BOXW,BOXW,BOXL], center=true);
        color("Red") translate([0,-10,10]) rotate([0,-45,90]) cube([BOXW,BOXW,BOXL], center=true);
    // TODO: 4 way should allow for longer stems as the design gets crowded.
    }
}

module holeObject19() {
    color("Lime") cylinder(h=CONNECT*2, r=INTRAD, center=true);
}

module holeObject1922() {
    color("Lime") cylinder(h=TRANSIT, r1=EXTRAD, r2=INTRAD, center=true);
}

module holeObject22() {
    color("Lime") cylinder(h=CONNECT, r=EXTRAD, center=true);
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
// 4 Way
module holeE() rotate([-45,0,0]) holeObject19();
module holeF() rotate([45,0,0]) holeObject19();

module holes() {
    union() {
        p=CONNECT*7/10;
        translate([-p,0,p]) holeA();
        translate([p,0,p]) holeB();
        // 4 Way
        if (SPLITS==4) {
            translate([0,-p,p]) holeF();
            translate([0,p,p]) holeE();
        }
        translate([0,0,-(TRANSIT/2)]) holeC();
        // 0.001 is for a smooth transition
        translate([0,0,-TRANSIT-(CONNECT/2)+0.001]) holeD();
    }
}

module helpers() {
    // Inner module since it's only needed inside helpers
    module line() color("Black") cylinder(r=1, h=10, center=true);

    scale(0.5) {
        // Left
        translate([-40,0,-50-SPACE]) {
            intersected();
            translate([-SPACE,0,-SPACE]) body();
            translate([0,0,-SPACE]) intersector();
            // translate([-7.5,0,-17.5]) rotate([0,30,0]) line();
            // translate([7.5,0,-17.5]) rotate([0,-30,0]) line();
        }
        
        // Right
        translate([50,0,-50-SPACE]) {
            holes();
            translate([0,0,-SPACE]) holeA();
            translate([SPACE/2,0,-SPACE]) holeB();
            translate([SPACE,0,-SPACE]) holeC();
            translate([3*SPACE/2,0,-SPACE]) holeD();
            // 4 Way
            if (SPLITS==4) {
                translate([2*SPACE,0,-SPACE]) holeE();
                translate([5*SPACE/2,0,-SPACE]) holeF();
            }
            // translate([5,0,-17.5]) rotate([0,-20,0]) line();
            // translate([-5,0,-17.5]) rotate([0,30,0]) line();
            // translate([15,0,-17.5]) rotate([0,-45,0]) line();
        }
        // translate([-20,0,-22.5]) rotate([0,45,0]) line();
        // translate([20,0,-22.5]) rotate([0,-45,0]) line();
    }
}

echo(version=version());
