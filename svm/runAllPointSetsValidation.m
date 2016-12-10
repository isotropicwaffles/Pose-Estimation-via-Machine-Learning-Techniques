function  runAllPointSetsValidation( cone, cube, sphere )
%RUNALLPOINTSETSVALIDATION Summary of this function goes here
%   Detailed explanation goes here

fid = fopen('log.txt', 'a');

fprintf(fid, 'Cone runs...\n');
for ii=1:6
   runFullSet(cone.Runs, ii, fid); 
end

fprintf(fid, 'Cube runs...\n');
for ii=1:6
   runFullSet(cube.Runs, ii, fid); 
end

fprintf(fid, 'Sphere runs...\n');
for ii=1:6
   runFullSet(sphere.Runs, ii, fid); 
end

fclose(fid);
system('shutdown /s');

