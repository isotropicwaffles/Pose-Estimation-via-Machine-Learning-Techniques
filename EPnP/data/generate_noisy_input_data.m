function [A,runs]=generate_noisy_input_data(data,std_noise,draw_plot)
%type = 1     cube
%type = 2     cone
%type = 3      sphere
% Copyright (C) <2007>  <Francesc Moreno-Noguer, Vincent Lepetit, Pascal Fua>
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the version 3 of the GNU General Public License
% as published by the Free Software Foundation.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
% General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.
%
% Francesc Moreno-Noguer, CVLab-EPFL, September 2007.
% fmorenoguer@gmail.com, http://cvlab.epfl.ch/~fmoreno/
runs = cell(size(data.Runs));
if nargin<3 draw_plot=''; end

%true 3d position of the points--------------
% xini=-2; xend=2;%bounds
% yini=-2; yend=2;
% zini=4; zend=9;



%Assuming pixel pitch of 2 microns
random_points_flag = 1;
num_points = 4;
pitch = 55e-6;
FOV = 60;%Degrees

%u0=320; v0=240;
width=512; height=512;
u0=width/2; v0=height/2;

focal_plane_xsize = width*pitch;
focal_plane_ysize = height*pitch;

f= .5*focal_plane_xsize/tand(FOV/2);

fx=f/pitch; %focal length in pixels
fy=f/pitch;

%intrinsic camera parameters------------------
% fx=800; %focal length in pixels
% fy=800;
%f=0.05; %50 mm of focal length

%m=fx/f;
m=1; f=1; %<<<<<<----------------------------

A=[fx/m 0 u0/m 0; 0 fy/m v0/m 0; 0 0 1 0];
std_noise=std_noise*(1/m);

if random_points_flag
    points_indx = unique(round(size(data.Points,2)*rand(num_points,1)));
    
    while numel(points_indx)<num_points
        points_indx = unique(round(size(data.Points,2)*rand(num_points,1)));
    end
    
    n = num_points;
else
    n = size(data.Points,2);
    
    points_indx = 1:n;
end

for jj = 1:numel(runs)
    clear point
    
    for ii = 1:numel(points_indx)
        
        Xcam= poseMat(data.Runs(jj).x, data.Runs(jj).y,data.Runs(jj).z, data.Runs(jj).yaw, data.Runs(jj).pitch, data.Runs(jj).roll)*[data.Points(:,points_indx(ii)); 1];
        point(ii).Xcam(1,1)=Xcam(1);
        point(ii).Xcam(2,1)=Xcam(2);
        point(ii).Xcam(3,1)=-Xcam(3);
        %project points into the image plane
        point(ii).Ximg_true=data.Runs(jj).Points(:,points_indx(ii)).*width/2+width/2;
        
        point(ii).Ximg_true(3)=f;
        
        %coordinates in pixels
        point(ii).Ximg_pix_true=point(ii).Ximg_true(1:2)*m;
        
        %check if the point is into the limits of the image
        uv=point(ii).Ximg_pix_true;
        %  fprintf('%.1f,%.1f,%d\n',uv(1),uv(2),i);
        
        noise=randn(1,2)*std_noise;
        point(ii).Ximg(1,1)=point(ii).Ximg_true(1)+noise(1);
        point(ii).Ximg(2,1)=point(ii).Ximg_true(2)+noise(2);
        point(ii).Ximg(3,1)=f;
        
        %noisy coordinates in pixels
        point(ii).Ximg_pix=point(ii).Ximg(1:2)*m;
        
    end
    
    %the observed data will not be in the camera coordinate system. We put the center of the
    %world system on the centroid of the data. We also assume that the data is rotated with
    %respect to the camera coordenate system.
    centroid=[0 0 0]';
    for i=1:n
        centroid=centroid+point(i).Xcam;
    end
    centroid=centroid/n;
    
    
    
    for i=1:n
        point(i).Xworld=point(i).Xcam;
    end
    runs{jj} = point;
    
end
end
%
% %plot noisy points in the image plane
% if ~strcmp(draw_plot,'donotplot')
%     figure; hold on;
%     for i=1:n
%         plot(point(i).Ximg_pix_true(1),point(i).Ximg_pix_true(2),'.','color',[1 0 0]);
%         %txt=sprintf('%d',i);
%         %text(point(i).Xcam(1),point(i).Xcam(2),point(i).Xcam(3),txt);
%         plot(point(i).Ximg_pix(1),point(i).Ximg_pix(2),'o','color',[0 1 0],'markersize',5);
%     end
%     title('Noise in image plane','fontsize',20);
%     grid on;
% end
%





%draw 3d points
% figure; hold on;
% representation_offset=10;
% plot3(0,0,0,'.','color',[0 0 0],'markersize',20);
% for i=1:n
%    plot3(point(i).Xcam(1),point(i).Xcam(2),point(i).Xcam(3),'.','color',[1 0 0],'markersize',12);
%    txt=sprintf('%d',i);
%    text(point(i).Xcam(1),point(i).Xcam(2),point(i).Xcam(3),txt);
%    plot3(point(i).Xworld(1)+representation_offset,point(i).Xworld(2),point(i).Xworld(3),'.','color',[0.8 0.8 0],'markersize',12);
%    text(point(i).Xworld(1)+representation_offset,point(i).Xworld(2),point(i).Xworld(3),txt);
%    plot3(point(i).Ximg(1),point(i).Ximg(2),point(i).Ximg(3),'.','color',[0 0 1],'markersize',12);
% end
% grid on;
%
