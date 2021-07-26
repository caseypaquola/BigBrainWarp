import nibabel as nib
import sys
import numpy as np

# load data and print the dimensions
inData=str(sys.argv[1])
extension=str(sys.argv[2])

# load data
if "txt" in extension:
    data=np.loadtxt(inData)
    vert_k=round(data.shape[0], -3)
elif "curv" in extension:
    data=nib.freesurfer.io.read_morph_data(inData)
    vert_k=round(data.shape[0], -3)
else:
    data=nib.load(inData)
    vert_k=round(data.darrays[0].data.shape[0], -3)

# get number of vertices and round to nearest thousand
print(str.strip(str(vert_k),"0"))
