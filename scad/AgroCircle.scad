h = 50;

d = 100;
w = 10;

traverse_l = 200;
traverse_n = 3;
traverse_r = 10;


function norm(v) = sqrt(v*v);

v1 = [1,0,0];
v2 = 0.5*[0.5,0,0];
c = sqrt(v2 * v2);

echo( c );
echo( norm(v2) );

module tube(length,diameter,wall_width) {
	r1 = diameter/2;
	r2 = r1-2*wall_width;
	l = length;
	difference() {
		cylinder(l,r1,r1);
		translate([0,0,-1]) cylinder(l+2,r2,r2);
   }

}

module a() {
	projection(cut=true)
	rotate([0,90,0])
	scale(0.05) union() { 
		color("red") tube(h,d/2,w);	
		tube(h,d,w);
	
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

module traverse(n=traverse_n,r=10,l=traverse_l,nz=5,dz=1) {

	    function a(i) = (i-.5)*360/n; 
		function p(i) = polar( a(i), r );

		rotate( [0,90])
		translate([-p(1)[0],0,0]) // set origin to center of bottom rods
        {
			for (i=[0:n-1]) {
			translate( p(i) ) rod(l,2);
	   		}
			for (i=[0:n-1]) {
				for (j=[0:nz-1]) {
					if (j>0) rod2( p(i) + [0,0,l/nz*j] , p(i+1) + [0,0,l/nz*j] );                 
					if ( (1+j+i) % 2 == 0) 
						rod2( p(i) + [0,0,l/nz*j+dz] , p(i+1) + [0,0,l/nz*(j+1)-dz] );
					if ( (1+j+i) % 2 == 1) 
						rod2( p(i) + [0,0,l/nz*(j+1)-dz] , p(i+1) + [0,0,l/nz*j+dz] );
	             }

			}
		}
}

$fn = 60;
//rotate([0,90,0]) rotate([0,0,180+120]) 

tube(50,10,0.5);
translate([0,0,h]) traverse();

