for init_project = 1
    
    GH          = '/location/of/github/repos/';
    bbwDir      = [GH '/BigBrainWarp/']; 
    projDir     = '/local/working/directory/';
    
    addpath([bbwDir '/scripts/'])
    addpath(genpath([GH '/micaopen/surfstat']))
    
end

% load network atlas
parc_name='Yeo2011_17Networks_N1000';
lh = gifti([bbwDir '/spaces/bigbrain/' parc_name '_lh_bigbrain.label.gii']);
rh = gifti([bbwDir '/spaces/bigbrain/' parc_name '_rh_bigbrain.label.gii']);
parc = [lh.cdata; rh.cdata];
names = [lh.labels.name rh.labels.name];

% moments 
MP = reshape(dlmread([bbwDir '/spaces/bigbrain/profiles.txt']),[], 50)';
MP = MP*-1;
MPmoments(1,:) = mean(MP);
MPmoments(2,:) = std(MP);
MPmoments(3,:) = skewness(MP);
MPmoments(4,:) = kurtosis(MP);
MPmoments(5,:) = mean(diff(MP));
MPmoments(6,:) = std(diff(MP));
MPmoments(7,:) = skewness(diff(MP));
MPmoments(8,:) = kurtosis(diff(MP));
MPmoments = zscore(MPmoments);

% create cross folds 
folds = 10;
n = floor(6558/folds); % set based vertices in smallest network (DMN-C: 1100)
Xcv_eq = zeros(n*17,size(MPmoments,1),folds);
ycv_eq = zeros(n*17,folds);
for ii = 1:17
    idx = randperm(sum(parc==ii),sum(parc==ii)); % random list of number the length of the network
    idx_net = find(parc==ii); % where is the network in the feature vector
    for cv = 1:folds
        Xcv_eq(((ii-1)*n)+1:(ii*n),:,cv) = MPmoments(:,idx_net(ismember(idx,((cv-1)*n)+1:(cv*n))))';
        ycv_eq(((ii-1)*n)+1:(ii*n),cv) = repmat(ii,n,1);
    end
end
save([projDir '/output/yeo17_moments_bb.mat'], 'Xcv_eq', 'ycv_eq')