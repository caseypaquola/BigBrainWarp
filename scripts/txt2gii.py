import numpy as np
import nibabel
import sys

inName=str(sys.argv[1])
outName=str(sys.argv[2])

values = np.loadtxt(inName)
nibabel.gifti.giftiio.write(values, outName)
