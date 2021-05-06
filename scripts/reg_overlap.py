# Import packages
import sys
import numpy
import nibabel as nib

# Define input arguments
wd = str(sys.argv[1])
template = str(sys.argv[2])

# load template and transformed image
img1 = nib.load(template)
img1_data = img1.get_fdata()
img2 = nib.load(wd + "trans_seg.mnc")
img2_data = img2.get_fdata()

# Calculate DICE overlap
dice = numpy.zeros(22)
for f in range(1,22):
    dice[f-1] = sum([img1_data==f] and [img2_data==f])/sum([img1_data==f] or [img2_data==f])

numpy.savetxt(wd + "reg_dice.txt", dice)
