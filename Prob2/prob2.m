%% Windows in facades %%

%% Read the images  %%
Images = dir('images/*.jpg');
filename = ['images/',Images(1).name];
I = im2double(imread(filename));
J = imadjust(I,stretchlim(I),[]);
J = brighten(J,0.9);

% Obtain a sharp bw image to easily distinguish windows using Adaptive Histogram Equalization and Oshos Thresholding.
j = adapthisteq(rgb2gray(J));
level = graythresh(j);
bw = im2bw(j,level);
figure;imshow(bw);title('Adaptive Thresholded Image')


[Gx,Gy] = imgradientxy(bw);
x = imdilate( medfilt2(Gx),strel('line',3,90));
y = imdilate( medfilt2(Gy),strel('line',1,0));
[Gmag,Gdir] = imgradient(x,y);
Gmag = double(Gmag);

finalIm = Gmag;
CC = bwconncomp(Gmag);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
finalIm(CC.PixelIdxList{idx}) = 0;

finalIm = medfilt2(finalIm,[3 3]);
imshow(finalIm)
