%Water Immersion Method

close all;
clear all;

% Preprocess the image
I = imread('hi_FITC.tif');
I2 = imadjust(I, [26/255 129/255], []); 

BW1 = im2bw(I, 86/255); 
figure
imshow(BW1, []),  title('Threshold Image');

% Create the Gradient Image
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I2), hy, 'replicate');
Ix = imfilter(double(I2), hx, 'replicate');
G = sqrt(Ix.^2 + Iy.^2);
figure
imshow(G,[]), title('Gradient magnitude');

% Clean the image by morphology
% Open to remove noise
Iopen = bwareaopen(BW1, 120);
Iopen = imopen(Iopen, strel('disk', 3, 4));
% Close to remove holes in object
Iclose = imclose(Iopen, strel('disk', 5, 0));
imshow(Iclose,[]), title('Morph Processed Image');

% Find foreground markers
Df = bwdist(imcomplement(Iclose));
fgm = Df;
fgm(fgm<0.5*max(max(fgm))) = 0;
fgm(fgm>0.5*max(max(fgm))) = 255;
figure
imshow(fgm,[]), title('Foreground Markers');

% Find background markers
Db = bwdist(Iclose);
DL = watershed(Db);
bgm = DL == 0;
figure
imshow(bgm,[]), title('Background Markers');

% Set the image markers onto the gradient image
G2 = imimposemin(G, bgm | fgm);
L = watershed(G2);

% Display the results
I3 = I;
I3(imdilate(L == 0, ones(1, 1)) | bgm | fgm) = 255;
figure
imshow(I3, [])
title('Markers and object boundaries superimposed on original image (I4)')

% Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
% figure
% imshow(Lrgb)
% title('Colored watershed label matrix (Lrgb)')

% Process the watershed ridge lines to allow accuracy comparison
I4 = L == 0;
I4(imdilate(L == 0, ones(1, 1))) = 255;
I4(1,[1 : 620]) = 255; 
I4([1:88],1) = 255; 
I4([332:457],1) = 255; 
I4([649:731],1) = 255; 
I4([867:950],1) = 255; 
I4(size(I4,1),[54 : 404]) = 255; 
I4(size(I4,1),[1329 : size(I4,2)]) = 255; 
I4([334:614],size(I4,2)) = 255; 
I4([993:size(I4,1)],size(I4,2)) = 255; 
BW2 = imfill(I4, 'holes');

BW3 = im2bw(imread('hi_Mask.tif'));
Accuracy = 1 - sum(sum(abs(BW2 - BW3)))/(size(BW3,1)*size(BW3,2))
figure;
imshow(abs(BW2 - BW3), []);

