function   pos = mapPointFromTexToSphere( uv)
%
% uv = mapPointFromSphereToTex( pos)
%
% Map point from position in normalized 2D texture coordinates to point on 
% the unit sphere
% @return  position on the unit sphere 
% @param  uv  normalized 2D position in texture

  pos = [];
  if( 2 == numel(uv))
    pos = mapPointFromTexToSphereSerial( uv);
  else
    error( 'Not yet implemented.');
    % pos = mapPointFromSphereToTexVectorized( pos);
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pos = mapPointFromTexToSphereSerial( uv)

  % rescale uv to to range of polar coordinates
  theta = uv(2) * pi;
  phi = uv(1) * (2 * pi);
  
  pos = s2_to_r3( [theta, phi]);
  
end
