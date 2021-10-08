import numpy as np
import nibabel
import sys

inName=str(sys.argv[1])
outName=str(sys.argv[2])
refName=str(sys.argv[3])

# read data
values, _, _ = nibabel.freesurfer.io.read_annot(inName)

# load reference gifti
refGifti = nibabel.load(refName)

# replace data array in gifti object (needs to be np.float32)
outGifti = refGifti
outGifti.darrays[0].data = np.float32(values)

# write out
nibabel.gifti.giftiio.write(outGifti, outName)
