function plotFeat(FeatStat,FeatNames,num_on_bar)
% FeatStat: nx2 where n is the number of features.  
%     The second dimension is feature number and then score
% FeatNames: Names of all the features
% num_on_bar the number of features to show on the bar graph


%% Sort top feature and plot on bar graph
figure;
FeatStat = sortrows(FeatStat,-2);
barh(FeatStat(num_on_bar:-1:1,2));
FeatNames = FeatNames(FeatStat(:,1));
set(gca,'YTick', 1:num_on_bar,'YTickLabel',FeatNames(num_on_bar:-1:1),'FontSize', 14);
ylim([.5,num_on_bar+.5]);
grid on
xlabel('Feature Criteria Score','FontSize', 18);
ylabel('Features','FontSize', 18);
title(sprintf('Top %d Ranked Features',num_on_bar),'FontSize', 20)

%% Display Where on the brain the features are coming from
figure;
addpath(genpath('./brain_mapping'));
three = ~cellfun(@isempty,regexp(FeatNames,'E[0-9][0-9][0-9]'));
two = ~cellfun(@isempty,regexp(FeatNames,'E[0-9][0-9]'));
loc = cell2mat(regexp(FeatNames,'E[0-9]'));

% Create histogram for plot
elect_hist = zeros(128,1);
elect_score_hist = zeros(128,1);
for i = 1:length(loc)
    elect = str2double(FeatNames{i}(loc(i)+1:loc(i)+three(i)+two(i)+1));
    elect_hist(elect) = elect_hist(elect)+FeatStat(i,1);
end

title('Sum of Feature Criteria Scores for Each Electrode','FontSize', 20)
topoplot(elect_hist,'GSN-HydroCel-128.sfp','electrodes','labelpoint', 'verbose', 'off','shading','interp','whitebk', 'on','maplimits',[min(elect_hist) , max(elect_hist)]);
colorbar;
rmpath(genpath('./brain_mapping'));