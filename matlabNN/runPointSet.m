function [ trainAcc, valAcc, testAcc, fullAcc ] = runPointSet( set, layers, eta )
%RUNSHAPESET Summary of this function goes here
%   Detailed explanation goes here

trainAcc = [];
valAcc = [];
testAcc = [];

D = 2*size(set.Points, 2);

TheNetwork = FeedForwardNN(D, 12, layers);

%Convert to big things of vectors
newSet = zeros(D, 500);
newSetY = zeros(12, 500);
for ii=1:500
    newSet(:, ii) = reshape(set.Runs(ii).Points, D, 1);
    newSetY(1:3,ii) = [set.Runs(ii).x set.Runs(ii).y set.Runs(ii).z]';
    tmp = pose2DCM(set.Runs(ii).yaw, set.Runs(ii).pitch, set.Runs(ii).roll);
    newSetY(4:end, ii) = [tmp(:, 1); tmp(:, 2); tmp(:, 3)];
end

trainX = newSet(:, 1:250);
trainY = newSetY(:, 1:250);
valX = newSet(:, 251:375);
valY = newSetY(:, 251:375);
testX = newSet(:, 376:end);
testY = newSetY(:, 376:end);

initialValAcc = testNetwork(TheNetwork, valX, valY);
fprintf('Initial Validation Performance: %f\n', initialValAcc);

keepRunning = true;
N = size(trainX, 2);
maxValAcc = inf;
failCount = 0;

while keepRunning
    %Train a single epoch
    for ii=1:N
        ix = randi(N);
        TheNetwork.ForwardPropagation(trainX(:, ix));
        TheNetwork.BackwardPropagation(trainY(:, ix));
        
        
        %What is the current eta?
        etaCur = (1/eta + length(valAcc))^-1;
        
        TheNetwork.applyGradientStep(etaCur);
        
    end
    
    %WE KNOW IT SAYS MAX ACC, BUT IS IN FACT MIN ERROR
    %Need to check if what our accuracy is
    curValAcc = testNetwork(TheNetwork, valX, valY);
    if curValAcc >= maxValAcc
        failCount = failCount + 1;
        if (failCount > 9)
            keepRunning = false;
        end
    else
        failCount = 0;
        maxValAcc = curValAcc;
    end
    valAcc = [valAcc; curValAcc];
    fprintf('Epoch %d Validation Accuracy: %f\n', length(valAcc), curValAcc);
    
    %Stop at 500 epochs
    if length(valAcc) > 4999
        keepRunning = false;
    end
    
    if isnan(curValAcc)
       %we've failed and need to return a bad measurement
       trainAcc = inf;
       valAcc = inf;
       testAcc = inf;
       return;
    end
    
end

trainAcc = testNetwork(TheNetwork, trainX, trainY);
testAcc = testNetwork(TheNetwork, testX, testY);

%Let's change the stuff and do some angles
fullAcc = zeros(4, 125);
for ii=1:125
    TheNetwork.ForwardPropagation(testX(:, ii));
    thisY = TheNetwork.layers(end).a;
    %Translation
    fullAcc(1, ii) = norm(thisY(1:3) - testY(1:3, ii));
    
    %X
    xReal = testY(4:6, ii);
    xPred = thisY(4:6);
    fullAcc(2, ii) = acosd(dot(xReal, xPred)./ norm(xReal) ./ norm(xPred));
    
    %Y
    yReal = testY(7:9, ii);
    yPred = thisY(7:9);
    fullAcc(3, ii) = acosd(dot(yReal, yPred) ./ norm(yReal) ./ norm(yPred));
    
    %Z
    zReal = testY(10:12, ii);
    zPred = thisY(10:12);
    fullAcc(4, ii) = acosd(dot(zReal, zPred) ./ norm(zReal) ./ norm(zPred));
    
end

end

function l2Err = testNetwork(aNetwork, valX, valY)
N = size(valX, 2);
l2Err = 0;

for ii=1:N
    aNetwork.ForwardPropagation(valX(:, ii));
    thisY = aNetwork.layers(end).a;
    
    l2Err = l2Err + norm(thisY - valY(:, ii)).^2;
    
end

l2Err = l2Err ./ N;
end