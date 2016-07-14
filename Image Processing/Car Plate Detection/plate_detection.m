close all;
clear all;

figure(1);
im = imread('DSC_1441.JPG', 'jpg');
%im = imresize(im, [1000 nan]);
im = rgb2gray(im);
subplot(3,2,1);
imshow(im);

%Filter for noise

%Edge Detection
subplot(3,2,2);
[BW,thresh] = edge(im,'canny', 0.5);
imshow(BW);

%Hough Transform and rotate

%Dilate by vertical and horizontal lines
subplot(3,2,3);
BW_v = imdilate(BW, strel('line', 3, 90));
BW_vh = imdilate(BW_v, strel('line', 3, 0));
imshow(BW_vh);

%Remove small regions
subplot(3,2,4);
BW_open = bwareaopen(BW_vh, 300);
BW_clear = imclearborder(BW_open, 4);
imshow(BW_clear);

%Fill region holes
subplot(3,2,5);
BW_fill = imfill(BW_clear, 'holes');
imshow(BW_fill);

%Erode away incorrect shapes
subplot(3,2,6);
BW_er1 = imerode(BW_fill, strel('disk',4));
BW_er2 = imerode(BW_er1, strel('diamond',4));
imshow(BW_er2);

%Find Rectangular region 
regions = regionprops(BW_er2, 'BoundingBox', 'Image', 'Extent');
regionsNum = size(regions,1);

for i = 1:regionsNum
    region = regions(i);
    if size(region.Image,2) >= 3*size(region.Image,1) && region.Extent > 0.8
        plate = imcrop(im, region.BoundingBox); 
        
        subplot(3,2,1);  
        rectangle('position', region.BoundingBox, 'edgecolor', 'g', 'linewidth',2);
    end;
end

%Invert color
plate = 255 - plate; 

%Plate Segmentation
figure(2);
subplot(1,2,1);
imshow(plate, []);

%Edge Detection
subplot(1,2,2);
BW_plate = edge(plate,'canny');
imshow(BW_plate); 

%Pre-processing
%subplot(3,3,3);
BW_pv = imdilate(BW_plate, strel('line', 2, 90));
BW_pvh = imdilate(BW_pv, strel('line', 2, 0));
%imshow(BW_pvh);

%Extract the letters
regions_plate = regionprops(BW_pvh, 'BoundingBox', 'Image', 'Area');
regionsNum_plate = size(regions_plate,1);

%Match by height requirements
letterNum = 1;
for i = 1:regionsNum_plate
    region_letter = regions_plate(i);
    
    if 0.5*size(plate,1) < size(region_letter.Image,1)
        letters(letterNum) = region_letter;
        letterNum = letterNum + 1;
        
        subplot(1,2,1);  
        rectangle('position', region_letter.BoundingBox, 'edgecolor', 'r', 'linewidth',2);
    end;
end

%Character Recognition
temp_letters = {'1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};

final_plate_num = '';
for i = 1:size(letters,2)
    max_corr = 0;
    found_letter = '0';
    
    for j = 1:size(temp_letters,2);
        filename = strcat('./letter_template/', temp_letters(j), '.jpg');
        corr_letter = imread(char(filename), 'jpg');
        corr_letter = rgb2gray(corr_letter);
        corr_letter = imresize(corr_letter, [77 55]);
        corr_letter = im2bw(corr_letter);
        
        crop = imcrop(plate,letters(i).BoundingBox);
        crop = im2bw(crop);
        crop = imresize(crop, [77 55]);
        
        corr = normxcorr2(crop, corr_letter);
        [maxVal, maxIndex] = max(abs(corr(:)));
        
        %Debugging
%         if i == 6 && j == 8 
%             subplot(3,3,4);
%             imshow(corr_letter);
%             subplot(3,3,5);
%             imshow(crop);
%         end
%         
%         if  i== 6
%             disp(temp_letters(j));
%             disp(maxVal);
%         end
        
        if maxVal > max_corr
            max_corr = maxVal;
            found_letter = temp_letters(j);
        end
    end    
    
    %print letter to console
    
    final_plate_num = strcat(final_plate_num, found_letter); 
end
disp(final_plate_num);


