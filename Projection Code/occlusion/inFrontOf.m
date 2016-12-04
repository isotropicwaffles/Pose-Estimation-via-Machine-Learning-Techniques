function [ inFront ] = inFrontOf( triangle, p )
%INFRONTOF Checks if the 3d point p is closer to the screen than triangle
%   Closer to the screen defined as in a more positive z coordinate

%triangle is a 3x3 matrix; each column is a point of the triangle

u1 = triangle(:,1) - triangle(:,2);
u2 = triangle(:,3) - triangle(:,2);
normalVector = cross(u1, u2);

% Multiplying by the sign of n dot z+ insures this is the normal point
% AWAY FROM the screen
normalVector = normalVector .* sign(dot(normalVector, [0; 0; 1]));

inFront = dot(normalVector, p(1:3) - triangle(:, 2)) <= 1e-3;

end

