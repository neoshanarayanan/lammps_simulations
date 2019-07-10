#!/usr/bin/env/python -i


from __future__ import print_function

import sys

from lammps import lammps
lmp = lammps() # create lammps object

infile = "~/mylammps/examples/colloid/in.colloid"
lmp.file(infile) # run lammps input file

print("done")
