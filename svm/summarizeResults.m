[conex, coney] = convertSetToStruct(cone.Runs);
[cubex, cubey] = convertSetToStruct(cube.Runs);
[spherex, spherey] = convertSetToStruct(sphere.Runs);

coneParams = [ ...
    8697.490026 83.021757 4.328761; ...
1629.750835 18.738174 2.848036; ...
 10000.000000 100.000000 4.328761; ...
 65.793322 29.836472 0.012328; ...
151.991108 35.938137 0.006136; ...
132.194115 27.185882 0.043288];

cubeParams = [ ...
1873.817423 6.734151 0.001000; ...
5722.367659 17.073526 3.764936; ...
2848.035868 14.174742 0.533670; ...
21.544347 4.641589 0.001748; ...
26560.877829 62.802914 0.006136; ...
65.793322 8.111308 0.018738];

sphereParams = [ ...
20092.330026 100.000000 0.464159; ...
3274.549163 52.140083 0.001000; ...
705.480231 8.111308 1.417474; ...
9.326033 15.556761 0.009326; ...
70548.023107 100.000000 0.012328; ...
1873.817423 100.000000 0.049770];



%Cone
for ii=1:6
   C = coneParams(ii, 1);
   BW = coneParams(ii, 2);
   epsilon = coneParams(ii,3);
   dim = ii;
   [alphas, xout, b] = trainSVM(conex(1:250), coney(:, 1:250), dim, BW, C, epsilon);
   trainY = svmRegressionEval(alphas, xout, b, conex(1:250), kernels.ModifiedGRBF(BW));
   trainRes = trainY - coney(dim, 1:250);
   valY = svmRegressionEval(alphas, xout, b, conex(251:375), kernels.ModifiedGRBF(BW));
   valRes = valY - coney(dim, 251:375);
   testY = svmRegressionEval(alphas, xout, b, conex(376:end), kernels.ModifiedGRBF(BW));
   testRes = valY - coney(dim, 376:end);
   
   fprintf('Cone Dim %d (Train, Val, Test): %f %f %f\n', dim, rms(trainRes), rms(valRes), rms(testRes));
   size(alphas)
end

%Cube
for ii=1:6
   C = cubeParams(ii, 1);
   BW = cubeParams(ii, 2);
   epsilon = cubeParams(ii,3);
   dim = ii;
   [alphas, xout, b] = trainSVM(cubex(1:250), cubey(:, 1:250), dim, BW, C, epsilon);
   trainY = svmRegressionEval(alphas, xout, b, cubex(1:250), kernels.ModifiedGRBF(BW));
   trainRes = trainY - cubey(dim, 1:250);
   valY = svmRegressionEval(alphas, xout, b, cubex(251:375), kernels.ModifiedGRBF(BW));
   valRes = valY - cubey(dim, 251:375);
   testY = svmRegressionEval(alphas, xout, b, cubex(376:end), kernels.ModifiedGRBF(BW));
   testRes = valY - cubey(dim, 376:end);
   
   fprintf('Cube Dim %d (Train, Val, Test): %f %f %f\n', dim, rms(trainRes), rms(valRes), rms(testRes));
   size(alphas)
end

%Sphere
for ii=1:6
   C = sphereParams(ii, 1);
   BW = sphereParams(ii, 2);
   epsilon = sphereParams(ii,3);
   dim = ii;
   [alphas, xout, b] = trainSVM(spherex(1:250), spherey(:, 1:250), dim, BW, C, epsilon);
   trainY = svmRegressionEval(alphas, xout, b, spherex(1:250), kernels.ModifiedGRBF(BW));
   trainRes = trainY - spherey(dim, 1:250);
   valY = svmRegressionEval(alphas, xout, b, spherex(251:375), kernels.ModifiedGRBF(BW));
   valRes = valY - spherey(dim, 251:375);
   testY = svmRegressionEval(alphas, xout, b, spherex(376:end), kernels.ModifiedGRBF(BW));
   testRes = valY - spherey(dim, 376:end);
   
   fprintf('Sphere Dim %d (Train, Val, Test): %f %f %f\n', dim, rms(trainRes), rms(valRes), rms(testRes));
   size(alphas)
