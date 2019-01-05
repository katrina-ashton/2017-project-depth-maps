function map = sampleSWTToTex( stris, level, size_map, num_samples)
%
% map = resampleSWT( stris, level, size, num_samples)
%
% Resample data stored in the nodes of a wavelet trees into a 2D texture
%
% @return 2D texture containing the resamples information
% @param  stris  root nodes of forest of wavelet trees
% @param  level  level on which the data for resampling is defined
% @param  size_map  size of the texture to generate
% @param  num_samples  number of samples per pixel
% @note  The implementation uses a Monte-Carlo backward sampling approach, 
%        i.e. for each pixel in the destination texture a set of random
%        samples is generated, these are mapped onto the unit sphere, and the
%        data from the wavelet tree nodes where the samples fall into are
%        used. A forward sampling approach where a set of random samples is
%        generated for each node in the wavelet tree and these are mapped
%        into 2D is faster but results in a much higher (often
%        inacceptable) amount of noise. An implementation of the latter
%        approach can be found at the end of this file in
%        sampleSWTToTexForward()
  

  % forward sampling approach, not recommended
  % map = sampleSWTToTexForward( stris, level, size)

  % create image
  map = zeros( size_map(1), size_map(2), 3);

  dx_pixel = 1.0 / size_map(2);
  dy_pixel = 1.0 / size_map(1);  
  
  % do for every pixel
  for( y = 1 : size_map(1))
    for( x = 1 : size_map(2))
     
      % random weights (for barycentric coordinates)
      ws = rand( num_samples, 2);
      
      % normalized positions
      xn = (x - 1) / size_map(2);
      yn = (y - 1) / size_map(1);
      
      % sample
      for( i = 1 : num_samples)
        
        w = ws(i,:)';
        
        % compute sample point
        uv = [xn + w(1) * dx_pixel, yn + w(2) * dy_pixel];
        % disp( sprintf( 'uv = %f / %f  ::  %f / %f', uv, xn, yn));

        % map point to unit sphere
        pos = mapPointFromTexToSphere( uv);
        
        % find the spherical triangle on level \a level where pos falls
        % into
        data = findNode( stris, pos, level);
        
        for( k = 1 : size( data))
          map(y,x,k) = map(y,x,k) + data(k);
        end
        
      end
      
      % normalize integration
      map(y,x,:) = map(y,x,:) / num_samples;
      
    end
    
    disp( sprintf( 'Finished row %i.', y));
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = findNode( stris, p, level)
  
  node = -1;
  for( t = 1 : numel( stris))
    
    if( 1 == checkPointInsideSTri( stris(t), p))
      node = t;
      break;
    end
    
  end
  
  % assert
  condition( node > -1);
  
  % process node
  if( getLevel( stris(node)) == level)
    
    data = getData( stris(node));
    
  else
    
    % recursively traverse nodes
    data = findNode( getChilds( stris(node)), p, level);
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function map_colors = sampleSWTToTexForward( stris, level, size)
%
% map_colors = sampleSWTForward( stris, level, size)
%
% Sample a wavelet tree to a 2D texture map
%
% @return  texture containing the resampled data
% @param  stris  root nodes of wavelet trees
% @param  level  level on which the data is defined 
% @param  size   size of the 2D texture map to generate
% @note  Forward approach not recommended, see discussion in
% sampleSWTToTex()

  % number of samples per spherical domain at the requested level
  num_samples = 10;

  % generate image
  map_colors = zeros( size(1), size(2), 3);
  % necessary to keep track of the samples;
  map_samples = zeros( size(1), size(2));
  
  % traverse wavelet tree
  [map_colors , map_samples] = sampleSWTPrivate( stris, level, ...
                                                 map_colors, map_samples, ...
                                                 num_samples);

  % avoid divides by zero
  map_samples( find( 0 == map_samples)) = 1;
                                                 
  % normalize integration
  map_colors(:,:,1) = map_colors(:,:,1) ./ map_samples;
  map_colors(:,:,2) = map_colors(:,:,2) ./ map_samples;
  map_colors(:,:,3) = map_colors(:,:,3) ./ map_samples;
  
  % rescale to color values in [0,1] if necessary
  if( max(map_colors(:)) > 1.0)
    map_colors = map_colors ./ 255;
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [map_colors , map_samples] = ...
  sampleSWTToTexForwardPrivate( stris, level, ...
                                map_colors, map_samples, num_samples)

  size_map = size( map_colors);
  size_map = size_map(2:-1:1)' - [1;1];

  % do for all input triangles
  for( t = 1 : numel( stris))
    
    if( getLevel( stris(t)) == level)
      
      verts = getVertsEC( stris(t));
      
      % random weights (for barycentric coordinates)
      ws = rand( num_samples, 3);
      
      for( i = 1 : num_samples)
        
        w = ws(i,:)';
        
        % compute sample point
        p = w(1) * verts(:,1) + w(2) * verts(:,2) + w(3) * verts(:,3);
        p = p / norm(p);
        condition( 1 == checkPointInsideSTri( stris(t), p));

        % compute lookup position in the texture
        uv = mapPointFromSphereToTex( p);
        uv = round( (uv .* size_map) + [1;1]);  
        
        data = getData( stris(t));
        map_colors(uv(1), uv(2), 1 ) = map_colors(uv(1), uv(2), 1 ) + data(1);
        map_colors(uv(1), uv(2), 2 ) = map_colors(uv(1), uv(2), 2 ) + data(2);
        map_colors(uv(1), uv(2), 3 ) = map_colors(uv(1), uv(2), 3 ) + data(3);        
        map_samples(uv(1), uv(2)) = map_samples(uv(1), uv(2)) + 1;
        
      end
      
    else
      
      childs = getChilds( stris(t));
      
      % recursively traverse the wavelet tree
      for( i = 1 : numel( childs))
        [ map_colors , map_samples] = sampleSWTPrivate( childs(i), level, ...
                                        map_colors, map_samples, num_samples);
      end
      
    end
    
  end  % end for all input triangles

end
