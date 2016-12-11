function runFullSetImages( xdata, ydata, dim, fid)
%RUNFULLSET Summary of this function goes here
%   Detailed explanation goes here


%Coordinate ascent
C = 10.^linspace(-2, 6, 25);
bandwidth = 10.^linspace(-2, 2, 25);
epsilon = 10.^linspace(-3, 3, 25);

ixC = 1;
ixBW = 1;
ixEps = 1;

val = xdata(251:375);
test = xdata(376:500);
train = xdata(1:250);

valError = inf;
coordNum = 1;

while true
    %determine coordinate length
    if coordNum == 1
        N = length(C);
    elseif coordNum == 2
        N = length(bandwidth);
    elseif coordNum == 3
        N = length(epsilon);
    end
    
    coordValErrors = zeros(N, 1);
    lastGoodState = [ixC ixBW ixEps];
    for ii=1:N
       if coordNum == 1
           ixC = ii;
       elseif coordNum == 2
           ixBW = ii;
       elseif coordNum == 3
           ixEps = ii;
       end
       
       [alphas, xout, b] = trainImageSVM(train, ydata(1:250, :), dim, bandwidth(ixBW), C(ixC), epsilon(ixEps));
       yval = svmRegressionEval(alphas, xout, b, val, kernels.GRBFImages(bandwidth(ixBW)));
       coordValErrors(ii) =  rms(yval - ydata(251:375, dim)');
       fprintf('%d of %d\n', ii, N);
    end
    
    [newValError, newIx] = min(coordValErrors);
    
    fprintf('Current Validation Error: %f\n', min(valError, newValError));
    
    %Should we stop?
    if coordNum == 3 && newValError >= valError
       break;
    end
    
    %Update the params and continue
    if coordNum == 3
        valError = newValError;
    end
    if coordNum == 1
        ixC = newIx;
    elseif coordNum == 2
        ixBW = newIx;
    elseif coordNum == 3
        ixEps = newIx;
    end
    
    coordNum = coordNum + 1;
    if coordNum > 3
        coordNum = 1;
    end
    
end

ixC = lastGoodState(1);
ixBW = lastGoodState(2);
ixEps = lastGoodState(3);
fprintf(fid, 'Settings for Dim %d (C, BW, Epsilon): %f %f %f\n', dim, C(ixC), bandwidth(ixBW), epsilon(ixEps));

end

