%% Football player detection %%
addpath('Positive');
addpath('Negetive');
%% Read the image and resize to save computation time %%
D_negetive = dir('Negetive/*.jpg');
D_positive = dir('Positive/*.jpg');
D_test = dir('Test/*.png');
positive_features = [];
negetive_features = [];

pos_labels = ones(size(D_positive,1),1);
neg_labels = zeros(size(D_negetive,1),1);

%find the HOG descriptor value for all images 
for i=1:size(D_positive,1)
	filename = ['Positive/',D_positive(i).name];
	im = imread(filename);
	im = imresize(im,[160 64]);
	positive_features =  [positive_features;extractHOGFeatures(im,'CellSize',[4 4], 'BlockSize',[8 8])];
	
	n_filename = ['Negetive/',D_negetive(i).name];
	n_im = imread(n_filename);
	n_im = imresize(n_im,[160 64]);
	negetive_features =  [negetive_features;extractHOGFeatures(n_im,'CellSize',[4 4], 'BlockSize',[8 8])];
end
test_images = [];
test_features = [];
for i=1:size(D_test,1)
	filename = ['Test/',D_test(i).name];
	im = imread(filename);
	im = imresize(im,[160 64]);
	test_images = [test_images;im];
	test_features =  [test_features;extractHOGFeatures(im,'CellSize',[4 4], 'BlockSize',[8 8])];
end
labels = [pos_labels;neg_labels];
features = [positive_features;negetive_features];

[svmStructure] = svmtrain(features, labels);
[predictClass] = svmclassify(svmStructure, test_features); 