function [data, samples] = sampleTriangleVectorized( w, map, verts, num_samples)
%
% [data, samples] = sampleTriangleVectorized( w, map, verts, num_samples)
%
% Sample map to spherical triangle defined by \a verts with the \a w weights as 
% barycentric coordinates 
  
  w = w ./ repmat( sum( w, 1), 3, 1);

  % compute sample point
  wt = repmat( w, 3, 1);
  w = reshape( wt, 3, numel(wt) / 3);

  ps = w .* repmat( verts', 1, num_samples);
  ps = sum( ps', 2);
  ps = reshape( ps, 3, num_samples);
  ps = ps ./ repmat( sqrt( sum( ps .* ps, 1)), 3, 1);

  % compute lookup position in the texture
  uv = mapPointFromSphereToTex( ps);
  size_map = size( map);
  size_map = size_map(2:-1:1)' - [1;1];
  uv = round( (uv .* repmat( size_map, 1, num_samples)) ...
                                                  + ones(2,num_samples));  
  samples = uv;

  % lookup 
  % convert to linear index set
  l_index = uv(2,:) + ((uv(1,:) - 1)* size( map, 1));
  l_map = map(:);
  
  num_channels = size(map, 3);
  size_per_channel = size( l_map,1) / 3;
  
  for( i = 1 : num_channels)
    data(i) = double( sum( l_map( (i-1) * size_per_channel + l_index)));
  end
    
  data = data';
end