classdef GRBF < kernels.Kernel
    %GRBF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bandwidth = 1;
    end
    
    methods
        function obj = GRBF(bandwidth)
           obj.bandwidth = bandwidth; 
        end
        
        function y = eval(obj, x1, x2)
           y = exp(-norm(x1 - x2).^2 ./ (2*obj.bandwidth)); 
        end
    end
    
end

