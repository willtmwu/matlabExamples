%Process image by edge detection and apply mathmatical morphologies
clear all;
close all;

BW2 = im2bw(imread('hi_Mask.tif'));
I = imread('hi_FITC.tif');
E = edge(I, 'sobel');

% Close regions by dilating, eroding and then filling enclosed boundaries
F = E;
for i = 1:4
    D = imdilate(F, strel('disk', i,8));
    E = imerode(D, strel('disk', 1,0));
    F = imfill(E, 'holes');
end
F = imerode(F, strel('disk', 6,8));
F = bwareaopen(F, 100);

Accuracy = 1 - sum(sum(abs(F - BW2)))/(size(BW2,1)*size(BW2,2))
%imshow(F, []);
imshow(abs(F - BW2), []);
