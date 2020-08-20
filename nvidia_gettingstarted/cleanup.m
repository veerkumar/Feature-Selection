if ~exist('currentfigures') || isempty(currentFigures), currentFigures = []; end;
close(setdiff(findall(0, 'type', 'figure'), currentFigures))
clear mex
delete *.mexw64
[~,~,~] = rmdir('C:\Users\Rahul\Documents\Study\sem2\Pattern recogniz\Project 3\nvidia_gettingstarted\codegen','s');
clear('C:\Users\Rahul\Documents\Study\sem2\Pattern recogniz\Project 3\nvidia_gettingstarted\myAdd.m')
delete('C:\Users\Rahul\Documents\Study\sem2\Pattern recogniz\Project 3\nvidia_gettingstarted\myAdd.m')
delete('C:\Users\Rahul\Documents\Study\sem2\Pattern recogniz\Project 3\nvidia_gettingstarted\main.cu')
delete('C:\Users\Rahul\Documents\Study\sem2\Pattern recogniz\Project 3\nvidia_gettingstarted\main.h')
clear
load old_workspace
delete old_workspace.mat
delete('C:\Users\Rahul\Documents\Study\sem2\Pattern recogniz\Project 3\nvidia_gettingstarted\cleanup.m')
cd('C:\Users\Rahul\Documents\Study\sem2\Pattern recogniz\Project 3')
rmdir('C:\Users\Rahul\Documents\Study\sem2\Pattern recogniz\Project 3\nvidia_gettingstarted','s');
