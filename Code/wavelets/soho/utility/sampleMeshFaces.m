function stris = sampleMeshFaces( stris, msh, num_samples, level )
% 
% stris = sampleMeshFaces( stris, msh, num_samples, level )
%
% Resample projection of msh onto the sphere (e.g. generated with 
% projectMeshToSphere) onto spherical triangles on level \a level of the 
% wavelet tree
%
% @return forest of wavelet trees where the nodes on level \a level contain
%         a resampled version of \a msh.stris
% @param  stris  root nodes of forest of wavelet trees
% @param  msh           mesh
% @param  num_samples   number of samples per domain on level \a level
% @param  level   level of the wavelet trees on which to resample the data

  norm_val = 0.0;
  % do for all vertices
  for( i = 1 : size( msh.V, 2))
    norm_val = max( norm_val, norm( msh.V(1:3,i)));
  end
  
  stris = sampleMeshFacesPrivate( stris, msh, num_samples, level, norm_val );
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stris = sampleMeshFacesPrivate(stris, msh,num_samples, level, norm_val)                                   
    
  stris_processed = 0;
                                       
  % do for all triangles
  for( t = 1 : numel( stris))
  
    if( getLevel(stris(t)) == level)

      verts = getVertsEC( stris(t));

      samples = [];

      % generate three random samples which become the barycentric weights
      w = rand( 3, num_samples);

      data = sampleTriangleVectorized( w, msh, verts, num_samples, norm_val);    
      stris(t) = setData( stris(t), data / num_samples);
      stris_processed = stris_processed + 1;
      
%       %if( 0 == mod( stris_processed, 100)) 
%         fprintf( 1, '.');
%       end

    elseif( getLevel(stris(t)) < level)

      childs = getChilds( stris(t));

      % recursively traverse wavelet tree
      for( i = 1 : numel( childs))
        childs(i) = sampleMeshFacesPrivate( childs(i), msh, ...
                                            num_samples, level, norm_val );
      end

      stris(t) = setChilds( stris(t), childs);

    else  
      warning( 'Invalid input level.');
    end

  end % end for all input triangles
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = sampleTriangleVectorized( w, msh, verts, num_samples, norm_val )
  
  w = w ./ repmat( sum( w, 1), 3, 1);

  % compute sample point
  wt = repmat( w, 3, 1);
  w = reshape( wt, 3, numel(wt) / 3);

  ps = w .* repmat( verts', 1, num_samples);
  ps = sum( ps', 2);
  ps = reshape( ps, 3, num_samples);
  ps = ps ./ repmat( sqrt( sum( ps .* ps, 1)), 3, 1);

  depths = zeros( num_samples, 1);
  
  % for all spherical triangles
  for( i = 1 : size( msh.stris_v1, 2))
    
    for( k = 1 : num_samples)
    
      if( 1 == checkPointInsideSTriNO2( msh.n1(:,i), msh.n2(:,i), ...
                                        msh.n3(:,i), ...
                                        msh.N(:,i), msh.s_v1(:,i), ps(:,k)))
      
        tri = [msh.V(1:3,msh.F(1,i)), ...
               msh.V(1:3,msh.F(2,i)), ...
               msh.V(1:3,msh.F(3,i))];
        n = msh.N(:,i);
        
        % get data and mark as processes
        d = getDepth( tri, n, ps(:,k), norm_val);
        depths(k) = max( depths(k), d);
        
      end % end if current k is in spherical triangle
      
    end % end for all samples
    
  end % end for all spherical triangles
    
  data = sum( depths);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function depth = getDepth( tri, n, ps, norm_val)
%
% depth = getDepth( tri, n, ps)
%
% Get normalized depth of sample \a ps on the sphere on triangle \a tri 
% with normal \a n

  % ray direction
  dir = -ps;
  % distance of triangle plane from origin
  d = dot( n, tri( :, 1));
  % ray coefficient
  lambda = (d - dot(n,ps)) / dot(n,dir);

  % projection of sample onto the triangle plane
  p = ps + lambda * dir;
  
  % depth of sample
  depth = norm( p) / norm_val;

end
