clear all;
close all;

% Define and read in a target image
targetImage = imread('./Faces/eig/1a.bmp');
%targetImage = imread('3T.bmp');
[imageHeight,imageWidth] = size(targetImage);
imageDepth = imageHeight*imageWidth;

% Build and populate the image database
for i = 1:6
    directory = sprintf('./Faces/%d/', i);
    [eigenFaces,  weights, imageMean, imageMatrix] = eigen_trainer(directory);
    imageDatabase(i).eigenFaces = eigenFaces;
    imageDatabase(i).weights = weights;
    imageDatabase(i).imageMean = imageMean;
    imageDatabase(i).imageMatrix = imageMatrix;
end

% Compare the target image to weightings in the database
% Classify the image according to the smallest weight
weightingsDifference = [];
weightingsInd = [];
for i = 1:length(imageDatabase)
    % Calculate the weighting for the target image 
    % projected onto the eigenface
    targetWeighting = imageDatabase(i).eigenFaces'* (double(reshape(targetImage,[imageDepth 1]))  - imageDatabase(i).imageMean);
    
    % Find the euclidean distance between all the training image weightings
    % and the weighting of the target image
    difference = [];
    for j = 1:length(imageDatabase(i).weights)
        difference(j) = norm(targetWeighting - imageDatabase(i).weights(j).image);
    end
    
    % Find training image with smallest euclidean distance, for the person
    [val, ind] = min(difference);
    weightingsDifference(i) = val;
    weightingsInd(i) = ind;
    
end
% Find training image with smallest euclidean distance, for overall perople
[M, index] = min(weightingsDifference);

