function [ alphas, xout, b ] = trainImageSVM( xdata, ydata, dim, bandwidth, C, epsilon )
%TRAINIMAGESVM Summary of this function goes here
%   Detailed explanation goes here

k = kernels.GRBFImages(bandwidth);
alphas = [];
xout = [];
b = [];
evalc('[alphas, xout, b] = svmRegression(xdata, ydata(:,dim), k, C, epsilon)');

end

