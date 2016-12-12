function coordAscentImages( set, setY, setName, fid )
%COORDASCENTPOINTS Summary of this function goes here
%   Detailed explanation goes here

layers = [0 2 8 32 128 256];
eta = [1e-2 1e-3 1e-4 1e-5 1e-6 1e-8];

%Layer 1, Layer 2, Layer 3, Layer 4, Layer 5, Eta
indexes = [2 1 1 1 1 1 1];

keepRunning = true;
epochCount = 0;
bestIndexes = indexes;
bestValErr = inf;

while keepRunning
   %Start a whole parameter set run
   
   for ii=1:length(indexes)
      %For every single hyperparameter....
      
      %What is the number of values to test over?
      if ii < length(indexes)
          %A layer setting
          numTests = length(layers);
      else
          %The eta setting
          numTests = length(eta);
      end
      
      myTestValErrors = zeros(numTests, 1);
      for jj=1:numTests
         %For every test value
         testEta = eta(indexes(end));
         testLayers = layers(indexes(1:5));
         %Drop those layers which are zero
         testLayers = testLayers(testLayers > 0);
         
         try
            [trainAcc, valAcc, testAcc] = runShapeSet(set, setY, testLayers, testEta);
         catch
            trainAcc = inf;
            valAcc = inf;
            testAcc = inf;
         end
         myTestValErrors(jj) = valAcc(end);
         %End for every test value
      end
      
      %Which test value was the best
      [Y, I] = min(myTestValErrors);
      curValError = Y;
      indexes(ii) = I;
      if curValError < bestValErr
          bestValErr = curValError;
          bestIndexes = indexes;
      end
      
      %End for every single hyperparameter...
   end
   
   epochCount = epochCount + 1;
   if epochCount > 4
       break;
   end
   %End a whole parameter set run
end

%Print out the results
fprintf(fid, 'Set %s: %d %d %d %d %d %f\n', setName, ...
    layers(bestIndexes(1)), layers(bestIndexes(2)), layers(bestIndexes(3)), ...
    layers(bestIndexes(4)), layers(bestIndexes(5)), eta(bestIndexes(6)));
end

