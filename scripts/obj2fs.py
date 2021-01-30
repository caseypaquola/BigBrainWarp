import numpy as np
import io_mesh as io
import os
import nibabel
import sys

obj=str(sys.argv[1])
print(obj)
outName=str(sys.argv[2])
print(outName)

mesh = io.read_obj(obj)
nibabel.freesurfer.io.write_geometry(outName, mesh[0], mesh[1])
