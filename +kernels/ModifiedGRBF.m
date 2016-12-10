classdef ModifiedGRBF < kernels.Kernel
    %MODIFIEDGRBF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bandwidth = 1;
    end
    
    methods
        function obj = ModifiedGRBF(bandwidth)
           obj.bandwidth = bandwidth; 
        end
        
        function y = eval(obj, x, z)
            occ = ~x.occluded & ~z.occluded;
            x = x.Points(:, :);
            z = z.Points(:, :);
            
            N = size(x,1) * size(x,2);
            x = reshape(x, N, 1);
            z = reshape(z, N, 1);
            
            y = exp(-norm(x - z).^2 ./ (2 .* obj.bandwidth));
        end
    end
    
end

