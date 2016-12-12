%Assume we have cubePoint, conePoint, spherePoint
fid = fopen('logPoints.txt', 'a');
coordAscentPoints(cubePoint, 'cube', fid);
coordAscentPoints(conePoint, 'cone', fid);
coordAscentPoints(spherePoint, 'sphere', fid);
fclose(fid);

%Assume we have cube, cone, sphere, cubeY, coneY, sphereY
fid = fopen('logImages.txt', 'a');
coordAscentImages(cube, cubeY, 'cube', fid);
coordAscentImages(cone, coneY, 'cone', fid);
coordAscentImages(sphere, sphereY, 'sphere', fid);
fclose(fid);