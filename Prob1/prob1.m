I = im2double(imread('soccer_8.png'));
I = highboost(I);
hsv = rgb2hsv(I);

% Create a binary mask of image based on the property of fields being dominantly green
mask = hsv(:,:,1) > 0.1 & hsv(:,:,2) < 0.2 & hsv(:,:,2) <0.55 & hsv(:,:,3) > 0.1;

% Compute gradient image and add to mask to preserve edges of players
[Gx, Gy] = imgradientxy(rgb2gray(I));
[Gmag, Gdir] = imgradient(Gx,Gy);
mask = mask + mat2gray(Gmag);
imshow(mask)

% Convert to binary image for morphological operations
mask = im2bw(mask,0.1);

% Diagonal fill to eliminate 8-connectivity of background
diagIm = bwmorph(mat2gray(mask),'diag');

% Median filter image to remove salt and pepper noise
filtIm = medfilt2(mat2gray(diagIm),[6 5]);

% Close morphological transform to enhance only the players
closeIm = bwmorph(filtIm,'close');
imshow(closeIm)

playerIm=closeIm;
% Remove crowd area of the image using connected components and removing the largest one
CC = bwconncomp(closeIm);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
playerIm(CC.PixelIdxList{idx}) = 0;
imshow(playerIm);


% Perform erosion morphological operation to remove ovals
se = strel('line',9,90);    
noOvalIm = imerode(playerIm,se);
imshow(noOvalIm)
noOvalIm = bwmorph(noOvalIm,'close');

% Remove the line as it's the last largest component left
finalIm = noOvalIm;
CC = bwconncomp(noOvalIm);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
finalIm(CC.PixelIdxList{idx}) = 0;

% dilate to emphasise players left in the image
imdilate(finalIm,strel('disk',5));
imshowpair(I,finalIm,'montage');