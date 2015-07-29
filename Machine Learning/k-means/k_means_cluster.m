function [k_centers, orderedSet, sizeOfClusters] = k_means_cluster(dataSpace, k_means)

%Assume data is N-rows by N-dimensions (in this general case 2)
Threshold = 0.01;
Max_iterations = 20;

%Initialise K-means 
index = randperm(length(dataSpace),k_means);
k_centers = dataSpace(index,:);
of_cluster = zeros(length(dataSpace), 1);
orderedSet = [];

for i = [1:1:Max_iterations] 
    for j = [1:1:length(dataSpace)]
        testPoint = dataSpace(j,:);
        currentCluster = 0;
        currentSmallestDistance = bitmax;
        
        for k = [1:1:length(k_centers)]
            distance = pdist2(k_centers(k,:), testPoint);
            
            if distance < currentSmallestDistance
                currentCluster = k;
                currentSmallestDistance = distance;
            end
        end
        
        of_cluster(j,:) = currentCluster;
    end
   
    for m = [1:1:length(k_centers)]
        xCentre = [];
        yCentre = [];
        for l = [1:1:length(dataSpace)]
            if of_cluster(l,:) == m
                clusterPoint = dataSpace(l,:);
                xCentre = [xCentre clusterPoint(:,1)];
                yCentre = [yCentre clusterPoint(:,2)];
            end
        end
        %Average and move the k-centers
        k_centers(m,:) = [mean(xCentre) mean(yCentre)];    
    end
    
    fprintf('Iteration %d complete\n',i);
    
end;


    sizeOfClusters= [];
    for p = [1:1:length(k_centers)]
        xCentre = [];
        yCentre = [];
        for q = [1:1:length(dataSpace)]
            if of_cluster(q,:) == p
                clusterPoint = dataSpace(q,:);
                xCentre = [xCentre clusterPoint(:,1)];
                yCentre = [yCentre clusterPoint(:,2)];
            end
        end
        
        orderedSet = [orderedSet; transpose(xCentre) transpose(yCentre)];
        S = size(orderedSet);
        sizeOfClusters = [sizeOfClusters; S(:,1)];
    end
end