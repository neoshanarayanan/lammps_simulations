
from lammps import lammps

print("hellooooo lammps was printed!")

lmp = lammps()
lmp.close()
print(lmp.version())


