function coeffs = shProjectPartition( samples, num_bands, forest, level)
%
% coeffs = shProjectPartition( samples, num_bands, forest, level)
%
% Project the signal on level \a level of the partition \a forest into the 
% SH basis.

  coeffs = zeros( 3, num_bands^2);

  % do for all samples
  for( i = 1 : numel( samples))
    
    sample = samples{i};
    
    % get the value of the signal at (\theta, \phi)
    signal_sample = findDataForSample( forest, level, sample.vec);
    
    % replicate for vectorized processing
    signal_sample = repmat( signal_sample, 1, numel( sample.coeffs));
    
    % project all bands simultaneously
    coeffs = coeffs + (repmat(sample.coeffs, 3, 1) .* signal_sample);
    
  end

  % normalize
  factor = (4 * pi) / numel( samples);
  coeffs = coeffs * factor;
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = findDataForSample( forest, level, p)
% Find the data for point p in the partition tree \a forest on level \a
% level.

  for( i = 1 : numel( forest))
    
    % check if the point is inside the spherical triangle
    if( checkPointInsideSTri( forest(i), p))
      
      % check if we are already on the final level
      if( level == getLevel( forest(i)))
        data = getData( forest(i));
      else  % traverse tree
        data = findDataForSample( getChilds( forest(i), level, p));
      end
        
      break;
      
    end  % end found triangle    
  end  % end for all triangles in forest

end