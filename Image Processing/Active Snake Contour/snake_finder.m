% Active Contour Model - Snakes
clear all;
close all;

im=imread('images\MRIheart(2)\MRI1_10.png');
im=double(im);

figure
imshow(im,[]);
title('Input image');

% Use a sobel mask to find the gradient iamge
s_vert=-fspecial('sobel');
s_horz=s_vert';

% Calculate the gradient information. 
im_vert=imfilter(im,s_vert,'replicate');
im_horz=imfilter(im,s_horz,'replicate');

% figure
% imshow(im_vert,[])
% title('Vertical gradients')
% figure
% imshow(im_horz,[])
% title('Horizontal gradients')

% Calculate and normalise the negative gradient magnitude
% This becomes the external force field for spline 
F=sqrt(im_horz.*im_horz+im_vert.*im_vert);
%F=F/(max(max(F)));
F=-F;
figure
imshow(F,[])
title('Inverse magnitude of gradient vector')

% Calculate the spatial derivatives of the external force field
F_vert=imfilter(F,s_vert,'replicate');
F_horz=imfilter(F,s_horz,'replicate');
% 
% figure
% imshow(F_horz,[])
% title('X derivative of force field')
% figure
% imshow(F_vert,[])
% title('Y derivative of force field')

[X,Y]=meshgrid([1 1:24:size(im,2)],[1 1:24:size(im,1)]);
figure
meshc(flipud(-F))
hold on
axis image
title('Gradient vectors and contour lines')

% Define the number of points in the spline
N=30;

% Create the spline in the shape of a circle
x0=48*cos(0:(2*pi/(N)):(2*pi-(2*pi/(N))))+275;
y0=-48*sin(0:(2*pi/(N)):(2*pi-(2*pi/(N))))+359;

% Define weights for the internal energy terms
%w1=0.000001;
%w2=0.01;

w1=0.000001;
w2=0.009;

% Define constants for the stiffness matrix, based on the weights
alpha=w2;
beta=-w1-4*w2;
gamma=-2*w1+6*w2;

% Define the step size to take on each iteration
%lambda = 0.2; % Stiff system
%lambda=0.1; % Unstiff system
lambda = 0.05;

% Define Stiffness matrix. The code below is just a smart way of doing
% this independently of the number of nodes.
% A =[gamma       beta        alpha       0           0       0       alpha       beta;
%     beta        gamma       beta        alpha       0       0       0           alpha;
%     alpha       beta        gamma       beta        alpha   0       0           0;
%     0           alpha       beta        gamma       beta    alpha   0           0;
%     0           0           alpha       beta        gamma   beta    alpha       0;
%     0           0           0           alpha       beta    gamma   beta        alpha;
%     alpha       0           0           0           alpha   beta    gamma       beta;
%     beta        alpha       0           0           0       alpha   beta        gamma];

A=diag(beta,-N+1)+...
  diag(alpha*ones(1,2),-N+2)+...
  diag(alpha*ones(1,N-2),-2)+...
  diag(beta*ones(1,N-1),-1)+...
  diag(gamma*ones(1,N),0)+...
  diag(beta*ones(1,N-1),+1)+...
  diag(alpha*ones(1,N-2),2)+...
  diag(alpha*ones(1,2),N-2)+...
  diag(beta,N-1);

% Initialise x and y
x=x0';
y=y0';

% The maximum number of iterations
maxiter=200;

% Weight given to external field
omega=1;

% Overlay spline on top
figure;
imshow(F,[])
title('Snake position')
hold on

% Begin Evolutionary snake
% iter=0;
% while(iter<maxiter)
%     c=rand(1,3);                % Randomly color the snake
%     plot(x,y,'*','color',c)     % Plot the points of the spline
%     plot(x,y)                   % Plot the spline itself
%     iter=iter+1 
%     
%     % Find the values of the negative gradient magnitude
%     M_horz = zeros(N,1);
%     M_vert= zeros(N,1);
%     pos_x = round(x)+1;
%     pos_y = round(y)+1;
%     for i=1:N
%         M_horz(i) = F_horz(pos_y(i), pos_x(i));
%         M_vert(i) = F_vert(pos_y(i), pos_x(i));
%     end
%                 
%     % Calculate this iteration
%     x=(inv(A+lambda*eye(N)))*(lambda*x-omega*M_horz);
%     y=(inv(A+lambda*eye(N)))*(lambda*y-omega*M_vert);
%     drawnow;  
%     
%     polyarea(x,y)
% end

% 7.5507e+03 ; 7.9241e+03 ; 7.3485e+03; 6.7899e+03; 5.8951e+03; 6.4359e+03;
% 5.9721e+03 ; 6.4162e+03 ; 5.6520e+03 6.4434e+03
% 


