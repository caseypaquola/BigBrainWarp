import nibabel
import sys

inName=str(sys.argv[1])
outName=str(sys.argv[2])

values = nibabel.freesurfer.io.read_morph_data(inName)
nibabel.gifti.giftiio.write(values, outName)
