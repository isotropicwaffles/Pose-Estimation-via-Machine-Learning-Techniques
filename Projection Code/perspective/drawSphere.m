function [V, T] = drawSphere()
%DRAWSPHERE Summary of this function goes here
%   Detailed explanation goes here

V = [];
T = [];

%Point at top
V = [V; 0 0 0.5 1];

%Point at bottom
V = [V; 0 0 -0.5 1];

%3 Circles +45 0 -45 latitude of 5 points
lats = 60:-30:-60;
lons = 0:30:330;

pointGrid = zeros(length(lats), length(lons));

for ii=1:length(lats)
   for jj=1:length(lons)
      R = 0.5 * cosd(lats(ii));
      Z = 0.5 * sind(lats(ii));
      X = cosd(lons(jj))*R;
      Y = sind(lons(jj))*R;
      tmp = [X Y Z 1.0];
      V = [V; tmp];
      pointGrid(ii, jj) = 2 + length(lons)*(ii-1) + jj;
   end
end

V = V';

%Set up triangles
%North Pole to Grid
for ii=1:(size(pointGrid, 2)-1)
    tmp = [1 pointGrid(1, ii) pointGrid(1, ii+1)];
    T = [T; tmp];
end
T = [T; 1 pointGrid(1,1) pointGrid(1, end)];

%South Pole to Grid
for ii=1:(size(pointGrid, 2)-1)
    tmp = [2 pointGrid(end, ii) pointGrid(end, ii+1)];
    T = [T; tmp];
end
T = [T; 2 pointGrid(end, 1) pointGrid(end,end)];

%Check the grid now
for ii=1:(size(pointGrid,1)-1)
   for jj=1:(size(pointGrid,2)-1)
      p1 = pointGrid(ii, jj);
      p2 = pointGrid(ii, jj+1);
      p3 = pointGrid(ii+1, jj);
      p4 = pointGrid(ii+1, jj+1);
      T = [T; p1 p2 p3; p2 p3 p4];
   end
   p1 = pointGrid(ii, end);
   p2 = pointGrid(ii, 1);
   p3 = pointGrid(ii+1, end);
   p4 = pointGrid(ii+1, 1);
   T = [T; p1 p2 p3; p2 p3 p4];
end

T = T';

end

