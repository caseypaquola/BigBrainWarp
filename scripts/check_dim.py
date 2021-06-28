import nibabel as nib
import sys

# load data and print the dimensions
input=str(sys.argv[1])
data=nib.load(input)

# get number of vertices and round to nearest thousand
vert_k=round(data.darrays[0].data.shape[0], -3) 
print(str.strip(str(vert_k),"0"))
