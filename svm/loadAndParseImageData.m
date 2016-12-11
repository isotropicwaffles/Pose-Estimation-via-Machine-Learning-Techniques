function [ cube, cone, sphere, cubey, coney, spherey ] = loadAndParseImageData( dirName)
%LOADANDPARSEIMAGEDATA Summary of this function goes here
%   Detailed explanation goes here


ydata = importdata(sprintf('%s/poseData.txt', dirName));
cubey = ydata(1:500, :);
coney = ydata(501:1000, :);
spherey = ydata(1001:end, :);

[cube, cone, sphere] = importImages(dirName);

end

