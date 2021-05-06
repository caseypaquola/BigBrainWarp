# Import packages
import sys
import numpy

# Define input arguments
wd = str(sys.argv[1])

# Load coordinates and calculate distance
p1 = numpy.loadtxt(wd + "trans_coords.txt")
p2 = numpy.loadtxt(wd + "set_coords.txt")
dist = numpy.zeros(32)
for f in range(0,32):
    dist[f] = numpy.linalg.norm(p1[f]-p2[f])

numpy.savetxt(wd + "af_dist.txt", dist)
