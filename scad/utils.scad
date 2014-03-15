function norm(v) = sqrt(v*v);
function polar(a,r=1) = [r*cos(a),r*sin(a),0];

//rotates z-axis to direction v
module rotz2(v) {
   n = v/norm(v);
   roty = asin(n[2]);
   rotz = atan2(n[1],n[0]);
   rotate([0,0,rotz])  
      rotate([0,-roty,0])   
      rotate([0,90,0]) 
      child();
}


module rod(l,d) {
   cylinder(l,d/2,d/2);
}

 
// rod with diameter d from point "from" to "to"
module rod2(from,to,d) {
   v = to - from;
   l = norm(v);
   translate(from) rotz2(v) rod(l,d);  
}


module tube(length,diameter,wall_width) {
	r1 = diameter/2;
	r2 = r1-wall_width;
	l = length;
	difference() {
		cylinder(l,r1,r1);
		translate([0,0,-1]) cylinder(l+2,r2,r2);
   }
}

module tube2(from,to,diameter,wall_width) {
   r = to - from;
   l = norm(r);
   translate(from) rotz2(r) tube(l,diameter,wall_width);
}



