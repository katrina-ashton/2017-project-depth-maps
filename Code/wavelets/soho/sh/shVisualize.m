function forest = shVisualize( platonic_solid, coeffs, level)
%
% function shVisualize( platonic_solid, coeffs, level)
% 
% Visualize a SH projected signal using a triangular partition of the
% sphere with \a level subdivisions.
%
% @param platonic_solid  type of platonic solid to use for visualization 
%                        (param as strings)

  % number of SH bands
  num_bands = sqrt( size( coeffs, 2));
  assert( (int8( num_bands) == num_bands), ... 
         'Impossible number of basis function coefficients.');
  
  % construct partition
  forest = getPartition( platonic_solid, level);

  % recursively traverse the partition tree and sample the SH projected signal 
  % for the triangles at the finest level
  forest = setColorSTriangles( forest, level, coeffs, num_bands);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function forest = getPartition( platonic_solid, level)
%
% function forest = getPartition( platonic_solid, level)
%
% Construct partition of sphere

  % construct forest of partition trees (we use a regular subdivision (if
  % the last argument is 1 then the partition for the SOHO wavelet basis is
  % constructed)
  forest = getForestPlatonicSolid( platonic_solid, level, 0);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  forest = setColorSTriangles( forest, level, coeffs, num_bands)
%
% function  forest = setColorSTriangles( forest, level, coeffs, num_bands)
%
% Recursively traverse the partition tree and sample the SH projected signal 
% for the triangles at the finest level

  % for all triangles in the (sub)-forest
  for( i = 1 : numel( forest))
    
    childs = getChilds( forest(i));
    
    % check if leave level has been reached
    if( level == getLevel( childs(1)))

      % sample color for the leave triangles
      for( j = 1 : numel( childs))
        childs(j) = sampleSH( childs(j), coeffs, num_bands);
      end
      
    else  % recursively traverse the tree    

      childs = setColorSTriangles( childs, level, coeffs, num_bands);    

    end  % end not yet at the leave level
    
    % update the triangle in the tree
    forest(i) = setChilds( forest(i), childs);
    
  end % end for all elements in the forest

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function st = sampleSH( st, coeffs, num_bands)
%
% function st = sampleSTriangle( st, coeffs, num_bands)
%
% Sample Spherical Harmonics signal at the centroid of the spherical triangle st

  % get the centroid of the spherical triangle in spherical polar
  % coordinates
  c = r3_to_s2( getCentroidSTri( st));
  
  % evaluate the signal at the centroid
  sample = zeros( size( coeffs, 1), 1);
  for( l = 0 : (num_bands - 1))
    for( m = -l : l)
      index = l * (l+1) + m + 1;
      sample = sample + coeffs(:,index) * shEval( l, m, c(1), c(2));
    end
  end
  
  st = setData( st, sample);

end