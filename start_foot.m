
%load fisheriris

clear all;
close all;
clc;
addpath export_fig

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% load the data
load('Subject10_Male.mat')
male1 = FootpressureData;
load('Subject9_Female.mat')
female1 = FootpressureData;
load('Subject8_Male.mat')
male2 = FootpressureData;
load('Subject7_Male.mat')
male3 = FootpressureData;
load('Subject6_Female.mat')
female2 = FootpressureData;
load('Subject5_Female.mat')
female3 = FootpressureData;
load('Subject4_Male.mat')
male4 = FootpressureData;
load('Subject3_Female.mat')
female4 = FootpressureData;
load('Subject2_Male.mat')
male5 = FootpressureData;
load('Subject1_Female.mat')
female5 = FootpressureData;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

male = [male1;male2;male3;male4;male5];
female = [female1;female2;female3;female4;female5];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%the flow of your code should look like this
%Dim = size(FeatureMat,2)*size(FeatureMat,3)*size(FeatureMat,4)-1; %dimension of the feature
%countfeat(Dim,2) = 0;
%%countfeat is a Mx2 matrix that keeps track of how many times a feature has been selected, where M is the dimension of the original feature space.
%%The first column of this matrix records how many times a feature has ranked within top 1% during 100 times of feature ranking.
%%The second column of this matrix records how many times a feature was selected by forward feature selection during 100 times.



loop_len = 1;
datetime('now')

total_train_ConfMat = 0;
total_train_ClassMat = 0;
    total_train_acc = 0;
    total_train_std = 0;
    total_test_ConfMat = 0;
    total_test_ClassMat = 0;
    total_test_acc = 0;
    total_test_std = 0;
    

        % randomly divide into equal test and traing sets
        
male_2d = reshape(male,[size(male,1) size(male,2)*size(male,3)*size(male,4) ]);
female_2d = reshape(female,[size(female,1) size(female,2)*size(female,3)*size(female,4)]);
male_data = [zeros(size(male_2d,1),1) male_2d];
female_data = [ones(size(female_2d,1),1) female_2d];
FeatureMat = [male_data; female_data];
%         M1 = male(1:int16(size(male,1)/2),:);
%         M2 = male(int16(size(male,1)/2):end,:);
%         FM1 = female(1:int16(size(female,1)/2),:);
%         FM2 = female(int16(size(female,1)/2):end,:);
%         TrainMat = [M1;FM1];
%         LabelTrain = [zeros(size(M1,1)); ones(size(FM1,1))];
%         TestMat = [M2;FM2];
%         LabelTest = [zeros(size(M2,1)); ones(size(FM2,1))];
%         % start feature ranking

Dim = size(FeatureMat,2)-1; %dimension of the feature
countfeat(Dim,2) = 0;
FeatureMat=FeatureMat(randsample(1:length(FeatureMat),length(FeatureMat)),:);
        
 for i=1:loop_len
     loop_len
     
         [TrainMat, LabelTrain, TestMat, LabelTest]= randomDivideMulti(FeatureMat);
        

         topfeatures = rankingfeat_foot(TrainMat, LabelTrain); 
         countfeat(topfeatures(:,1),1) =  countfeat(topfeatures(:,1),1) +1;
 
%         % start forward feature selection
         forwardselected = forwardselection_foot(TrainMat, LabelTrain, topfeatures);
         countfeat(forwardselected,2) =  countfeat(forwardselected,2) +1;    

        % start classification, Similar to project 2
        train_features = TrainMat(:,forwardselected);
        Mdl = fitcdiscr(train_features, LabelTrain);
        train_pred = predict(Mdl, train_features);
        train_ConfMat = confusionmat(LabelTrain, train_pred);
        total_train_ConfMat = total_train_ConfMat + train_ConfMat;
        %Create classification matrix (rows should sum to 1)
        train_ClassMat = train_ConfMat ./ meshgrid(countcats(categorical(LabelTrain)))';
        total_train_ClassMat = total_train_ClassMat + train_ClassMat
        train_acc = mean(diag(train_ClassMat));
        total_train_acc = total_train_acc + train_acc
        train_std = std(diag(train_ClassMat)); 
        total_train_std = total_train_std + train_std

        test_features = TestMat(:,forwardselected);
        Mdl = fitcdiscr(test_features, LabelTest);
        test_pred = predict(Mdl, test_features);
        test_ConfMat = confusionmat(LabelTest, test_pred);
        total_test_ConfMat = total_test_ConfMat + test_ConfMat;
        test_ClassMat = test_ConfMat ./ (meshgrid(countcats(categorical(LabelTest)))');
        total_test_ClassMat = total_test_ClassMat + test_ClassMat
        test_acc = mean(diag(test_ClassMat));
        total_test_acc = total_test_acc + test_acc
        test_std = std(diag(test_ClassMat)); 
        total_test_std = total_test_std + test_std
    end
    % Average over test and train data
    avg_train_ConfMat = int16(total_train_ConfMat / loop_len);
    avg_train_ClassMat = total_train_ClassMat / loop_len
    avg_train_acc = total_train_acc / loop_len
    avg_train_std = total_train_std / loop_len

    figure(5);
    cm = confusionchart(avg_train_ConfMat);
    export_fig Foot_Training_confusion_matrix_iterationsz_10 -png -transparent
       

    total_test_ConfMat
    avg_test_ConfMat = int16(total_test_ConfMat / loop_len)
    avg_test_ClassMat = total_test_ClassMat / loop_len
    avg_test_acc = total_test_acc / loop_len
    avg_test_std = total_test_std / loop_len

    figure(6);
    cm = confusionchart(avg_test_ConfMat);
    export_fig Foot_Test_confusion_matrix_iterationsz_10 -png -transparent
 
    %Plotting the histogram
    histgram_feature = countfeat(:,2);
    [sorted, top_idx] = sort(histgram_feature, 'descend');
    % Remove zero counts otherwise grapgh will have X axis with overlapped label 
    sorted = sorted(sorted ~= 0);
    length(sorted)
    top_10_feat_hist = sorted(1:ceil(length(sorted)*0.5));
    top_10_feat_index = categorical(top_idx(1:ceil(length(sorted)*0.5)));
    figure;
    bar(top_10_feat_index, top_10_feat_hist);
    title('Histogram for top 50% features');
    xlabel('Feature index ');
    ylabel('Number of times choosen');

    %% visualize the features that have ranked within top 1% most during 100 times of feature rankin
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
