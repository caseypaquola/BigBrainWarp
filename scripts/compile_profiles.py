# Import packages
import sys
import numpy as np

# Define input arguments
out_name = string(sys.argv[1])
num_surf = float(sys.argv[2])

# Load top surface to learn shape
tmp=numpy.loadtxt(out_name + ".1.txt")

# load all the surfaces and construct profiles
profiles = np.zeros(num_surf, tmp.shape[0])
for i in range(1,num_surf):
    profiles[i,:] = numpy.loadtxt(out_name + "." + str(i) + ".txt")

numpy.savetxt(out_name + ".profiles.txt", profiles)