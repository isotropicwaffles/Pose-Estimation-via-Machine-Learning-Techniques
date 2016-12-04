function unitTest()
%UNITTEST Summary of this function goes here
%   Detailed explanation goes here

projM = gluPerspective(60.0, 1, 50);

% Test Rotations and Translations
% figure; hold on;
% 
% P = poseMat(1, 7, 10, 0, 0, 0);
% plotPose(P);
% pause(5);
% for ii=1:360
%    P = poseMat(1, 7, 10, 0, 0, ii);
%    plotPose(P);
%    pause(.05);
% end

% % Test Cube
% [V T] = drawCube();
% P = poseMat(0, 0, 0, 0, 0, 0);
% V = P*V;
% plot3(V(1, :), V(2, :), V(3, :), 'b.');

% %Cube Occlusion Test
% [V, T] = drawCube();
% x = rand()*3.0 - 1.5;
% y = rand()*3.0 - 1.5;
% z = rand()*-1.7320 - 2.5981;
% yaw = rand() * 360;
% pitch = rand() * 180 - 90;
% roll = rand() * 180;
% P = poseMat(x, y, z, yaw, pitch, roll);
% occ = checkOcclusion(projM*P*V, T);
% drawPoints(projM*P*V, occ);
% V = projM*P*V; V = V ./ V(4, :);
% plot3(V(1, [1 2]), V(2, [1 2]), -V(3, [1 2]), 'k--');
% plot3(V(1, [2 3]), V(2, [2 3]), -V(3, [2 3]), 'k--');
% plot3(V(1, [3 4]), V(2, [3 4]), -V(3, [3 4]), 'k--');
% plot3(V(1, [4 1]), V(2, [4 1]), -V(3, [4 1]), 'k--');
% 
% plot3(V(1, [5 6]), V(2, [5 6]), -V(3, [5 6]), 'k--');
% plot3(V(1, [6 7]), V(2, [6 7]), -V(3, [6 7]), 'k--');
% plot3(V(1, [7 8]), V(2, [7 8]), -V(3, [7 8]), 'k--');
% plot3(V(1, [8 5]), V(2, [8 5]), -V(3, [8 5]), 'k--');
% 
% plot3(V(1, [1 5]), V(2, [1 5]), -V(3, [1 5]), 'k--');
% plot3(V(1, [2 6]), V(2, [2 6]), -V(3, [2 6]), 'k--');
% plot3(V(1, [3 7]), V(2, [3 7]), -V(3, [3 7]), 'k--');
% plot3(V(1, [4 8]), V(2, [4 8]), -V(3, [4 8]), 'k--');
% xlim([-1 1]);
% ylim([-1 1]);
% zlim([-1 1]);

% %Cone occlusion test
% [V, T] = drawCone();
% x = rand()*3.0 - 1.5;
% y = rand()*3.0 - 1.5;
% z = rand()*-1.7320 - 2.5981;
% yaw = rand() * 360;
% pitch = rand() * 180 - 90;
% roll = rand() * 180;
% P = poseMat(x, y, z, yaw, pitch, roll);
% occ = checkOcclusion(projM*P*V, T);
% drawPoints(projM*P*V, occ);
% V = projM*P*V; V = V ./ V(4, :);
% xlim([-1 1]);
% ylim([-1 1]);
% zlim([-1 1]);

%Sphere Occlusion Test
[V, T] = drawSphere();
x = rand()*3.0 - 1.5;
y = rand()*3.0 - 1.5;
z = rand()*-1.7320 - 2.5981;
yaw = rand() * 360;
pitch = rand() * 180 - 90;
roll = rand() * 180;
P = poseMat(x, y, z, yaw, pitch, roll);
occ = checkOcclusion(projM*P*V, T);
drawPoints(projM*P*V, occ);
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);
end

function plotPose(P)
points = [ ...
    0 0 0 1;
    1 0 0 1;
    0 1 0 1;
    0 0 1 1;
    ]';

%Apply pose
points = P*points;

cla;
hold on;
styles = {'r-' 'g-' 'b-'};
for ii=1:3
   tmp = points(:, [1 ii+1]);
   plot3(tmp(1,:), tmp(2,:), tmp(3,:), styles{ii});
end
drawnow();
end

function drawPoints(V, occ)
hold on;
V = V ./ V(4, :);
plot3(V(1,~occ), V(2, ~occ), -V(3, ~occ), 'bp');
plot3(V(1,occ), V(2, occ), -V(3, occ), 'r*');
xlabel('X');
ylabel('Y');
zlabel('Z');

end