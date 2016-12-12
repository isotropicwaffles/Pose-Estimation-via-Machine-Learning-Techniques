function [ cone, cube, sphere, coneY, cubeY, sphereY ] = importImages( dirName )
%IMPORTIMAGES Summary of this function goes here
%   Detailed explanation goes here

cone = cell(500, 1);
cube = cell(500, 1);
sphere = cell(500, 1);

for ii=1:500
    fn = sprintf('%s/cone_%d.bmp', dirName, ii);
    cone{ii} = importdata(fn);
    
    fn = sprintf('%s/cube_%d.bmp', dirName, ii);
    cube{ii} = importdata(fn);
    
    fn = sprintf('%s/sphere_%d.bmp', dirName, ii);
    sphere{ii} = importdata(fn);
end

for ii=1:500
        cone{ii} = (double(cone{ii}) -128)/255;
        cube{ii} = (double(cube{ii}) -128)/255;
        sphere{ii} = (double(sphere{ii}) -128)/255;
end

Y = importdata(sprintf('%s/poseData.txt', dirName));

cubeY = Y(1:500, :);
coneY = Y(501:1000, :);
sphereY = Y(1001:1500, :);

cubeY = [cubeY zeros(500, 6)];
coneY = [coneY zeros(500, 6)];
sphereY = [sphereY zeros(500, 6)];

for ii=1:500
    myTemp = pose2DCM(cubeY(ii, 3), cubeY(ii, 4), cubeY(ii, 5));
    cubeY(ii, 4:12) = [myTemp(:,1)' myTemp(:,2)', myTemp(:,3)'];
    
    myTemp = pose2DCM(coneY(ii, 3), coneY(ii, 4), coneY(ii, 5));
    coneY(ii, 4:12) = [myTemp(:,1)' myTemp(:,2)', myTemp(:,3)'];
    
    myTemp = pose2DCM(sphereY(ii, 3), sphereY(ii, 4), sphereY(ii, 5));
    sphereY(ii, 4:12) = [myTemp(:,1)' myTemp(:,2)', myTemp(:,3)'];
end

end

