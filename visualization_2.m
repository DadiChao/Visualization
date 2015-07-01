% Ray Trace Algorithm
% by Zhao Dadi, 143732, Dec.10 2014
% This file only supports UTF-8, Chinese is not available

% Index
% Mar: matrix
% Poi: point
% Sur: surface
% Vec: vector
% Var: varaiable

clear all;

%% STEP 1 Determine the viewing axis in the object coordinate system & points

% Source point
Poi_eye = [0,0,10];

% Define object parameters
Var_obj_ver = [1 1 1; 1 2 1; 2 2 1; 2 1 1 ; 1 1 2; 1 2 2; 2 2 2; 2 1 2];
Var_obj_fac = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4; 1 2 6 5; 5 6 7 8];

figure(1)
hold on
grid on
view(30,30)
xlabel('x');
ylabel('y');
zlabel('z');

% Draw P_eye
text(Poi_eye(1), Poi_eye(2), Poi_eye(3), 'P_e_y_e');
scatter3(Poi_eye(1), Poi_eye(2), Poi_eye(3));

% Draw object
patch('Faces',Var_obj_fac,'Vertices',Var_obj_ver,'FaceColor','y');
material shiny;
alpha('color');
alphamap('rampdown');

%% STEP 2 Determine the imaging plane

Var_pla_edg = 2;
Var_pla_met = 0.05;
Var_pla_ones = 2 * Var_pla_edg / Var_pla_met + 1;
Var_pla_z = 5;
% Image plane parameters
[Sur_pla_x,Sur_pla_y] = meshgrid(-Var_pla_edg:Var_pla_met:Var_pla_edg, -Var_pla_edg:Var_pla_met:Var_pla_edg);
Sur_pla_z = Var_pla_z*ones(Var_pla_ones,Var_pla_ones);

% Draw image plane
% surf(Sur_pla_x,Sur_pla_y,Sur_pla_z)   % or using 'surf()'

%% STEP 3 Determine the direction of light vector

Vec_light_z = [0,0,-1];
Var_lamda_z = 6;
Vec_light_xoy = [1,1,0];
Var_lamda_xoy = 1;
theta_z = 3*pi/2;
% Mar_rotation = exp([0,-theta_z,0;theta_z,0,0;0,0,0]);
Mar_rotation = [cos(theta_z) -sin(theta_z) 0; sin(theta_z) cos(theta_z) 0; 0 0 0];
Vec_light = Vec_light_z * Var_lamda_z + Vec_light_xoy * Var_lamda_xoy * Mar_rotation;
quiver3(Poi_eye(1), Poi_eye(2), Poi_eye(3), Vec_light(1), Vec_light(2), Vec_light(3), 1);

lamda_temp = (Poi_eye(3) - Var_pla_z) / abs(Vec_light(3));
Target = Vec_light * lamda_temp + Poi_eye;

plot3(Target(1), Target(2), Target(3), 'r.', 'MarkerSize', 15);

%% STEP 4 Ray intersects the object to determine the circumstances

Mar_img = zeros(Var_pla_ones,Var_pla_ones);
%Mar_img_ssd = zeros(Var_pla_ones,Var_pla_ones);
Mar_img_mip = zeros(Var_pla_ones,Var_pla_ones);
Mar_img_drr = zeros(Var_pla_ones,Var_pla_ones);
for Var_lamda_z = 0 : Var_pla_met/2 : Poi_eye(3)-min(min(Var_obj_ver));
    for Var_lamda_xoy = 0 : Var_pla_met/2 : (Poi_eye(3)-min(Var_obj_ver(:,3)))/(Poi_eye(3)-Var_pla_z)*Var_pla_edg;
        for theta_z = 0 : Var_pla_met*pi/5 : 2*pi;
            Mar_rotation = [cos(theta_z) -sin(theta_z) 0; sin(theta_z) cos(theta_z) 0; 0 0 0];
            Target = Poi_eye + Vec_light_z * Var_lamda_z + Vec_light_xoy * Var_lamda_xoy * Mar_rotation;
            if Target(1)>1 && Target(1)<2 && Target(2)>1 && Target(2)<2 && Target(3)>1 && Target(3)<2;
                % plot3(Target(1), Target(2), Target(3), 'r.', 'MarkerSize', 15);
                temp = (Poi_eye(3) - Var_pla_z) / (Poi_eye(3) - Target(3));
                % plot3(Target(1)*temp, Target(2)*temp, Var_sur, 'r.', 'MarkerSize', 15);
                Var_disp_x = Var_pla_edg / Var_pla_met + 1 + floor(temp * Target(1) / Var_pla_met);
                Var_disp_y = Var_pla_edg / Var_pla_met + 1 + floor(temp * Target(2) / Var_pla_met);
                Mar_img(Var_disp_x,Var_disp_y) = Mar_img(Var_disp_x,Var_disp_y) + 1;
                Mar_img_drr(Var_disp_x,Var_disp_y) = Mar_img_drr(Var_disp_x,Var_disp_y) + norm(Target);
                if Mar_img_mip(Var_disp_x,Var_disp_y) < norm(Target);
                    Mar_img_mip(Var_disp_x,Var_disp_y) = norm(Target);
                end
            end
        end
    end
end

%% STEP 5 Calculate pixel value
figure(1)
Sur_pla_z = Sur_pla_z + Mar_img / max(max(Mar_img));
surf(Sur_pla_x,Sur_pla_y,Sur_pla_z);

figure(2)
image(Mar_img);
title('Image');

%% SSD,MIP,DDR
A = max(max(Mar_img));
B = min(min(Mar_img));
[m,n] = size(Mar_img);
Mar_img_ssd1 = Mar_img;
Mar_img_ssd2 = Mar_img;

for i = 1:1:m;
    for j = 1:1:n;
        if Mar_img(i,j) > A*0.1 && Mar_img(i,j) < A*0.3;
            Mar_img_ssd1(i,j) = 1000;
        else
            Mar_img_ssd1(i,j) = 0;
        end
        if Mar_img(i,j) > A*0.3 && Mar_img(i,j) < A*0.7;
            Mar_img_ssd2(i,j) = 1000;
        else
            Mar_img_ssd2(i,j) = 0;
        end
    end
end
figure(3)
subplot(2,2,1)
image(Mar_img_ssd1);
title('SSD1 0.1<C<0.3');
subplot(2,2,2)
image(Mar_img_ssd2);
title('SSD2 0.3<C<0.7');
subplot(2,2,3)
image(Mar_img_mip);
title('MIP');
subplot(2,2,4)
image(Mar_img_drr);
title('DRR');