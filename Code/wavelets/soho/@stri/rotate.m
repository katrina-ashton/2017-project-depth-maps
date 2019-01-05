function tri = rotate( tri, R)
%
% tri = rotate( tri, R)
%
% Rotate the spherical triangle
%
% @return  rotated triangle
% @param  tri  triangle to rotate
% @param  R  [3x3] rotation matrix to apply

  % apply rotation
  for( i = 1 : size( tri.verts_ec, 2))
    tri.verts_ec(:,i) = R * tri.verts_ec(:,i);
  end

end