close all;
clear all;

%Load all Camera Projection Matrix, Images and Silhouettes data
%Into the View structures, 1 for each separate image
projection_data;
for i = 1:36
    I = imread(sprintf('dino/dino%02d.jpg', i-1));
    
    View(i).image = I;
    %Segment the image by color and clean for noise
    I = I(:,:,1)> I(:,:,3);
    I = imclearborder(I);
    I = imfill(I, 'holes');
    I = imopen(I, strel('disk', 5));
    View(i).silhouette = I;
    
    View(i).projection = P_Mat(:,:,i);
end

%Create Voxel Space
x_minimum = -180;   x_maximum = 90;
y_minimum = -80;    y_maximum = 70;
z_minimum =  20;    z_maximum = 460;
total_voxels = 10000000;

%Specify Ranges for x,y,z data
carving_volume = (x_maximum-x_minimum)*(y_maximum-y_minimum)...
                    *(z_maximum-z_minimum);
Voxel_Space.resolution = (carving_volume/total_voxels)^(1/3);
x_range = x_minimum:Voxel_Space.resolution:x_maximum;
y_range = y_minimum:Voxel_Space.resolution:y_maximum;
z_range = z_minimum:Voxel_Space.resolution:z_maximum;

%Create a meshgrid and convert to a vector
[mesh_X,mesh_Y,mesh_Z] = meshgrid(x_range,y_range,z_range);
Voxel_Space.X = mesh_X(:);
Voxel_Space.Y = mesh_Y(:);
Voxel_Space.Z = mesh_Z(:);

clearvars -except View Voxel_Space

%Carve the voxel space with views
for i=1:36
    voxel_X = Voxel_Space.X;
    voxel_Y = Voxel_Space.Y;
    voxel_Z = Voxel_Space.Z;
    
    %Project voxel points onto image coordinates
    v = [voxel_X, voxel_Y, voxel_Z, ones(numel(voxel_X),1)];
    pixel = View(i).projection * v';
    pixel_x = round(pixel(1,:)./pixel(3,:));
    pixel_y = round(pixel(2,:)./pixel(3,:));
    
    %Remove pixels outside image dimensions
    [height,width,depth] = size(View(i).image);
    keep_index = find((pixel_x>=1) & (pixel_x<=width) ...
                    & (pixel_y>=1) & (pixel_y<=height));
    pixel_x = pixel_x(keep_index);
    pixel_y = pixel_y(keep_index);
    
    %Remove pixels not in silhouette
    image_index = sub2ind([height,width], round(pixel_y), round(pixel_x));
    keep_index = keep_index(View(i).silhouette(image_index) >= 1);
    
    Voxel_Space.X = Voxel_Space.X(keep_index);
    Voxel_Space.Y = Voxel_Space.Y(keep_index);
    Voxel_Space.Z = Voxel_Space.Z(keep_index);
end

%Display the voxel carving 
Voxel_Space.Z = -Voxel_Space.Z;

%Recreate encompassing meshgrid to show 3D carving
uniq_x = unique(Voxel_Space.X);
uniq_y = unique(Voxel_Space.Y);
uniq_z = unique(Voxel_Space.Z);
uniq_x = [uniq_x(1)-Voxel_Space.resolution; ...
                uniq_x; uniq_x(end)+Voxel_Space.resolution];
uniq_y = [uniq_y(1)-Voxel_Space.resolution; ...
                uniq_y; uniq_y(end)+Voxel_Space.resolution];
uniq_z = [uniq_z(1)-Voxel_Space.resolution; ...
                uniq_z; uniq_z(end)+Voxel_Space.resolution];
[mesh_X,mesh_Y,mesh_Z] = meshgrid(uniq_x,uniq_y,uniq_z);

%Sets points
V = zeros(size(mesh_X));
for i=1:numel(Voxel_Space.X)
    ix = (uniq_x == Voxel_Space.X(i));
    iy = (uniq_y == Voxel_Space.Y(i));
    iz = (uniq_z == Voxel_Space.Z(i));
    V(iy,ix,iz) = 1;
end

dino_surface = patch(isosurface(mesh_X,mesh_Y,mesh_Z, V, 0.5));
isonormals(mesh_X,mesh_Y,mesh_Z,V,dino_surface);
set(dino_surface, 'FaceColor', 'g', 'EdgeColor', 'none');
set(gca, 'DataAspectRatio', [1 1 1]);
lighting('gouraud');
camlight('right');
camlight
view(-140, 22);
axis('tight');




