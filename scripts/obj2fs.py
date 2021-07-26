import numpy as np
import io_mesh as io
import nibabel
import sys

obj=str(sys.argv[1])
print(obj)
outName=str(sys.argv[2])
print(outName)

#function to read MNI obj mesh format
#adopted from doi:10.5281/zenodo.1412054, Author: Konrad Wagstyl
def read_obj(file):
    def chunks(l, n):
        """Yield successive n-sized chunks from l."""
        for i in range(0, len(l), n):
            yield l[i:i + n]
    fp=open(file,'r')
    n_vert=[]
    k=0
    Polys=[]
	# Find number of vertices and number of polygons, stored in .obj file.
	#Then extract list of all vertices in polygons
    for i, line in enumerate(fp):
         if i==0:
    	#Number of vertices
             n_vert=int(line.split()[6])
             XYZ=np.zeros([n_vert,3])
         elif i<=n_vert:
             XYZ[i-1]=list(map(float,line.split()))
         elif i>2*n_vert+5:
             if not line.strip():
                 k=1
             elif k==1:
                 Polys.extend(line.split())
    Polys=list(map(int,Polys))
    triangles=np.array(list(chunks(Polys,3)))
    return XYZ, triangles;

mesh = io.read_obj(obj)
nibabel.freesurfer.io.write_geometry(outName, mesh[0], mesh[1])
