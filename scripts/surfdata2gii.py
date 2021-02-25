import numpy as np
import nibabel
import sys

print('assigning arguments')
dataFile=str(sys.argv[1])
outName=str(sys.argv[2])
hemi=str(sys.argv[3])
template=str(sys.argv[4])

# load surface data
x = dataFile.split(".")
ext = x[-1]
if ext == 'annot':
    surfData = nibabel.freesurfer.io.read_annot(dataFile)
elif ext == 'txt':
    surfData = np.loadtxt(dataFile)
elif ext == 'mgh':
    surfData = nibabel.freesurfer.mghformat.read(dataFile)
else:
    print("incompatible datatype")
    sys.exit()

# load and replace data in a gifti template
giiTemp = nibabel.load(template)
#outGii = giiTemp
#outGii.darrays[0].data = np.float32(surfData)
nibabel.save(outGii, outName+'_'+hemi+'.shape.gii')

from nilearn.image import new_img_like
outGii = new_image_like(giiTemp, np.float32(surfData))
nibabel.save(outGii, outName+'_'+hemi+'.shape.gii')
