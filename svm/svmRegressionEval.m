function [ y ] = svmRegressionEval( alphas, xout, b, x, k )
%SVMREGRESSIONEVAL Summary of this function goes here
%   Detailed explanation goes here

y = zeros(1, length(x));
for ii=1:length(y)
   for jj=1:length(xout)
       y(ii) = y(ii) + (alphas(jj,1) - alphas(jj,2))*k.eval(xout(jj), x(ii));
   end
end

y = y + b;



end

