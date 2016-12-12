classdef FeedForwardNN < handle
    %FEEDFORWARDNN A FF Neural Net using SoftMax and ReLU for
    %classification.
    %   Detailed explanation goes here
    
    properties
        D = []; %Input dimensionality
        k = []; %Number of classes
        layers = []; %A vector specifying the number of neurons in each hidden layer
        lastX = [];
        
    end
    
    methods
        function obj = FeedForwardNN(D, k, layersI)
            obj.D = D;
            obj.k = k;
            
            t = struct('W', [], 'b', [], 'z', [], 'a', [], 'd', []);
            obj.layers = repmat(t, length(layersI)+1, 1); %Hidden layers + output layer
            
            %Handle the first hidden layer differently
            m = D;
            obj.layers(1).W = normrnd(0, 1/sqrt(m), D, layersI(1));
            obj.layers(1).b = zeros(layersI(1), 1);
            
            %Handle the 2nd through penultimate layer
            for ii=2:length(layersI)
                m = layersI(ii-1);
                obj.layers(ii).W = normrnd(0, 1/sqrt(m), m, layersI(ii));
                obj.layers(ii).b = zeros(layersI(ii), 1);
            end
            
            %Handle the Soft-Max output layer
            obj.layers(end).W = normrnd(0, 1/sqrt(layersI(end)), layersI(end), k);
            obj.layers(end).b = zeros(k, 1);
        end
        
        function ForwardPropagation(obj, x)
            obj.lastX = x;
            %Handle the first hidden layer
            W = obj.layers(1).W;
            b = obj.layers(1).b;
            obj.layers(1).z = W'*x + b;
            
            %ReLU Implementation
            obj.layers(1).a = obj.layers(1).z;
            obj.layers(1).a(obj.layers(1).a < 0) = 0;
            
            %Handle the rest of the hidden layers
            for ii = 2:(length(obj.layers)-1)
                W = obj.layers(ii).W;
                b = obj.layers(ii).b;
                x = obj.layers(ii-1).a;
                obj.layers(ii).z = W'*x + b;
                
                %ReLU Implementation
                obj.layers(ii).a = obj.layers(ii).z;
                obj.layers(ii).a(obj.layers(ii).a < 0) = 0;
            end
            
            %Handle the Output layer
            W = obj.layers(end).W;
            b = obj.layers(end).b;
            x = obj.layers(end-1).a;
            obj.layers(end).z = W'*x + b;
            
            %Now do the damn Linear
            a = obj.layers(end).z;
            obj.layers(end).a = a;
            
        end
        
        %y is the TRUE classification labels
        function BackwardPropagation(obj, y)
            %Do the output layer "error"
            %obj.layers(end).d = obj.layers(end).a - y;
            obj.layers(end).d = 2 * (obj.layers(end).a - y);
            
            %Do all the other layers
            L = length(obj.layers);
            for ii=(L-1):-1:1
                %Calculate the "derivatives" of ReLU
                deriv = ReluGrad(obj.layers(ii).z);
                
                obj.layers(ii).d = deriv .* (obj.layers(ii+1).W * obj.layers(ii+1).d);
                
            end
        end
        
        function applyGradientStep(obj, eta)
            for ii=1:length(obj.layers)
               obj.layers(ii).b = obj.layers(ii).b - eta .* obj.layers(ii).d;
               
               if ii == 1
                   a = obj.lastX;
               else
                   a = obj.layers(ii-1).a;
               end
               
               obj.layers(ii).W = obj.layers(ii).W - eta .* (a * obj.layers(ii).d');
            end
        end
    end
    
end

