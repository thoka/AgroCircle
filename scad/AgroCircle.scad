// all units in cm
h = 80;    // heigth above ground

d = 100;
w = 25;

traverse_l = 1200;
traverse_n = 3;   
traverse_nz = 12;
traverse_r = 50;      // distance outer rods
traverse_d1 = 4.3;    // thick rods
traverse_d2 = 2.1;    // thin rods 


function norm(v) = sqrt(v*v);

module tube(length,diameter,wall_width) {
	r1 = diameter/2;
	r2 = r1-2*wall_width;
	l = length;
	difference() {
		cylinder(l,r1,r1);
		translate([0,0,-1]) cylinder(l+2,r2,r2);
   }

}

module rod(l,d) {
	cylinder(l,d,d);
}

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
 
// rod with diameter d from point "from" to "to"
module rod2(from,to,d) {
   v = to - from;
   l = norm(v);
   translate(from) rotz2(v) rod(l,d);  
}


function polar(a,r=1) = [r*cos(a),r*sin(a),0];

module traverse(
   n=traverse_n,
   r=traverse_r,
   l=traverse_l,
   nz=traverse_nz,
   d1 = traverse_d1, // thick rods
   d2 = traverse_d2, // thin rods
   dz=1              // offset diagonal to orthogonal rods
   ) {

	    function a(i) = (i-.5)*360/n; 
		function p(i) = polar( a(i), r );

		rotate( [0,90])
		translate([-p(1)[0],0,0]) // set origin to center of bottom rods
        {
			for (i=[0:n-1]) {
				translate( p(i) ) rod(l,d1);
	   		}
			for (i=[0:n-1]) {
				for (j=[0:nz-1]) {
					if (j>0) rod2( p(i) + [0,0,l/nz*j] , p(i+1) + [0,0,l/nz*j] , d2 );                 
					if ( (1+j+i) % 2 == 0) 
						rod2( p(i) + [0,0,l/nz*j+dz] , p(i+1) + [0,0,l/nz*(j+1)-dz], d2 );
					if ( (1+j+i) % 2 == 1) 
						rod2( p(i) + [0,0,l/nz*(j+1)-dz] , p(i+1) + [0,0,l/nz*j+dz] , d2);
	             }

			}
		}
}

$fn = 60;
//rotate([0,90,0]) rotate([0,0,180+120]) 

tube(h,10,0.5);
translate([0,0,h]) traverse();


