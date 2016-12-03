function [ isOccluded ] = occludedByTriangle( t, p )
%OCCLUDEDBYTRIANGLE Checks is point p is occluded by triangle described by
%points in  t
%   Detailed explanation goes here

isOccluded = (insideTriangle(t(1:2, :), p(1:2, :)) && ~inFrontOf(t, p));



end

