function [out] = ReluGrad(in)
    out = in;
    
    out(in > 0) = 1;
    out(in < 0) = 0;
    out(in == 0) = 0; %This is where we change the subgradient
end