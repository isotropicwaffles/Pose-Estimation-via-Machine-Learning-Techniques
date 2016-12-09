function [ out ] = pose2DCM( yaw, pitch, roll )
%POSE2DCM Summary of this function goes here
%   Converts yaw, pitch, roll, to a a 3x3 DCM. (ECol 1 is X vector, Col 2
%   is Y, Col 3 is Z)

R = generalRot(roll, 1, 0, 0);
P = generalRot(pitch, 0, 1, 0);
Y = generalRot(yaw, 0, 0, 1);

myRot = Y * P  * R;

out = [1 0 0 1 ; 0 1 0 1; 0 0 1 1]';
out = myRot * out;
out = out(1:3, 1:3);
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