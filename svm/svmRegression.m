function [ alphas, xout, b ] = svmRegression( x, y, k, C, epsilon )
%SVMREGRESSION Performs an SVM regression of given x, y, and kernel k
%   x - rows are dimensions, columns are data samples
%   y - rows are dimensions, columns are data samples
%   k - a single kernel object that implements eval(x, z) method

xout = [];
alphas = [];
b = [];
N = size(x, 2);

%Calculate the K matrix
K = zeros(N, N);
for ii=1:N
   for jj=ii:N
      K(ii, jj) = k.eval(x(:,ii), x(:,jj)); 
   end
end
K = K + triu(K, 1)';

%Setup the variables for the quadratic programming
H = [K -K; -K K];
f = [epsilon - y'; epsilon + y'];
Aeq = [ones(N, 1); -1*ones(N,1)]';
beq = 0;
lb = zeros(2*N, 1);
ub = repmat(C , 2*N, 1);
alphas = quadprog(H, f, [], [], Aeq, beq, lb, ub);

%Almost zero test
alphaTol = mean(alphas)*1e-4;
alphas = reshape(alphas, N, 2);
ix = (alphas(:,1) > alphaTol) | (alphas(:,2) > alphaTol);
alphas = alphas(ix, :);
xout = x(:, ix);
K = K(ix, ix);
y = y(ix);

%Calculate b
marginPoints = find((alphas(:,1) < C) | (alphas(:,2) < C));
b = 0;
for ii=1:length(marginPoints)
    ix = marginPoints(ii);
    b = b + y(ix) - epsilon - sum((alphas(:, 1) - alphas(:,2)).*K(:,ix));
end

b = b ./ length(marginPoints);


end

