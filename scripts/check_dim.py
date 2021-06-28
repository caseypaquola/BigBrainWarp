import nibabel as nib
import sys

# load data and print the dimensions
input=str(sys.argv[1])
data = nib.load(input)
print(data.darrays[0].data.shape[0])
