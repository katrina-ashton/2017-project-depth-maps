function [n1 n2 n3] = getPlanes( tri)
%
% [n1 n2 n3] = getPlanes( tri)
%
% Planes associated with great arcs forming the sides of the spherical
% triangle \a tri
%
% @return  normals of the three planes
% @param  tri  spherical triangle
% @note The planes are formed by great arcs and therefore pass through the
% origin. Thus, the planes are uniquely specified by their normals.

  n1 = cross( tri.verts_ec(:,2), tri.verts_ec(:,1));  n1 = n1 / norm( n1);
  n2 = cross( tri.verts_ec(:,3), tri.verts_ec(:,2));  n2 = n2 / norm( n2); 
  n3 = cross( tri.verts_ec(:,1), tri.verts_ec(:,3));  n3 = n3 / norm( n3);

end