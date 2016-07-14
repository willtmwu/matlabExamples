clear all;
close all; 


for i=1:3
    figure;
    for j=1:5
        imread('String1_1.jpg');
        filename = strcat('String', num2str(i), '_', num2str(j), '.jpg');    
        [length, image] = string_eval('String1_1.jpg', 13, 'String2_1.jpg', 15.5, filename);
        
        subplot(2,5,j);
        imshow(image, []);
        title(strcat(filename, '=', num2str(length), 'cm') )
        
        subplot(2,5,j+5);       
        imshow(imread(filename), []);
        title(strcat(filename, '=', num2str(length), 'cm') )
    end
end
% 
% CI_1 = rgb2gray(imread('String1_1.jpg'));
%     
%     
%     CL_1 = -1;
%     CL_2 = -1;
%     final_length = -1;
%     
%     i = 1;
%         if i==1
%             im=double(CI_1);
%         elseif i==2
%             im=double(CI_2);
%         elseif i==3
%             im=double(SI);
%         end
%         
%         s_vert=-fspecial('sobel');
%         s_horz=s_vert';
%         im_vert=imfilter(im,s_vert,'replicate');
%         im_horz=imfilter(im,s_horz,'replicate');
%         F=abs(sqrt(im_horz.*im_horz+im_vert.*im_vert));
%         F(F<0.3*max(max(F))) = 0;
%        F(F>0.3*max(max(F))) = 255;
%         
%         
%         T = im2bw(F, 100/255);
%         figure;
%         imshow(T, []);
%         
%         T = bwmorph(T, 'close', Inf);
%         figure;
%         imshow(T, []);
%         T = bwmorph(T, 'thin', Inf);
%         figure;
%         imshow(T, []);
% 
%         if i==1
%             CL_1 = length_1/sum(sum(T));        
%         elseif i==2
%             CL_2 = length_2/sum(sum(T)) ;       
%         elseif i==3
%             CL = (CL_1+CL_2)/2;
%             final_length = CL*sum(sum(T));
%             BW_string = T;
%         end
%         
