classdef GRBFImages < kernels.Kernel
    %GRBF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bandwidth = 1;
    end
    
    methods
        function obj = GRBFImages(bandwidth)
           obj.bandwidth = bandwidth; 
        end
        
        function y = eval(obj, x1, x2)
           x1 = reshape(x1.data, size(x1.data,1) * size(x1.data,2) * size(x1.data, 3), 1);
           x2 = reshape(x2.data, size(x2.data,1) * size(x2.data,2) * size(x2.data, 3), 1);
           y = exp(-norm(x1 - x2).^2 ./ (2*obj.bandwidth)); 
        end
    end
    
end

