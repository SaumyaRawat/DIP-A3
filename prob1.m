%% Window detection using Hough Transforms %%
sigma=1;
I = imread('building_1.jpg');
gray_I = rgb2gray(I);
[g3, t3]=edge(gray_I, 'canny', [0.04 0.10], sigma);

H=hough(gray_I);
imshow(H,[])
