function [ occ ] = checkSphereOcclusion( V, z )
%CHECKSPHEREOCCLUSION A simplification for the sphere
%   Detailed explanation goes here

occ = V(3, :) > z;

%Check for clipping
V = V ./ V(4,:);
occ = occ | any(abs(V(1:3, :)) > 1.0);


end

