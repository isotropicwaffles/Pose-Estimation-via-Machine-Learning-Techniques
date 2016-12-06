function generatePointDataSet()
%GENERATEPOINTDATASET Creates data set for points
%   Will save the following format for each shape (Cube, Cone, Sphere):
%   Shape Struct -
%    Points (3xN) - Model geometry
%    Runs (1xR)
%     yaw
%     pitch
%     roll
%     x
%     y
%     z
%     Points 2xN Point Pixel Space (Normalized)
%     1xN Occluded? (Is the point occluded?)
%
%    Limits of translation and Z -distance chosen to take approximately a
%    fifth to a 3rd of the fov

projM = gluPerspective(60.0, 1, 50);

cube = struct();
[V, T] = drawCube();
cube.Points = V(1:3, :);
cube.Runs = [];
h = waitbar(0, 'Cube Runs... 0/500');
for ii=1:500
   curRun = struct();
   x = rand()*3.0 - 1.5;
   y = rand()*3.0 - 1.5;
   z = rand()*-1.7320 - 2.5981;
   yaw = rand() * 360;
   pitch = rand() * 180 - 90;
   roll = rand() * 180;
   P = poseMat(x, y, z, yaw, pitch, roll);
   myP = projM*P*V;
   occ = checkOcclusion(myP, T);
   curRun.yaw = yaw;
   curRun.pitch = pitch;
   curRun.roll = roll;
   curRun.x = x;
   curRun.y = y;
   curRun.z = z;
   curRun.Points = myP(1:2, :) ./ repmat(myP(4, :), 2, 1);
   curRun.Occluded = occ;
   cube.Runs = [cube.Runs; curRun];
   waitbar(ii ./ 500, h, sprintf('Cube Runs... %d/500', ii));
end
close(h);

cone = struct();
[V, T] = drawCone();
cone.Points = V(1:3, :);
cone.Runs = [];
h = waitbar(0, 'Cone Runs... 0/500');
for ii=1:500
   curRun = struct();
   x = rand()*3.0 - 1.5;
   y = rand()*3.0 - 1.5;
   z = rand()*-1.7320 - 2.5981;
   yaw = rand() * 360;
   pitch = rand() * 180 - 90;
   roll = rand() * 180;
   P = poseMat(x, y, z, yaw, pitch, roll);
   myP = projM*P*V;
   occ = checkOcclusion(myP, T);
   curRun.yaw = yaw;
   curRun.pitch = pitch;
   curRun.roll = roll;
   curRun.x = x;
   curRun.y = y;
   curRun.z = z;
   curRun.Points = myP(1:2, :) ./ repmat(myP(4, :), 2, 1);
   curRun.Occluded = occ;
   cone.Runs = [cone.Runs; curRun];
   waitbar(ii ./ 500, h, sprintf('Cone Runs... %d/500', ii));
end
close(h);

sphere = struct();
[V, T] = drawSphere();
sphere.Points = V(1:3, :);
sphere.Runs = [];
h = waitbar(0, 'Sphere Runs... 0/500');
for ii=1:500
   curRun = struct();
   x = rand()*3.0 - 1.5;
   y = rand()*3.0 - 1.5;
   z = rand()*-1.7320 - 2.5981;
   yaw = rand() * 360;
   pitch = rand() * 180 - 90;
   roll = rand() * 180;
   P = poseMat(x, y, z, yaw, pitch, roll);
   myP = projM*P*V;
   occ = checkOcclusion(myP, T);
   curRun.yaw = yaw;
   curRun.pitch = pitch;
   curRun.roll = roll;
   curRun.x = x;
   curRun.y = y;
   curRun.z = z;
   curRun.Points = myP(1:2, :) ./ repmat(myP(4, :), 2, 1);
   curRun.Occluded = occ;
   sphere.Runs = [sphere.Runs; curRun];
   waitbar(ii ./ 500, h, sprintf('Sphere Runs... %d/500', ii));
end
close(h);

save PointDataSet.mat cube cone sphere

end

