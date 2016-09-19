%% Football player detection %%
addpath('Positive');
addpath('Negetive');
%% Read the image and resize to save computation time %%
D_negetive = dir('Negetive/*.jpg');
D_positive = dir('Positive/*.jpg');

positive_features = zeros(1,size(D));
%find the HOG descriptor value for all images matlab
for i=1:size(D_positive,1)
	k=1;
	filename = ['Positive/',D(1).name];
	im = imread(filename);
	im = imresize(im, [500 250]);
