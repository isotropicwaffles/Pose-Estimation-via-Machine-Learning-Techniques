function [ out, outy] = convertSetToStruct( xdata )
%CONVERTSETTOSTRUCT Summary of this function goes here
%   Detailed explanation goes here

out = struct('Points', [], 'occluded', []);
out = repmat(out, length(xdata), 1);

outy = zeros(6, length(xdata));

for ii=1:length(out)
   out(ii).Points = xdata(ii).Points;
   out(ii).occluded = xdata(ii).Occluded;
   outy(:, ii) = [xdata(ii).yaw xdata(ii).pitch xdata(ii).roll xdata(ii).x xdata(ii).y xdata(ii).z];
end


end

