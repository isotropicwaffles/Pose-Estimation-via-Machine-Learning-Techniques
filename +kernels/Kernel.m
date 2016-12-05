classdef Kernel 
    %This is an abstract class for kernels which defines 
    %the interface for kernel classes
    
    properties
    end
    
    methods(Abstract)
      y = eval(obj,x1,x2)
    end
    
end