end


%Ok, let's do the image data
[cubeI, coneI, sphereI, cubeIY, coneIY, sphereIY] = loadAndParseImageData('../Projection Code/opengl/data64');

coneParams = [ ...
    464158.883361 100.000000 0.100000; ...
4641.588834 14.677993 0.001000; ...
46415.888336 0.100000 0.001778; ...
215.443469 0.010000 0.056234; ...
21544.346900 0.146780 5.623413; ...
0.215443 100.000000 0.001000];

cubeParams = [ ...
    21544.346900 21.544347 0.031623; ...
0.010000 0.010000 0.001000; ...
46415.888336 0.010000 0.001000; ...
21544.346900 0.068129 0.056234; ...
464158.883361 68.129207 1.000000; ...
4641.588834 0.010000 0.316228];

sphereParams = [ ...
    0.010000 0.010000 0.001000; ...
10000.000000 68.129207 0.003162; ...
4641.588834 0.068129 0.001000; ...
0.100000 0.010000 0.001000; ...
464158.883361 0.146780 0.003162; ...
0.464159 0.010000 0.010000];

%Cone
for ii=1:6
   C = coneParams(ii, 1);
   BW = coneParams(ii, 2);
   epsilon = coneParams(ii,3);
   dim = ii;
   [alphas, xout, b] = trainImageSVM( coneI(1:250), coneIY(1:250, :), dim, BW, C, epsilon );
   trainY = svmRegressionEval(alphas, xout, b, coneI(1:250), kernels.GRBFImages(BW));
   trainRes = trainY - coneIY(1:250, dim)';
   valY = svmRegressionEval(alphas, xout, b, coneI(251:375), kernels.GRBFImages(BW));
   valRes = valY - coneIY(251:375, dim)';
   testY = svmRegressionEval(alphas, xout, b, coneI(376:end), kernels.GRBFImages(BW));
   testRes = valY - coneIY(376:end, dim)';
   
   fprintf('Cone Image Dim %d (Train, Val, Test): %f %f %f\n', dim, rms(trainRes), rms(valRes), rms(testRes));
   size(alphas)
end

%Cube
for ii=1:6
   C = cubeParams(ii, 1);
   BW = cubeParams(ii, 2);
   epsilon = cubeParams(ii,3);
   dim = ii;
   [alphas, xout, b] = trainImageSVM( cubeI(1:250), cubeIY(1:250, :), dim, BW, C, epsilon );
   trainY = svmRegressionEval(alphas, xout, b, cubeI(1:250), kernels.GRBFImages(BW));
   trainRes = trainY - cubeIY(1:250, dim)';
   valY = svmRegressionEval(alphas, xout, b, cubeI(251:375), kernels.GRBFImages(BW));
   valRes = valY - cubeIY(251:375, dim)';
   testY = svmRegressionEval(alphas, xout, b, cubeI(376:end), kernels.GRBFImages(BW));
   testRes = valY - cubeIY(376:end, dim)';
   
   fprintf('Cube Image Dim %d (Train, Val, Test): %f %f %f\n', dim, rms(trainRes), rms(valRes), rms(testRes));
   size(alphas)
end

%Sphere
for ii=1:6
   C = sphereParams(ii, 1);
   BW = sphereParams(ii, 2);
   epsilon = sphereParams(ii,3);
   dim = ii;
   [alphas, xout, b] = trainImageSVM( sphereI(1:250), sphereIY(1:250, :), dim, BW, C, epsilon );
   trainY = svmRegressionEval(alphas, xout, b, sphereI(1:250), kernels.GRBFImages(BW));
   trainRes = trainY - sphereIY(1:250, dim)';
   valY = svmRegressionEval(alphas, xout, b, sphereI(251:375), kernels.GRBFImages(BW));
   valRes = valY - sphereIY(251:375, dim)';
   testY = svmRegressionEval(alphas, xout, b, sphereI(376:end), kernels.GRBFImages(BW));
   testRes = valY - sphereIY(376:end, dim)';
   
   fprintf('sphere Image Dim %d (Train, Val, Test): %f %f %f\n', dim, rms(trainRes), rms(valRes), rms(testRes));
   size(alphas)
end

