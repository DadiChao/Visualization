clear all;

% Parameters
light = [2,1,-3];
z_img = -5;
A = 4;

% Draw Cube
cube_x=linspace(0,1,40);
cube_y=linspace(0,1,40);
[cube_x,cube_y]=meshgrid(cube_x,cube_y);
cube_z = A*cube_x+ A*cube_y;
mesh(cube_x,cube_y,cube_z)
hold on
axis on
grid on
view([45,45])
xlabel('x-axis')
ylabel('y-axis')
zlabel('z-axis')
title('The graph of a cube.');

% Add Light
cube_x_max = max(max(cube_x));
cube_x_min = min(min(cube_x));
cube_y_max = max(max(cube_y));
cube_y_min = min(min(cube_y));
start_z1 = A * (cube_x_min + cube_y_min);
start_z2 = A * (cube_x_min + cube_y_max);
start_z3 = A * (cube_x_max + cube_y_min);
start_z4 = A * (cube_x_max + cube_y_max);
temp1 = (z_img - start_z1) / light(3);
temp2 = (z_img - start_z2) / light(3);
temp3 = (z_img - start_z3) / light(3);
temp4 = (z_img - start_z4) / light(3);
target1 = [cube_x_min, cube_y_min, start_z1] + temp1 * light;
target2 = [cube_x_min, cube_y_max, start_z2] + temp2 * light;
target3 = [cube_x_max, cube_y_min, start_z3] + temp3 * light;
target4 = [cube_x_max, cube_y_max, start_z4] + temp4 * light;


% Draw image
img_tri1 = [target1; target2; target4];
img_tri2 = [target1; target3; target4];
trisurf([1 2 3],img_tri1(:,1), img_tri1(:,2), img_tri1(:,3),'FaceColor','green','EdgeColor','none');
hold on
trisurf([1 2 3],img_tri2(:,1), img_tri2(:,2), img_tri2(:,3),'FaceColor','green','EdgeColor','none');