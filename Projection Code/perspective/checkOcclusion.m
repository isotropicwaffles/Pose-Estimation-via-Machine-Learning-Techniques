function [ occ] = checkOcclusion( V, T )
%CHECKOCCLUSION Determines which points are occluded
%   Detailed explanation goes here

%Ok, generate the triangles
triangles = cell(1, size(T, 2));
for ii=1:length(triangles)
   z = [V(1:3, T(1, ii)) V(1:3, T(2, ii)) V(1:3, T(3, ii))];
   triangles{ii} = z;
end

occ = false(size(V, 2), 1);
for ii=1:length(occ)
   for jj=1:length(triangles)
      if occludedByTriangle(triangles{jj},  V(:, ii))
          occ(ii) = true;
          break;
      end
   end
end

end

