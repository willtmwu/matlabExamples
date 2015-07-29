close all;
%clear all;

%a = randn(200,2);
b = a + 4;
c = a;
c(:,1) = 3*c(:,1);
c = c - 4;
d = [a; b];
e = [a; b; c];

colorRange = ['y+'; 'm.'; 'rx'; 'co'; 'g*'];
[k_centres, clusterData, clusterSize] = k_means_cluster(e, 8);
clusterSize = [0; clusterSize];

figure(1);
hold on;
for i = [1:1:length(clusterSize)-1]
    drawSet = clusterData((clusterSize(i,:)+1):clusterSize(i+1,:),:);
    plot(drawSet(:,1),drawSet(:,2),colorRange(mod(i,length(colorRange)) + 1,:));
end
plot(k_centres(:,1),k_centres(:,2),'pk');
hold off;

