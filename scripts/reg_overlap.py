# Import packages
import sys
import numpy
import nibabel as nib

# Define input arguments
trans_seg = str(sys.argv[1])
comp_seg = str(sys.argv[2])
wd = str(sys.argv[3])

# load template and transformed image
img1 = nib.load(trans_seg)
img1_data = img1.get_fdata()
img2 = nib.load(comp_seg)
img2_data = img2.get_fdata()

# Calculate DICE overlap
dice = numpy.zeros(21)
for f in range(1,22):
    dice[f-1] = numpy.sum(img2_data[img1_data==f]==f)*2.0 / (numpy.sum([img1_data==f]) + numpy.sum([img2_data==f]))

numpy.savetxt(wd + "reg_dice.txt", dice)
