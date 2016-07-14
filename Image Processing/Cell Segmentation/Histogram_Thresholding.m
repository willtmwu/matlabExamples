%Histogram Search
clear all;
close all;

peaks_found = 0;
peak_index = [0,0];
I = imread('hi_FITC.tif');
H = imhist(I);

P = sort(H, 'descend');

%Find the 2 peaks in bi-modal histogram
for i=1:size(P,1);
    j = find(H == P(i));
    if (H(j) > H(j+1)) && (H(j) > H(j-1))
        peak_index(peaks_found+1) = j;
        peaks_found = peaks_found + 1;
    end
    
    if peaks_found == 2
        break;
    end
end

%Find the lowest point between the 2 peaks 
%Set the threshold and process the image
T = sort(H(peak_index(1):peak_index(2)));
T = find(H==T(1))/255;

% Threshold Processed Image
BW1 = im2bw(I, T);
BW2 = im2bw(imread('hi_Mask.tif'));
Accuracy = 1 - sum(sum(abs(BW1 - BW2)))/(size(BW1,1)*size(BW1,2))
%imshow(BW1, []);

% Adding morphological operations
fill = imfill(BW1, 'holes');
open = bwareaopen(fill, 130);
%imshow(open, []);
imshow(abs(open - BW2), []);

Accuracy = 1 - sum(sum(abs(open - BW2)))/(size(BW1,1)*size(BW1,2))