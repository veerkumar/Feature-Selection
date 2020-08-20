function forwardselected = forwardselection(TrainMat, LabelTrain, topfeatures)
%% input: TrainMat - a NxM matrix that contains the full list of features
%% of training data. N is the number of training samples and M is the
%% dimension of the feature. So each row of this matrix is the face
%% features of a single person.
%%        LabelTrain - a Nx1 vector of the class labels of training data
%%        topfeatures - a Kx2 matrix that contains the information of the
%% top 1% features of the highest variance ratio. K is the number of
%% selected feature (K = ceil(M*0.01)). The first column of this matrix is
%% the index of the selected features in the original feature list. So the
%% range of topfeatures(:,1) is between 1 and M. The second column of this
%% matrix is the variance ratio of the selected features.

%% output: forwardselected - a Px1 vector that contains the index of the 
%% selected features in the original feature list, where P is the number of
%% selected features. The range of forwardselected is between 1 and M. 


%forward selection with LDA
cand_feature = topfeatures(:,1);
evaluate_index = [];
evaluate_feature = [];
glb_min = 100;

while true
    %add features one by one 
    error_rate = zeros(1, length(cand_feature));
    for f=1:length(topfeatures(:,1))
        NewTrainMat = [evaluate_feature, TrainMat(:, cand_feature(f))];
        Mdl = fitcdiscr(NewTrainMat, LabelTrain);
        pred = predict(Mdl, NewTrainMat);
        cls_performence = classperf(LabelTrain, pred);
        error_rate(f) = cls_performence.ErrorRate;
    end
    [mini index] = min(error_rate);
    
    if mini < glb_min
        glb_min = mini;
        evaluate_index = [evaluate_index, cand_feature(index)];
        evaluate_feature = [evaluate_feature, TrainMat(:, cand_feature(index))];
    else
        break;
    end
    if length(evaluate_feature(:,1)) == length(topfeatures(:,1))
        break;
    end
end
forwardselected = evaluate_index;
        
        
        
        
        