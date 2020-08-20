
%load fisheriris

clear all;
close all;
clc;
addpath export_fig

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% load the data
FeatureMatOD=dlmread('data/ODFeatureMat.txt');
FeatureMatHD=dlmread('data/HDFeatureMat.txt');
FeatureMat=[FeatureMatOD FeatureMatHD(:,2:end)];
clear FeatureMatHD;
clear FeatureMatOD;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%the flow of your code should look like this
Dim = size(FeatureMat,2)-1; %dimension of the feature
countfeat(Dim,2) = 0;
%%countfeat is a Mx2 matrix that keeps track of how many times a feature has been selected, where M is the dimension of the original feature space.
%%The first column of this matrix records how many times a feature has ranked within top 1% during 100 times of feature ranking.
%%The second column of this matrix records how many times a feature was selected by forward feature selection during 100 times.

%%%%%%%%%%%%%%%%%%%% test code %%%%%
%comment this out 
% tmp = randperm(Dim);
% topfeatures(:,1) = tmp(1:1000)';
% topfeatures(:,2) = 100*rand(1000,1);
% forwardselected = tmp(1:100)';
%%%%%%%%%%%%%%%%%%%%%%%%************

loop_len = 2;
datetime('now')
iterator = [10 50 100];
for j=1:3
    total_train_ConfMat = 0;
    total_train_ClassMat = 0;
    total_train_acc = 0;
    total_train_std = 0;
    total_test_ConfMat = 0;
    total_test_ClassMat = 0;
    total_test_acc = 0;
    total_test_std = 0;
    loop_len = iterator(j);
    for i=1:loop_len

        % randomly divide into equal test and traing sets
        [TrainMat, LabelTrain, TestMat, LabelTest]= randomDivideMulti(FeatureMat);

        % start feature ranking
        topfeatures = rankingfeat(TrainMat, LabelTrain); 
        countfeat(topfeatures(:,1),1) =  countfeat(topfeatures(:,1),1) +1;

        %% visualize the variance ratio of the top 1% features
        if i==1
            %% colorbar indicates the correspondance between the variance ratio
            %% of the selected feature
           plotFeat(topfeatures);
        end

        % start forward feature selection
        forwardselected = forwardselection(TrainMat, LabelTrain, topfeatures);
        countfeat(forwardselected,2) =  countfeat(forwardselected,2) +1;    

        % start classification, Similar to project 2
        train_features = TrainMat(:,forwardselected);
        Mdl = fitcdiscr(train_features, LabelTrain);
        train_pred = predict(Mdl, train_features);
        train_ConfMat = confusionmat(LabelTrain, train_pred);
        total_train_ConfMat = total_train_ConfMat + train_ConfMat;
        %Create classification matrix (rows should sum to 1)
        train_ClassMat = train_ConfMat ./ meshgrid(countcats(categorical(LabelTrain)))';
        total_train_ClassMat = total_train_ClassMat + train_ClassMat;
        train_acc = mean(diag(train_ClassMat));
        total_train_acc = total_train_acc + train_acc;
        train_std = std(diag(train_ClassMat)); 
        total_train_std = total_train_std + train_std;

        test_features = TestMat(:,forwardselected);
        Mdl = fitcdiscr(test_features, LabelTest);
        test_pred = predict(Mdl, test_features);
        test_ConfMat = confusionmat(LabelTest, test_pred);
        total_test_ConfMat = total_test_ConfMat + test_ConfMat;
        test_ClassMat = test_ConfMat ./ (meshgrid(countcats(categorical(LabelTest)))');
        total_test_ClassMat = total_test_ClassMat + test_ClassMat;
        test_acc = mean(diag(test_ClassMat));
        total_test_acc = total_test_acc + test_acc;
        test_std = std(diag(test_ClassMat)); 
        total_test_std = total_test_std + test_std;

    end
    % Average over test and train data
    avg_train_ConfMat = int16(total_train_ConfMat / loop_len);
    avg_train_ClassMat = total_train_ClassMat / loop_len
    avg_train_acc = total_train_acc / loop_len
    avg_train_std = total_train_std / loop_len

    figure(5);
    cm = confusionchart(avg_train_ConfMat);
    if loop_len==10
        export_fig Face_Training_confusion_matrix_iterationsz_10 -png -transparent
    end

    if loop_len==50
        export_fig Face_Training_confusion_matrix_iterationsz_50 -png -transparent
    end

    if loop_len==100
        export_fig Face_Training_confusion_matrix_iterationsz_100 -png -transparent
    end

    total_test_ConfMat
    avg_test_ConfMat = int16(total_test_ConfMat / loop_len)
    avg_test_ClassMat = total_test_ClassMat / loop_len
    avg_test_acc = total_test_acc / loop_len
    avg_test_std = total_test_std / loop_len

    figure(6);
    cm = confusionchart(avg_test_ConfMat);
    if loop_len==10
        export_fig Face_Test_confusion_matrix_iterationsz_10 -png -transparent
    end

    if loop_len==50
        export_fig Face_Test_confusion_matrix_iterationsz_50 -png -transparent
    end

    if loop_len==100
        export_fig Face_Test_confusion_matrix_iterationsz_100 -png -transparent
    end

    %Plotting the histogram
    histgram_feature = countfeat(:,2);
    [sorted, top_idx] = sort(histgram_feature, 'descend');
    % Remove zero counts otherwise grapgh will have X axis with overlapped label 
    sorted = sorted(sorted ~= 0);
    length(sorted)
    top_10_feat_hist = sorted(1:ceil(length(sorted)*0.1));
    top_10_feat_index = categorical(top_idx(1:ceil(length(sorted)*0.1)));
    figure;
    bar(top_10_feat_index, top_10_feat_hist);
    title('Histogram for top 10% features');
    xlabel('Feature index ');
    ylabel('Number of times choosen');

    %% visualize the features that have ranked within top 1% most during 100 times of feature ranking
    data(:,1)=[1:Dim]';
    data(:,2) = countfeat(:,1);
    %% colorbar indicates the number of times a feature at that location was
    %% ranked within top 1%
    plotFeat(data);
    %% visualize the features that have been selected most during 100 times of
    %% forward selection
    data(:,2) = countfeat(:,2);
    %% colorbar indicates the number of times a feature at that location was
    %% selected by forward selection
    plotFeat(data);
end
datetime('now')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: You don't need this step for classification. This is just for the inquisitive minds who want to see how the features actually look like.
% Suppose you want to visualize 5th subject in the Test set. The following code shows how the feature of the 5'th subject would look like:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % uncomment to visualize the features
% FeatureMat=dlmread('data/HDFeatureMat.txt');
% k=reshape(TrainMat(5,:),[125 62]);
% imagesc(flipud([k fliplr(k)]));
% COLORBAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
