function [ P ] = poseMat(x, y, z, yaw, pitch, roll  )
%POSEMAT Provides a transformation matrix for a translation and rotation
%   Based on glTranslate

%Translation Mat
tM = [ ...
    1 0 0 x; ...
    0 1 0 y; ...
    0 0 1 z; ...
    0 0 0 1 ...
    ];

%Start with roll, then add, pitch, and yaw
P = generalRot(roll, 1, 0, 0);
P = generalRot(pitch, 0, 1, 0)*P;
P = generalRot(yaw, 0, 0, 1)*P;

%Add translation
P = tM*P;


end

function R = generalRot(angle, x, y, z)
c = cosd(angle);
s = sind(angle);

%Normalize axis
l = norm([x y z]);
x = x ./ l;
y = y ./ l;
z = z ./ l;

R = zeros(4, 4);
R(1,1) = x^2*(1-c) + c;
R(1,2) = x*y*(1-c) - z*s;
R(1,3) = x*z*(1-c) + y*s;

R(2,1) = y*x*(1-c)+z*s;
R(2,2) = y.^2*(1-c)+c;
R(2,3) = y*z*(1-c) - x*s;

R(3,1) = x*z*(1-c) - y*s;
R(3,2) = y*z*(1-c) + x*s;
R(3,3) = z.^2*(1-c) + c;

R(4,4) = 1;
end

