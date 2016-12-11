function [ trainAcc, valAcc, testAcc ] = runShapeSet( set, setY, layers, eta )
%RUNSHAPESET Summary of this function goes here
%   Detailed explanation goes here

trainAcc = [];
valAcc = [];
testAcc = [];

TheNetwork = FeedForwardNN(12288, 12, layers);

%Convert to big things of vectors
newSet = zeros(12288, 500);
for ii=1:500
    newSet(:, ii) = reshape(set{ii}, 12288, 1);
end

trainX = newSet(:, 1:250);
trainY = setY(1:250, :);
valX = newSet(:, 251:375);
valY = setY(251:375, :);
testX = newSet(:, 376:end);
testY = setY(376:end, :);

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
        TheNetwork.BackwardPropagation(trainY(ix,:)');
        
        
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
    
end

trainAcc = testNetwork(TheNetwork, trainX, trainY);
testAcc = testNetwork(TheNetwork, testX, testY);

end

function l2Err = testNetwork(aNetwork, valX, valY)
N = size(valX, 2);
l2Err = 0;

for ii=1:N
    aNetwork.ForwardPropagation(valX(:, ii));
    thisY = aNetwork.layers(end).a;
    
    l2Err = l2Err + norm(thisY - valY(ii, :)').^2;
    
end

l2Err = l2Err ./ N;
end