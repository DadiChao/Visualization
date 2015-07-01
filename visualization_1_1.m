clear all;
% Parameters
center = [1,1,1];
rho = 6;
% Precision
prc = 256;
% Z index of image
surf_img = -7;
% Light
light = [2,1,-1];

theta = linspace(0,2*pi,40);
phi = linspace(0,pi,40);
[theta,phi] = meshgrid(theta,phi);
sphere_x = center(1) + rho*sin(phi).*cos(theta);
sphere_y = center(2) + rho*sin(phi).*sin(theta);
sphere_z = center(3) + rho*cos(phi);

mesh(sphere_x,sphere_y,sphere_z);
hold on
% Avoid view eclipse % axis equal
% Turn on the grid
grid on

% Rotate the plot into the standard orientation.
view([10,10])

% Determine the light
[x_pla,y_pla,z_pla]=meshgrid(center(1)-rho:rho/40:center(1)+rho);
fun = @(x_pla,y_pla,z_pla)light(1)*x_pla+light(2)*y_pla+light(3)*z_pla;
n_pla = fun(x_pla,y_pla,z_pla);
% isosurface(x_pla,y_pla,z_pla,n_pla);
% Add annotations.
xlabel('x-axis')
ylabel('y-axis')
% Determine the point and mesh of image
point_test = center;
img = center + (center(3) - surf_img) * light / norm(light);
x_img = img(1) * ones(prc*2);
y_img = img(2) * ones(prc*2);
z_img = surf_img*ones(prc*2);
index = 1;

temp_x = 1;
temp_y = 1;
temp_z = -temp_x*light(1)/light(3) - temp_x*light(2)/light(3);
temp = [temp_x,temp_y,temp_z];

%quiver3(1, 1, 1, temp(1), temp(2), temp(3), 1);

for theta_pla = 0:pi/prc:pi*2-pi/prc;
    M = [cos(theta_pla)+(1-cos(theta_pla))*light(1)*light(1),...
        (1-cos(theta_pla))*light(1)*light(2)-(sin(theta_pla))*light(3),...
        (1-cos(theta_pla))*light(1)*light(3)+(sin(theta_pla))*light(2);...
        (1-cos(theta_pla))*light(2)*light(1)+(sin(theta_pla))*light(3),...
        cos(theta_pla)+(1-cos(theta_pla))*light(2)*light(2),...
        (1-cos(theta_pla))*light(2)*light(3)-(sin(theta_pla))*light(1);...
        (1-cos(theta_pla))*light(3)*light(1)-(sin(theta_pla))*light(2),...
        (1-cos(theta_pla))*light(3)*light(2)+(sin(theta_pla))*light(1),...
        cos(theta_pla)+(1-cos(theta_pla))*light(3)*light(3);];
    %vec_start = [light(1)/3^.5,light(2)/3^.5,light(3)/3^.5] * M;
    vec_rho = [1/3^.5,1/3^.5,temp_z/3^.5] / norm(temp) * rho * M;
    %quiver3(center(1), center(2), center(3), vec_rho(1), vec_rho(2), vec_rho(3), 2);
    point_test = center +  vec_rho;
    img = point_test + (point_test(3) - surf_img) * light / norm(light);
    x_img(index) = img(1);
    y_img(index) = img(2);
    %z_img(index) = img(3);
    z_img(index) = surf_img;
    %plot3(point_test(1),point_test(2),point_test(3),'r.', 'MarkerSize', 15);
    %plot3(img(1),img(2),img(3),'r.', 'MarkerSize', 15);
    index = index+1;
end

surf(x_img,y_img,z_img);

% Add annotations.
xlabel('x-axis')
ylabel('y-axis')
title('SPHERE')