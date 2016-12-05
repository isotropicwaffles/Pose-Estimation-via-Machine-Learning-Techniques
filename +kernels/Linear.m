classdef Linear < kernels.Kernel
    %This is a linear kernel class
    
    properties
    end
    
    methods
        function y = eval(obj,x1,x2)
            %just do the dot product
            y = dot(x1,x2);
        end
        
    end
    
end

