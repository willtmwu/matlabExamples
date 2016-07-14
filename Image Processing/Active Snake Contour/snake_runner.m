clear all;
close all; 

areas_inner = [];
areas_outer = [];

%figure(1);
for i=1:9
    filename = strcat('images\MRIheart(2)\MRI1_0', num2str(i), '.png');    
    [area_i, x_i, y_i, F] = snake_evol(filename, 50);
    areas_inner(i) = area_i;
    [area_o, x_o, y_o, F] = snake_evol(filename, 82);
    areas_outer(i) = area_o;
    
    %subplot(3,5,i);
    figure;
    imshow(F, []);
    title(strcat('Image', num2str(i), ';Area=', num2str(area_o-area_i))) 
    hold on;
    %plot(x_i,y_i, 'r*');
    plot(x_i,y_i, 'b');
    plot(x_o,y_o, 'g');
    axis([161 378 250 450])
    
    filename = strcat('result\MRI1_0', num2str(i), '.png'); 
    saveas(figure(i),filename)
end

for i=10:15
    filename = strcat('images\MRIheart(2)\MRI1_', num2str(i), '.png');    
    [area_i, x_i, y_i, F] = snake_evol(filename, 50);
    areas_inner(i) = area_i;
    [area_o, x_o, y_o, F] = snake_evol(filename, 82);
    areas_outer(i) = area_o;
    
    %subplot(3,5,i);
    figure;
    imshow(F, []);
    title(strcat('Image', num2str(i), ';Area=', num2str(area_o-area_i))) 
    hold on;
    plot(x_i,y_i, 'b');
    plot(x_o,y_o, 'g');
    axis([161 378 250 450])
    
    filename = strcat('result\MRI1_0', num2str(i), '.png'); 
    saveas(figure(i),filename)
end

%figure(2);
figure;
xlabel('Area of Ventricle Wall');
ylabel('Image Position in Given Dataset');
scatter(1:15, areas_outer - areas_inner);
hold on;
p = polyfit(1:15, areas_outer - areas_inner, 4);
y_p = polyval(p, 1:15);
plot(1:15, y_p);


