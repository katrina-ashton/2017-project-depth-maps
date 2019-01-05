function [data, samples] = sampleTriangleSerial( ws, map, verts)
%
% [data, samples] = sampleTriangleSerial( ws, map, verts)
%
% Sample map to spherical triangle defined by \a verts with the \a ws weights as 
% barycentric coordinates 

  data = zeros( size( map, 3),1 );
  samples = [];

  size_map = size( map);
  size_map = size_map(2:-1:1)' - [1;1];
  
  for( i = 1 : size( ws, 2))
    
    w = ws( : , i);
    
    % compute sample point
    p = w(1) * verts(:,1) + w(2) * verts(:,2) + w(3) * verts(:,3);
    p = p / norm(p);

    % compute lookup position in the texture
    uv = mapPointFromSphereToTex( p);
    uv = round( (uv .* size_map) + [1;1]);  
    
    samples( : , end+1) = uv;
    
    % lookup 
    data = data + double( squeeze( map( uv(2), uv(1), :)));

  end
  
end