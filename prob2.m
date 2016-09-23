%% Window detection using Hough Transforms %%
%% Hough transf function used : Detect lines in grayscale image using Hough Transform by Tao Peng %%
addpath('Prob2');
I = imread('building_1.jpg');
[accum, axis_rho, axis_theta, lineprm, lineseg] = Hough_Grd(rgb2gray(I), 6, 0.02);
figure; imagesc(I); colormap('gray'); axis image;
DrawLines_2Ends(lineseg);
title('Image with Line Segments Detected');

binaryImage = rgb2gray(I) < 128;
cc = bwconncomp(binaryImage);
measurements = regionprops(cc, 'BoundingBox');
for k = 1 : length(measurements)
  thisBB = measurements(k).BoundingBox;
  if thisBB(4) <= 3  % If it's shorter than 4 lines tall.
    message = sprintf('Blob #%d is horizontal.', k);
    sprintf('%s\n', message);
    uiwait(helpdlg(message));
  end
end