function [ cube, cone, sphere ] = importImages( myDir )
%IMPORTIMAGES Summary of this function goes here
%   Detailed explanation goes here

cube = repmat(struct('data', []), 500, 1);
cone = repmat(struct('data', []), 500, 1);
sphere = repmat(struct('data', []), 500, 1);
h = waitbar(0, 'Loading Images.. 0/500');

for ii=1:500
   fn = sprintf('%s/cube_%d.bmp', myDir , ii);
   a = importdata(fn);
   cube(ii).data = normalize(a);
   
   fn = sprintf('%s/cone_%d.bmp', myDir, ii);
   a = importdata(fn);
   cone(ii).data = normalize(a);
   
   fn = sprintf('%s/sphere_%d.bmp', myDir, ii);
   a = importdata(fn);
   sphere(ii).data = normalize(a);
   
   waitbar(ii ./ 500, h, sprintf('Loading Images %d/500', ii));
end

close(h);

end

function output = normalize(input)
    output = (double(input) - 128)/128;
end

