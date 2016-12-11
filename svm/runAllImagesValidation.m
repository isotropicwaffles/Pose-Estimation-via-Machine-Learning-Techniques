function  runAllImagesValidation( cone, cube, sphere, coney, cubey, spherey )
%RUNALLPOINTSETSVALIDATION Summary of this function goes here
%   Detailed explanation goes here

fid = fopen('logImages.txt', 'a');

fprintf(fid, 'Cone runs...\n');
for ii=1:6
   runFullSetImages(cone, coney, ii, fid); 
end

fprintf(fid, 'Cube runs...\n');
for ii=1:6
   runFullSetImages(cube, cubey, ii, fid); 
end

fprintf(fid, 'Sphere runs...\n');
for ii=1:6
   runFullSetImages(sphere, spherey, ii, fid); 
end

fclose(fid);
%system('shutdown /s');

