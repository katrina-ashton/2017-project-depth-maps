function A = sampleOverlapS2( tri1, tri2, forest, level)
%
% A = computeTotalOverlap( tri1, tri2)
%
% Densely sample the overlap between \a tri1 and \a tri2 for all possible
% rotations of tri2

  % check input data
  assert( 1 == numel( tri1));
  assert( 1 == numel( tri2))
  
  % get sample positions
  sample_pos = getSamplePositions( forest, level);
  
  % centroids of the two spherical triangles (euclidean coordinates)
  c_tri2 = getCentroidSTri( tri2);

  % local rotation of spherical triangle
  samples_omicron = 72;  
  % compute step size
  delta_omicron = 360 / samples_omicron;

  % initialize result data structure
  A = zeros( size( sample_pos, 2), samples_omicron);
  
  % do for all sample positions
  for( i = 1 : size( sample_pos, 2))

      pos = sample_pos(:,i);
    
      % axis computation breaks down if c_tri2 and pos are identical
      % make sure to avoid this problem
      if( sum( abs( c_tri2 - pos)) > 10e-8)

        [axis, angle] = getRotation( c_tri2, pos);
        R = getRotationMatrix( axis, angle, 1);

      else

        R = eye( 3);
        disp( 'Using R = eye(3).');
      
      end

      % compute rotated triangle
      tri_temp = rotate( tri2, R);
            
      c_tri_temp = R * c_tri2;

      % for all local rotations
      for( i_omicron = 1 : samples_omicron)
        
        omicron = (i_omicron - 1) * delta_omicron;
            
        % rotate triangle around local axis
        % the rotation axis is given by the centroid
        R = getRotationMatrix( c_tri_temp, omicron);
        
        % get final rotated triangle
        tri = rotate( tri_temp, R);

        % compute overlap and store sample
        temp = findAreaOverlapSTris( tri1, tri);
        A( i, i_omicron) = temp;
        
      end % end omicron
  end 
      
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [axis, angle] = getRotation( pos1, pos2)
% Get the rotation matrix to rotate pos1 to pos2
  
  % compute axis
  axis = cross( pos1, pos2);
  axis = axis / norm( axis);
  
  % compute angle
  angle = acos( dot( pos1, pos2));
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pos = getSamplePositions( forest, level)

  % get spherical triangles on the requested level
  tris = getTrianglesAtLevel( forest, level);
  
  % extract positions
  pos = [];
  for( i = 1 : numel( tris))
    pos = [pos getCentroidSTri( tris(i))];
  end
  
end
