function [ inside ] = insideTriangle( triangle, p )
%INSIDETRIANGLE Summary of this function goes here
%   Detailed explanation goes here


%Test to make sure we are not in plane with the triangle
A = unique(triangle', 'rows');
if (size(A, 1) < 3)
    inside = false;
    return;
end

tr = triangulation([1 2 3], triangle(1,:)', triangle(2,:)');
inside = ~isnan(tr.pointLocation(p'));


end

