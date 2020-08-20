function topfeatures = rankingfeat(TrainMat, LabelTrain)
%% input: TrainMat - a NxM matrix that contains the full list of features
%% of training data. N is the number of training samples and M is the
%% dimension of the feature. So each row of this matrix is the face
%% features of a single person.
%%        LabelTrain - a Nx1 vector of the class labels of training data

%% output: topfeatures - a Kx2 matrix that contains the information of the
%% top 1% features of the highest variance ratio. K is the number of
%% selected feature (K = ceil(M*0.01)). The first column of this matrix is
%% the index of the selected features in the original feature list. So the
%% range of topfeatures(:,1) is between 1 and M. The second column of this
%% matrix is the variance ratio of the selected features.

[num_sample num_feat]= size(TrainMat);
all_feat_var = zeros(num_feat,1);
VR= zeros(1, num_feat); 

%Number of class label and there name
num_cls = length(unique(LabelTrain));
cls_label = unique(LabelTrain);
temp_var = zeros(1,num_cls);


train_cls = zeros(num_cls); %num_cls x 1
% 
% for c=1:num_cls
%     cls = cls_label(c); %1x1
%     % separate training data for each class 
%     train_cls(:,:,c) = TrainMat(LabelTrain == class, :); %num_clss_data x num_feature x num_cls
%     var_cls(c) = var(train_cls(c));
% end

var_full = var(TrainMat);

%calculate for each feature
for f=1:num_feat
    %select particular feature data from 
    temp_var_full = var_full(1,f);
    extract_feature = TrainMat(:,f);
    %caculate each class varience
    for c=1:num_cls
        cls = cls_label(c); % actual class label
%       train_cls_all_feat = TrainMat(LabelTrain == cls, :);
%       train_cls_feat = train_cls_all_feat(:,f);
        train_cls_feat = extract_feature(LabelTrain == cls, :);
        temp_var(c) = var(train_cls_feat);
    end
    VR(1,f) = temp_var_full/(2*sum(temp_var));
    temp_var = zeros(1,num_cls);
end

VR(isnan(VR))= 0;
[value, order]= sort(VR(1,:),'descend');
VR = [order; value]';


topfeatures = VR(1:(0.01*num_feat),:);
    
