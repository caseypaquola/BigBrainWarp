# import libraries
import numpy as np
from sklearn.svm import SVC
import scipy.io as io
from sklearn.multiclass import OneVsRestClassifier

# load data
projDir = '/local/working/directory/'
mat = io.loadmat(projDir + "output/tpl-bigbrain_desc-yeo17_moments.mat")
X = mat["Xcv_eq"]
ycv = mat["ycv_eq"]
n_classes = ycv.shape[1]
folds = int(X.shape[2])
obs = ycv.shape[0]

# predict in each fold
train_folds = 5
y_pred = np.zeros([obs,train_folds])
for i in range(0,train_folds):
    classifier = OneVsRestClassifier(SVC(kernel='linear'))
    classifier.fit(X[:,:,i], ycv[:,i])
    y_pred[:,i] = classifier.predict(X[:,:,i+train_folds])

io.savemat(projDir + "output/tpl-bigbrain_desc-yeo17_moments_pred_ovr.mat", {"y_pred": y_pred})