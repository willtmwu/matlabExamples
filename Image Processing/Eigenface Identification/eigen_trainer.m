function [ reducedEigenFaces,  weights, imageMean, imageMatrix] = eigen_trainer( directory )

files = dir(strcat(directory, '*.bmp'));

% Load and concatenate all images into a 3D matrix
trainingImages = imread(strcat(directory, files(1).name));
for i = 2:length(files)
    I =imread(strcat(directory, files(i).name));   
    trainingImages = cat(3, trainingImages,  I);
end

% dimensions of image
[imageHeight,imageWidth,imageNum] = size(trainingImages);
imageDepth = imageHeight*imageWidth;

% vectorize images, so each image exists as a single column
imageMatrix = reshape(trainingImages,[imageDepth imageNum]);
imageMatrix = double(imageMatrix);

% subtract mean from all images
imageMean = mean(imageMatrix,2);
imageMatrix=bsxfun(@minus, imageMatrix, imageMean);

% calculate covariance of the image matrix
imageCov = cov(imageMatrix);

% obtain eigenvalue & eigenvector from the covariance matrix
[eigenVects,eigenVals] = eig(imageCov);

% sort eigenvalues and eigenvectors in descending order
[eigenVals, sortOrder] = sort(diag(eigenVals), 'descend');
eigenVects = eigenVects(:,sortOrder);

% reduce the eigenvectors to a lower dimension, 
% ensuring at least 95% variance is kept
eigenSum = sum(eigenVals);
cSum = 0;
for i = 1:imageNum
    cSum = cSum + eigenVals(i);
    pov = cSum/eigenSum;
    if pov >= 0.95
        dim = i;
        break
    end ;
end;
reducedEigenVects = eigenVects(:,1:dim);

% Project the originalImages into the eigenFaces
reducedEigenFaces = (imageMatrix)*(reducedEigenVects);

% Normalise the eigenfaces
for i = 1:dim
    reducedEigenFaces(:,i) = reducedEigenFaces(:,i)/norm(reducedEigenFaces(:,i));
end


% Find the weights of all the training images,
% when the images are projected onto the eigenFaces
for i = 1:length(files)
    faceImage = imread(strcat(directory, files(i).name));
    imageWeightings = reducedEigenFaces'*(double(reshape(faceImage,[imageDepth 1])) - imageMean);
    weights(i).image = imageWeightings;
end

end

