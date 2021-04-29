# Import packages
import sys
import numpy

# Define input arguments
out_dir = str(sys.argv[1])
num_surf = int(sys.argv[2])
print(num_surf)

# Load top surface to learn shape
tmp=numpy.loadtxt(out_dir + "1.txt")

# load all the surfaces and construct profiles
profiles = numpy.zeros([num_surf, tmp.shape[0]])
for i in range(0,num_surf):
    profiles[i,:] = numpy.loadtxt(out_dir + str(i+1) + ".txt")

numpy.savetxt(out_dir + "profiles.txt", profiles, delimiter=',')
