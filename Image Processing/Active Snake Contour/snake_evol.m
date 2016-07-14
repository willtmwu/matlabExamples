function [area,x,y,F]  = snake_evol( filename , radius)

im=imread(filename);
im=double(im);

% Use a sobel mask to find the gradient iamge
sobel_v = -fspecial('sobel');
sobel_h = sobel_v';

% Calculate the gradient information. 
im_v=imfilter(im,sobel_v,'replicate');
im_h=imfilter(im,sobel_h,'replicate');

% Calculate and normalise the negative gradient magnitude
% This becomes the external force field for the spline 
F=sqrt(im_h.*im_h+im_v.*im_v);
F=F/(max(max(F)));
F=-F;

% Calculate the spatial derivatives of the external force field
F_v=imfilter(F,sobel_v,'replicate');
F_h=imfilter(F,sobel_h,'replicate');

% Define the number of points in the spline
N=50;

% Create the spline in the shape of a circle
x0=radius*cos(0:(2*pi/(N)):(2*pi-(2*pi/(N))))+275;
y0=-radius*sin(0:(2*pi/(N)):(2*pi-(2*pi/(N))))+359;

% Define weights for the internal energy terms
w1=-0.000015;
w2=0.03;


% Define constants for the stiffness matrix, based on the weights
alpha=w2;
beta=-w1-4*w2;
gamma=-2*w1+6*w2;

% Define the step size to take on each iteration
lambda = 0.1;

% Define the stiffness matrix, load in the alpha,beta,gamma values
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

% Weight given to external field, set to 0 or 1.
omega=1;

% Loop
iter=0;
while(iter<maxiter)
    iter=iter+1 
    
    % Find the values of the negative gradient magnitude
    M_h = zeros(N,1);
    M_v= zeros(N,1);
    pos_x = round(x)+1;
    pos_y = round(y)+1;
    for i=1:N
        M_h(i) = F_h(pos_y(i), pos_x(i));
        M_v(i) = F_v(pos_y(i), pos_x(i));
    end
                
    % Calculate this iteration
    x=(inv(A+lambda*eye(N)))*(lambda*x-omega*M_h);
    y=(inv(A+lambda*eye(N)))*(lambda*y-omega*M_v);
end

area = polyarea(x,y)

end

