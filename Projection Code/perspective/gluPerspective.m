function [ out ] = gluPerspective( fov, near, far )
%GLUPERSPECTIVE Returns a projection matrix like gluPerspective
%   Detailed explanation goes here

f = cotd(fov/2);
x = (far + near)/(near - far);
y = (2*far*near)/(near - far);

%Assuming an aspect ratio of 1
out = [ ...
    f 0 0 0; ...
    0 f 0 0; ...
    0 0 x y; ...
    0 0 -1 0 ...
    ];
    


end

