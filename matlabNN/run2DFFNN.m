function [trainAcc, valAcc, testAcc, TheNetwork ] = run2DFFNN( setNo, layers, eta )
%RUN2DFFNN Runs a FeedForward NN on the 2d data set.
%   Detailed explanation goes here

valAcc = [];
trainAcc = [];

trainFn = sprintf('data%d_train.csv', setNo);
valFn = sprintf('data%d_validate.csv', setNo);
testFn = sprintf('data%d_test.csv', setNo);

%Load all the data
trainData = importdata(trainFn);
valData = importdata(valFn);
testData = importdata(testFn);

[trainX, trainY] = changeToOneHot(trainData);
[valX, valY]  = changeToOneHot(valData);
[testX, testY] = changeToOneHot(testData);

TheNetwork = FeedForwardNN(2, 2, layers);

%Let's print out the original validation performance
initialValAcc = testNetwork(TheNetwork, valX, valY);
fprintf('Initial Validation Performance: %f\n', initialValAcc);

%Going to need to continue until validation says to stop
keepRunning = true;
N = size(trainX, 2);
maxValAcc = 0;
failCount = 0;

while keepRunning
    %Train a single epoch
    %h = waitbar(0, 'Msg 1');
    for ii=1:N
        ix = randi(N);
        TheNetwork.ForwardPropagation(trainX(:, ix));
        TheNetwork.BackwardPropagation(trainY(:, ix));
        
        %What is the current eta
        etaCur = (1/eta + length(valAcc))^-1;
        
        TheNetwork.applyGradientStep(etaCur);
        %waitbar(ii ./ N, h);
    end
    %close(h);
    
    %Need to check if what are accuracy is
    curValAcc = testNetwork(TheNetwork, valX, valY);
    if curValAcc <= maxValAcc
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

%Ok, seems like it is trained now
%Lets get the final accuracy
trainAcc = testNetwork(TheNetwork, trainX, trainY);
testAcc = testNetwork(TheNetwork, testX, testY);
end

function [xdata, ydata] = changeToOneHot(in)

N = size(in, 1);
xdata = in(:, 1:2)';
ydata = zeros(2, N);

ix = (in(:,3) == 1);

ydata(1, ix) = 1;
ydata(2, ~ix) = 1;

end

function acc = testNetwork(aNetwork, valX, valY)
N = size(valX, 2);
correct = 0;

for ii=1:N
    aNetwork.ForwardPropagation(valX(:, ii));
    thisY = aNetwork.layers(end).a;
    
    [~, ixGuess] = max(thisY);
    [~, ixTruth] = max(valY(:, ii));
    
    if (ixGuess == ixTruth)
        correct = correct + 1;
    end
end

acc = correct ./ N;
end

