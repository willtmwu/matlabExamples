%Hough Transform - Straight Line Finding
close all;
clear all; 

im = imread('tajmahal2004 - Copy.jpg');
im = rgb2gray(im);

%Edge Detection
figure(1);
BW = edge(im, 'canny', 0.3);
imshow(BW, []);
[xpx, ypx] = find(BW);
title('Detected Edge Pixels');

%Hough Transform
[H,T,R] = hough(BW, 'RhoResolution', 5, 'Theta', [-90:0.2:89]);
figure(2);
imshow(H, [], 'XData', T, 'YData', R, 'InitialMagnification','fit');
axis on, axis normal, hold on;
P = houghpeaks(H, 5, 'threshold', ceil(0.5*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
colormap(jet);
plot(x,y,'s', 'color', 'white');

%Line Plotting
x0 = 1;
xend = size(im,2); 
figure, imshow(im), hold on
for i=1:length(P)
    dist = R(P(i,1));
    deg = T(P(i,2));
    
    if (deg == 0)
        line([dist dist], [1 size(im,1)], 'Color', 'green');
    else
        y0 = (-cosd(deg)/sind(deg))*x0 + (dist / sind(deg)); 
        yend = (-cosd(deg)/sind(deg))*xend + (dist / sind(deg));
        line([x0 xend], [y0 yend], 'Color', 'red');
    end
end