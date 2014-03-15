// all units in cm
h = 80;    // heigth above ground

use <utils.scad>;
use <traverse.scad>;

$fn = 60;
//rotate([0,90,0]) rotate([0,0,180+120]) 

tube(h,10,0.5);
translate([0,0,h]) traverse();


