# import libraries
import numpy as np
from sklearn.multiclass import OneVsRestClassifier, OneVsOneClassifier
from sklearn.svm import SVC
from sklearn.model_selection import KFold
import scipy.io as io
from sklearn import svm, datasets
from sklearn.metrics import roc_curve, auc, roc_auc_score, confusion_matrix
from sklearn.model_selection import train_test_split, StratifiedKFold
from sklearn.preprocessing import label_binarize
from sklearn.multiclass import OneVsRestClassifier
from scipy import interp
from sklearn.metrics import roc_auc_score

# load data
projDir = '/local/working/directory/'
mat = io.loadmat(projDir + "output/yeo17_moments_bb.mat")
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

io.savemat(projDir + "output/yeo17_moments_pred_ovr.mat", {"y_pred": y_pred})