from __future__ import division
from visual import *
from math import sin,cos,pi

X = (1,0,0)
Z = (0,0,1)

def d(alpha): 
	return pi/2+alpha/180*pi

def polarZ(alpha,r=1.0):
	d_ = d(alpha)
	return (r*cos(d_),r*sin(d_),0)

def polarX(alpha,r=1.0,x=0):
	d_ = d(alpha)
	return (x,r*cos(d_),r*sin(d_))

points = [] 
P = {}
C = []


def connect(a,b,t):
	pa = P[a]
	pb = P[b]
 	d,w = t
	#cylinder(pos = pa, axis = pb-pa, radius = d/2)
	C.append( { 
		"from": pa.count,
		"to"  : pb.count,
		"tube": t
	})
	#print C

def traverse(n=3,nz=12,r=400.0,l=12000.0,t1=[40,2],t2=[20,2]):
	global count
	r_ = r/2
	l_ = l/nz
	for j in range(0,nz+1):
		for i in range(0,n):
			p = vector(polarX(360/n*i,r_,j*l_))
			p.count = len(points)
			points.append(p)
			P[(i,j)] = p
			# print p
			#sphere(pos=P[(i,j)],radius=30)

	for i in range(0,n):
		for j in range(0,nz+1):
			if j<nz:
				connect((i,j),(i,j+1),t1)
				if (i+j) % 2 == 0:
					connect((i , j),( (i+1)%n ,j+1),t2)
				else:
					connect(((i+1)%n , j),( i ,j+1),t2)
										
			connect((i,j),( (i+1)%n , j ),t2)
			

print "Template Input Data file for Frame3DD - 3D structural frame analysis (N,mm,ton)"
traverse()

print "# node data ..."
print "%i # number of nodes" % len(points)
for p in points:
	print "%i %f %f %f 10" % (p.count+1, p[0],p[1],p[2])

print "# reaction data ..."
print "4 # number of nodes" 
print "2 1 1 1 0 0 0"
print "3 1 1 1 0 0 0"
print "%i 0 0 1 0 0 0" % (len(points))
print "%i 0 0 1 0 0 0" % (len(points)-1)

print "# frame element data ..."
print "%i # number of connections" % len(C)

for i,c in enumerate(C):

	d,w = c["tube"]
	Ro = d/2
	Ri = Ro-w
	Ax = pi * (Ro**2-Ri**2)
	Asy = Ax / ( 0.54414 + 2.97294*(Ri/Ro) - 1.51899*(Ri/Ro)**2)
	Asz = Asy
	Jx = (1/2)*pi *(Ro**4 - Ri**4)
	Iy = (1/2)*Jx
	Iz = Iy
	E = 200000
	G = 79300
	roll = 0 # TODO: toka: dont understand this
	density = 7.85e-9


	print "%i  %i %i  %f %f %f  %f %f %f   %f %f %f %e" % (
		i+1, 
		c["from"]+1,
		c["to"]+1,
		Ax, Asy, Asz,
		Jx, Iy, Iz,
		E, G, roll, density
		)

print "1 # shear"
print "1 # geom"
print "1 # static exageration factor" 
print "1 # x-axis increment "

print """
# load data ...

2                        # number of static load cases,  1..30

# Begin Static Load Case 1  

# gravitational acceleration for self-weight loading, mm/s^2 (global)
#   gX         gY         gZ
#   mm/s^2     mm/s^2     mm/s^2
    0 0 9810    

0                   # number of loaded nodes (global)
#.node  X-load   Y-load   Z-load   X-mom     Y-mom     Z-mom
#         N        N        N        N.mm      N.mm      N.mm
#  N[1]    Fx[1]    Fy[1]    Fz[1]    Mxx[1]    Myy[1]    Mzz[1]

0                   # number of uniformly-distributed element loads (local)
#.elmnt  X-load   Y-load   Z-load   uniform member loads in member coordinates
#         N/mm     N/mm     N/mm
# EL[1]    Ux[1]    Uy[1]    Uz[1]

0                   # number of trapezoidally-distributed element loads (local)
# EL[1]  xx1[1]   xx2[2]   wx1[1]   wx2[1]  # locations and loads - local x-axis
#        xy1[1]   xy2[2]   wy1[1]   wy2[1]  # locations and loads - local y-axis
#        xz1[1]   xz2[2]   wz1[1]   wz2[1]  # locations and loads - local z-axis

0                   # number of concentrated interior point loads (local)
#.elmnt  X-load   Y-load   Z-load    x-loc'n  point loads in member coordinates 
# EL[1]    Px[1]    Py[1]    Pz[1]    x[1]      

0                   # number of frame elements with temperature changes (local)
#.elmnt   coef.  y-depth  z-depth  deltaTy+  deltaTy-  deltaTz+  deltaTz-
#         /deg.C  mm       mm       deg.C     deg.C     deg.C     deg.C
# EL[1]    a[1]    hy[1]    hz[1]    Ty+[1]    Ty-[1]    Tz+[1]    Tz-[1] 


0                   # number of prescribed displacements nD<=nR (global)
#.node   X-displ  Y-displ  Z-displ  X-rot'n   Y-rot'n   Z-rot'n
#         mm       mm       mm       radian    radian    radian
#  N[1]    Dx[1]    Dy[1]    Dz[3]    Dxx[1]    Dyy[1]    Dzz[1]

# Begin Static Load Case 2  

# gravitational acceleration for self-weight loading, mm/s^2 (global)
#   gX         gY         gZ
#   mm/s^2     mm/s^2     mm/s^2
    0 0 9810    

1                   # number of loaded nodes (global)
#.node  X-load   Y-load   Z-load   X-mom     Y-mom     Z-mom
#         N        N        N        N.mm      N.mm      N.mm
#  N[1]    Fx[1]    Fy[1]    Fz[1]    Mxx[1]    Myy[1]    Mzz[1]
%i  0  0  2000 0 0 0

0                   # number of uniformly-distributed element loads (local)
#.elmnt  X-load   Y-load   Z-load   uniform member loads in member coordinates
#         N/mm     N/mm     N/mm
# EL[1]    Ux[1]    Uy[1]    Uz[1]

0                   # number of trapezoidally-distributed element loads (local)
# EL[1]  xx1[1]   xx2[2]   wx1[1]   wx2[1]  # locations and loads - local x-axis
#        xy1[1]   xy2[2]   wy1[1]   wy2[1]  # locations and loads - local y-axis
#        xz1[1]   xz2[2]   wz1[1]   wz2[1]  # locations and loads - local z-axis

0                   # number of concentrated interior point loads (local)
#.elmnt  X-load   Y-load   Z-load    x-loc'n  point loads in member coordinates 
# EL[1]    Px[1]    Py[1]    Pz[1]    x[1]      

0                   # number of frame elements with temperature changes (local)
#.elmnt   coef.  y-depth  z-depth  deltaTy+  deltaTy-  deltaTz+  deltaTz-
#         /deg.C  mm       mm       deg.C     deg.C     deg.C     deg.C
# EL[1]    a[1]    hy[1]    hz[1]    Ty+[1]    Ty-[1]    Tz+[1]    Tz-[1] 


0                   # number of prescribed displacements nD<=nR (global)
#.node   X-displ  Y-displ  Z-displ  X-rot'n   Y-rot'n   Z-rot'n
#         mm       mm       mm       radian    radian    radian
#  N[1]    Dx[1]    Dy[1]    Dz[3]    Dxx[1]    Dyy[1]    Dzz[1]


# dynamic analysis data ...
0      # number of desired dynamic modes 
""" % ( int(len(points)/2) )

