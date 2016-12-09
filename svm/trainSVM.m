function [ alphas, xout, b ] = trainSVM( xdata, ydata, dim, bandwidth, C, epsilon )
%TRAINSVM Summary of this function goes here
%   dim - dimension of pose data to fit to


%Train SVM
k = kernels.ModifiedGRBF(bandwidth);
alphas = [];
xout = [];
b = [];
evalc('[alphas, xout, b] = svmRegression(xdata, ydata(dim, :), k, C, epsilon)');

end

