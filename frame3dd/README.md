calculate simulations using frame3dd

install frame3dd and python-visual

change parameters in in.csv

run calculation

```bash
./calc.sh
```

find results in out.csv

Parameters
==========

	l: traverse length (mm)
	n: number of outer tubes (3 or 4)
	nz: number of segments (inner tube sections)
	d: center to center distance of outer tubes (mm)
	d1: outer tubes outer diameter (mm)
	w1: outer tubes wall thickness (mm)
	d2: inner tubes outer diameter (mm)
	w2: inner tubes wall thickness (mm)

Calculations
============

	W: traverse total weight (kg)
	d0: deformation by own weight
	d200: deformation by central force of additional 2000N

