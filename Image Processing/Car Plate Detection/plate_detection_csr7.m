close all;
clear all;

figure(1);
im = imread('car7.JPG', 'jpg');
im = imresize(im, [555 741]);
im = rgb2gray(im);
imshow(im);
title('Original Grayscale Image');

%Section 1 - Finding the number plate
%Edge Detection
figure(2);
[BW,thresh] = edge(im,'canny', 0.5);
imshow(BW);
title('Edge Detection Image');

%Dilate by vertical and horizontal lines
figure(3);
BW_v = imdilate(BW, strel('line', 3, 90));
BW_vh = imdilate(BW_v, strel('line', 3, 0));
imshow(BW_vh);
title('Horizontal and Vertical Line Dilation');

%Remove small regions <500 pixels
figure(4);
BW_open = bwareaopen(BW_vh, 500);
imshow(BW_open);
title('Remove Small Regions <500 pixels');

%Fill region holes
figure(5);
BW_fill = imfill(BW_open, 'holes');
imshow(BW_fill);
title('Fill region holes');

%Erosion by a rectangluar structural element
figure(6);
BW_er = imerode(BW_fill, strel('rectangle', [11 11]));
imshow(BW_er);
title('Erode by rectangle');

%Find Rectangular region 
regions = regionprops(BW_er, 'BoundingBox', 'Image', 'Extent');
regionsNum = size(regions,1);

%Filter by rectangluar dimensions
for i = 1:regionsNum
    region = regions(i);
    if size(region.Image,2) >= 4*size(region.Image,1) ... 
            && region.Extent > 0.8
        plate = imcrop(im, region.BoundingBox); 
        
        figure(1);
        rectangle('position', region.BoundingBox, 'edgecolor', ...
            'g', 'linewidth',2);
        break;
    end;
end

%Sectione 2 -- Plate Segmentation
%Preprocess the image of the numberplate
figure(7);
plate = imresize(plate, [60 284]);
plate = imadjust(plate, [0.5 0.65],[]);
plate = imdilate(plate, strel('disk', 2));
imshow(plate, []);
title('Pre-processed plate image');

%Edge Detection
figure(8);
BW_plate = edge(plate,'canny');
imshow(BW_plate); 
title('Edge Detection of Plate');

%Extract the letters
regions_plate = regionprops(BW_plate, 'BoundingBox', 'Image', 'Area');
regionsNum_plate = size(regions_plate,1);

%Filter by height requirements
letterNum = 1;
for i = 1:regionsNum_plate
    region_letter = regions_plate(i);
    
    if 0.6*size(plate,1) < size(region_letter.Image,1)
        letters(letterNum) = region_letter;
        letterNum = letterNum + 1;
        
        figure(7);
        rectangle('position', region_letter.BoundingBox, 'edgecolor', ...
            'r', 'linewidth',2);
    end;
end

%Section 3 -- Character Recognition
temp_letters = {'1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', ...
    'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', ...
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};

%Template match by database of letters and numbers
final_plate_num = '';
for i = 1:size(letters,2)
    max_corr = 0;
    found_letter = '0';
    
    for j = 1:size(temp_letters,2);
        filename = strcat('./letter_template/', temp_letters(j), '.jpg');
        corr_letter = imread(char(filename), 'jpg');
        corr_letter = rgb2gray(corr_letter);
        corr_letter = imresize(corr_letter, [58 34]);
        
        crop = imcrop(plate,letters(i).BoundingBox);
        crop = imresize(crop, [58 34]);
        
        corr = normxcorr2(crop, corr_letter);
        [maxVal, maxIndex] = max(abs(corr(:)));
        
        if maxVal > max_corr
            max_corr = maxVal;
            found_letter = temp_letters(j);
        end
    end    
    final_plate_num = strcat(final_plate_num, found_letter); 
end
disp(final_plate_num);


