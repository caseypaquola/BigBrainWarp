import numpy as np
import nibabel
import sys

txt=str(sys.argv[1])
outName=str(sys.argv[2])

values = np.loadtxt(txt)
nibabel.freesurfer.io.write_geometry(outName, values)
