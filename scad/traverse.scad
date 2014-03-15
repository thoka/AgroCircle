l = 1200;
n = 3;   
nz = 12;
r = 40 ;     // distance outer rods
d1 = 4.3;    // thick tubes outer diameter
w1 = 0.26;   // thick tubes wall thickness
d2 = 2.1;    // thin tubes outer diameter
w2 = 0.2;    // thick tubes wall thickness

use <utils.scad>;

module traverse(
   n=n, r=r, l=l,
   nz=nz,
   d1 = d1,  w1 = w1, // thick tube
   d2 = d2,  w2 = w2,  // thin rods
   dz=1               // offset diagonal to orthogonal rods
   ) {

    function a(i) = (i-.5)*360/n; 
	function p(i) = polar( a(i), r );

	rotate( [0,90])
	translate([-p(1)[0],0,0]) // set origin to center of bottom rods
		{
		difference() {
			for (i=[0:n-1]) {
				translate( p(i) ) tube(l,d1,w1);
				for (j=[0:nz-1]) {
					if (j>0) tube2( p(i) + [0,0,l/nz*j] , p(i+1) + [0,0,l/nz*j] , d2,w2 );                 
					if ( (1+j+i) % 2 == 0) 
						tube2( p(i) + [0,0,l/nz*j+dz] , p(i+1) + [0,0,l/nz*(j+1)-dz], d2,w2 );
					if ( (1+j+i) % 2 == 1) 
						tube2( p(i) + [0,0,l/nz*(j+1)-dz] , p(i+1) + [0,0,l/nz*j+dz] , d2,w2 );
	             }

			}
			// cut inner parts of thin tubes
		 	for (i=[0:n-1]) {
				translate( p(i) ) rod(l,d1-2*w1);
	   		}				
		
		}
	}
}

$fn = 60;
traverse();