function y = reduce_dimension_pca(originalData, dim)

%originalData = csvread('pima_indians_diabetes_reduced.csv');
covX = cov(originalData);
[eigenVector,eigenValue] = eig(covX);
[eigenValue, sortOrder] = sort(diag(eigenValue), 'descend');
eigenVector = eigenVector(:,sortOrder);
reducedEigenVector = eigenVector(:,1:dim);
reducedData = (originalData)*(reducedEigenVector)

% %Reduced data plot
% figure(1);
% hold on
% scatter(reducedData(:,1:1), reducedData(:,2:2),'.');
% title('Reduced dataset');
% hold off
% 
% range = 1:1:length(eigenValue);
% %Scree graph
% figure(2);
% hold on
% plot(range, eigenValue,'b--o');
% title('Scree graph')
% xlabel('Eigenvectors')
% ylabel('Eigenvalues')
% hold off;
% 
% %Proportion of variance
% figure(3);
% hold on;
% prop = [];
% S = sum(eigenValue);
% for i=1:length(eigenValue)
%     prop = [prop sum(eigenValue(1:i))/S];
% end
% 
% plot(range, prop, 'b--o')
% title('Proportion of Variance')
% xlabel('Eigenvectors')
% ylabel('Prop of var')
% hold off;
% 
y = reducedData;
end