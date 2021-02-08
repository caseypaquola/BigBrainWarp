print('importing libraries')
import numpy as np
import nibabel
import scipy.io as io
import sys

print('assigning arguments')
lhData=str(sys.argv[1])
rhData=str(sys.argv[2])
approach=str(sys.argv[3])
inSurf=str(sys.argv[4])
outName=str(sys.argv[5])
bbwDir=str(sys.argv[6])

# load and vectorise surface data
x = lhData.split(".")
ext = x[-1]
if ext == 'annot':
    lhInput = nibabel.freesurfer.io.read_annot(lhData)
    lhInput = lhInput[0]
    rhInput = nibabel.freesurfer.io.read_annot(rhData)
    rhInput = rhInput[0]
elif ext == 'txt':
    lhInput = np.loadtxt(lhData)
    rhInput = np.loadtxt(rhData)
elif ext == 'gii':
    lhInput = nibabel.gifti.giftiio.read(lhData)
    rhInput = nibabel.gifti.giftiio.read(rhData)
elif ext == 'mgh':
    lhInput = nibabel.freesurfer.mghformat.read(lhData)
    rhInput = nibabel.freesurfer.mghformat.read(rhData)
else:
    print("incompatible datatype")
    sys.exit()

# check size
compatSizes=np.array([10242, 32492, 163842])  # compatible number of vertices of input (ie: one hemisphere of fsaverage5, fs_LR_32k or fsaverage)
if len(lhInput)!=len(rhInput):
    print('hemispheric data not the same size')
    sys.exit()
if len(lhInput) not in compatSizes:
    print("invalid number of vertices")
    sys.exit()

data_fs = np.array(np.concatenate((lhInput, rhInput), axis=0))    

if approach == 'nn':
    print('load indexing')
    mat = io.loadmat(bbwDir + "/scripts/nn_surface_indexing.mat")
    nn_bb_fs = np.array(mat["nn_fs_bb"])
    print("reindexing data to fsaverage5")
    data_fs = data_bb[nn_bb_fs[0]-1]
elif approach == 'msm':
    print('load parcellation')
    lhParcBB = np.loadtxt(bbwDir + "/spaces/bigbrain/lh.Schaefer2018_1000Parcels_17Networks_order.label.txt")
    rhParcBB = np.loadtxt(bbwDir + "/spaces/bigbrain/rh.Schaefer2018_1000Parcels_17Networks_order.label.txt")
    parc_bb = np.array(np.concatenate((lhParcBB, rhParcBB+max(lhParcBB)), axis=0))   
    lhParcFS = np.loadtxt(bbwDir + "/spaces/" + inSurf + "/lh.Schaefer2018_1000Parcels_17Networks_order.label.txt")
    rhParcFS = np.loadtxt(bbwDir + "/spaces/" + inSurf + "/rh.Schaefer2018_1000Parcels_17Networks_order.label.txt")
    parc_fs = np.array(np.concatenate((lhParcFS, rhParcFS+max(lhParcBB)), axis=0))   
    data_bb = np.zeros(len(parc_bb))
    print('transforming average of each parcel')
    for ii in set(parc_fs):
        data_bb[parc_bb==ii] = np.mean(data_fs[parc_fs==ii])

print("writing out as text file")
np.savetxt(outName+'_lh_bigbrain.txt', data_bb[:len(data_bb)//2], delimiter=',')
np.savetxt(outName+'_rh_bigbrain.txt', data_bb[len(data_bb)//2:], delimiter=',')
