function [ V, T ] = drawCone()
%DRAWCONE Summary of this function goes here
%   Detailed explanation goes here

V = [];
angles = 0:5:355;
for ii=1:length(angles)
   x = cosd(angles(ii)) / 2;
   y = sind(angles(ii)) / 2;
   V = [V; x y 0.5 1];
end

V = [V; 0 0 -0.5 1];
V = [V; 0 0 0.5 1];
V = V';

T = [];
n = size(V,2);
for ii=1:(length(angles)-3)
    T = [T; ii ii+1 n];
    T = [T; ii ii+1 n-1];
end
T = [T; ii+1 1 n];
T = [T; ii+1 1 n-1];
T = T';


%Add some bonus points now!
for ii=1:5
   phase = 360/5*ii;
   x = cosd(phase)*.25;
   y = sind(phase)*.25;
   tmp = [x y 0 1]';
   V = [V tmp];
end
end

