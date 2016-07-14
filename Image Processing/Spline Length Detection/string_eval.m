function [ final_length, BW_string ] = string_eval( calibration_1, length_1, calibration_2, length_2, string_image )
    CI_1 = rgb2gray(imread(calibration_1));
    CI_2 = rgb2gray(imread(calibration_2));
    SI = rgb2gray(imread(string_image));
    
    CL_1 = -1;
    CL_2 = -1;
    final_length = -1;
    
    for i=1:3
        if i==1
            im=double(CI_1);
        elseif i==2
            im=double(CI_2);
        elseif i==3
            im=double(SI);
        end
        
        s_vert=-fspecial('sobel');
        s_horz=s_vert';
        im_vert=imfilter(im,s_vert,'replicate');
        im_horz=imfilter(im,s_horz,'replicate');
        F=abs(sqrt(im_horz.*im_horz+im_vert.*im_vert));
        F(F<0.3*max(max(F))) = 0;
        F(F>0.3*max(max(F))) = 255;
    
        
        T = im2bw(F, 100/255);
        T = bwmorph(T, 'close', Inf);
        T = bwmorph(T, 'thin', Inf);

        if i==1
            CL_1 = length_1/sum(sum(T));        
        elseif i==2
            CL_2 = length_2/sum(sum(T)) ;       
        elseif i==3
            CL = (CL_1+CL_2)/2;
            final_length = CL*sum(sum(T));
            BW_string = T;
        end
        
    end
end

