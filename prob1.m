%% Football player detection %%
addpath('Positive');
addpath('Negetive');
%% Read the image and resize to save computation time %%
D_negetive = dir('Negetive/*.jpg');
D_positive = dir('Positive/*.jpg');
D_test = dir('Test/*.jpg');
positive_features = [];
negetive_features = [];

pos_labels = ones(size(D_positive,1),1);
neg_labels = zeros(size(D_negetive,1),1);

%find the HOG descriptor value for all images 
for i=1:size(D_positive,1)
	filename = ['Positive/',D_positive(i).name];
	im = imread(filename);
	im = imresize(im,[128 64]);
	positive_features =  [positive_features;extractHOGFeatures(im,'CellSize',[4 4], 'BlockSize',[8 8])];
	
	n_filename = ['Negetive/',D_negetive(i).name];
	n_im = imread(n_filename);
	n_im = imresize(n_im,[128 64]);
	negetive_features =  [negetive_features;extractHOGFeatures(n_im,'CellSize',[4 4], 'BlockSize',[8 8])];
end
labels = [pos_labels;neg_labels];
features = [positive_features;negetive_features];

[svmStructure] = svmtrain(features, labels);

test_images = [];
test_features = [];
testimg=imread('soccer_1.png');
i=1;
no_of_players=0;
h=imshow(testimg);
while i+128<size(testimg,1)
	j=1;
	while j+64<size(testimg,2)
		imgWindow = testimg(i:i+128,j:j+64,:);
		test_features =  extractHOGFeatures(imgWindow,'CellSize',[4 4], 'BlockSize',[8 8]);
		predictClass = svmclassify(svmStructure, test_features);
		if predictClass==1
			no_of_players=no_of_players+1;
			h2=imrect(gca,[j i 64 128]);
		end
		j=j+64;
	end
	i=i+128;
end
disp(no_of_players)