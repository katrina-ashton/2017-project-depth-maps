function   uv = mapPointFromSphereToTex( pos)
%
% uv = mapPointFromSphereToTex( pos)
%
% Map point from position on the sphere to normalized 2D texture
% coordinates
% @return  normalized 2D texture coordinates corresponding to \a pos
% @param  pos  3D point on the unit sphere which has to be mapped to 2D
%              texture

  uv = [];
  if( 3 == numel(pos))
    uv = mapPointFromSphereToTexSerial( pos);
  else
    uv = mapPointFromSphereToTexVectorized( pos);
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function uv = mapPointFromSphereToTexSerial( pos)
% Map a 3D point on the unit sphere from Eucledian coordinates into (normalized)
% 2D texture coordinates
% @param  pos  3D position on the unit sphere in Euclidean coordinates

  v = acos( pos(3)) / pi; 
  u = 0;
  if( v ~= 0) 

    if( pos(2) >= 0)
      u = (acos( pos(1) / sin( v * pi ))) / (2 * pi);
    else
      u = (pi + acos( -pos(1) / sin( v * pi ))) / (2 * pi);
    end
    
  end
    
  uv = [ u , v ]';
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function uv = mapPointFromSphereToTexVectorized( pos)
% Map a 3D point on the unit sphere from Eucledian coordinates into (normalized)
% 2D texture coordinates
% @param  pos  3D position on the unit sphere in Euclidean coordinates

  v = acos( pos(3,:)) / pi; 

  [i_positive] = find( pos(2,:) >= 0);
  [i_negative] = find( pos(2,:) < 0);
  [i_null] = find( v == 0);
  [i_inv_null] = find( v ~= 0);
  
  u = zeros( 1, size(pos, 2));
  u(i_positive) = pos(1,i_positive);
  u(i_negative) = -1.0 * pos(1,i_negative);
  u(i_inv_null) = acos( u(i_inv_null) ./ sin( v(i_inv_null) * pi));
  u(i_negative) = pi + u(i_negative);
  u(i_inv_null) = u(i_inv_null) / (2 * pi);
  
  u( i_null) = 0;

  uv = [ u ; v];

end