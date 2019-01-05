function err = dswtFindErrorReprojection( forest_source, forest_reprojected, ...
                                          level_source, level_reprojected, ...
                                          num_samples )
%
% err = dswtFindErrorReprojection( forest_rotated, forest_reprojected, ...
%                                  level_rotated, level_reprojected, ...
%                                  num_samples )
%
% Compute the error introduced by reprojecting a (rotated) basis into
% another (unrotated) basis
%
% @param  forest_source  list of root nodes of forest of wavelet trees
%                        representing the source basis (rotated but not
%                        reprojected)
% @param  forest_reprojected   list of root nodes of forest of wavelet trees
%                              representing the (reprojected) target basis 
% @param  level_source  level in the source basis on which the data is
%                        defined
% @param  level_target  level in the target basis on which the data is
%                       defined
% @param  num_samples  number of samples used to compute the error for a
%                      fixed partition in the source basis
  
  err = [];
  
  for( t = 1 : numel( forest_source))
  
    temp = [];
    temp = traverseSourceTree( forest_source, forest_reprojected, ...
                              level_source, level_reprojected, num_samples, ...
                               temp );
                             
    err = [err temp];
    
  end
                                  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function err = traverseSourceTree( forest_src, forest_target, ...
                                    level_src, level_target, num_samples, ...
                                    err )
%
% err = traverseSourceTree( forest_src, forest_target, ...
%                           level_src, level_target, num_samples, ...
%                           err )
%
% Traverse the source tree and compute error for all partitions at level \a
% level_src
  
  % do for all root nodes of the rotated wavelet tree
  for( t = 1 : numel( forest_src))
    
    if( getLevel( forest_src(t)) == level_src)
      
      % find error for source partition
      c_err = findErrorPartition( forest_src(t), forest_target, ...
                                  level_target, num_samples );
      
      % store error / difference
      err( : , getIndexLevel( forest_src(t)) + 1) = c_err;
      
    else
      
      % recursively traverse the tree
      err = traverseSourceTree( getChilds( forest_src(t)), forest_target, ...
                                level_src, level_target, num_samples, err);
      
    end
    
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  err = findErrorPartition( partition_src, forest_target, ...
                                    level_target, num_samples )
%
% err = findErrorPartition( partition_src, forest_target, ...
%                           level_target, num_samples )
%
% Compute the error for a fixed source partition 

  % generate random samples in the source partition using generalized 
  % barycentric coordinates on the sphere 

  verts = getVertsEC( partition_src);
  
  % generate weights for the vertices
  w = rand( 3, num_samples);
  
  % compute all sample points (vectorized version)
  
  w = w ./ repmat( sum( w, 1), 3, 1);

  wt = repmat( w, 3, 1);
  w = reshape( wt, 3, numel(wt) / 3);

  ps = w .* repmat( verts', 1, num_samples);
  ps = sum( ps', 2);
  ps = reshape( ps, 3, num_samples);
  ps = ps ./ repmat( sqrt( sum( ps .* ps, 1)), 3, 1);

  ref = getData( partition_src);
  col = zeros( size( ref, 1), 1);
  
  % do for all sample points
  for( i = 1 : num_samples)
  
    col = col + findDataForPoint( ps(:,i), forest_target, level_target);
    
  end
  
  % compute error
  err = (col / num_samples) - ref;
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function col = findDataForPoint( p, forest, level)
%
% col = findDataForPoint( p, forest, level)
%
% Find the data associated with the partition at level \a level of \a
% forest into which the point \a p falls

  % do for all root nodes in the forest
  for( t = 1 : numel( forest))
    
    % test if point is inside the spherical triangle
    if( 1 == checkPointInsideSTri( forest(t), p))
    
      if( getLevel( forest(t)) == level)

        col = getData( forest(t));

      else

        % recursively traverse the tree
        col = findDataForPoint( p, getChilds( forest(t)), level);

      end

      % early out, the partitions are disjoint
      break;
      
    end % end p in current stri
  end
  
end
