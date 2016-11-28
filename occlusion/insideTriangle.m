function [ inside ] = insideTriangle( triangle, p )
%INSIDETRIANGLE Summary of this function goes here
%   Detailed explanation goes here

tr = triangulation([1 2 3], triangle(1,:)', triangle(2,:)');
inside = ~any(tr.cartesianToBarycentric(1, p') < 0);


end

