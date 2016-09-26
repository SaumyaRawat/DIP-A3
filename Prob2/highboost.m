%% high boost filtering %%
function[sharpened] = highboost(im)
k = 5; w = 5;
H = padarray(1+k,[(w-1)/2 (w-1)/2]) - 	(k*fspecial('gaussian' ,[w w],k)); % create unsharp mask ( ( (1+k)e -(k*g) ) )
sharpened = imfilter(im,H);  % create a sharpened version of the image using that mask
figure;imshow(sharpened)