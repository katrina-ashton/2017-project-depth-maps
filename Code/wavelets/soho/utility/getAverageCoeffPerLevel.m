function  avg_per_level = getAverageCoeffPerLevel( coeffs, num_trees, level)
%
% avg_per_level = getAverageOverlapsPerLevel( btm, block_size, level)
%
% Get the average number of overlapping source partitions for each target
% partition, discriminated by level
% 
% @return  average number of overlapping source partition for each level
% @param  btm  basis transformation matrix top analyse
% @param  num_trees  number of partition trees over which the basis is
%                    defined
% @param  level  level for which the btm is valid
  
  avg_per_level = zeros( 1, level);

  % number of blocks in the matrix
  block_size = numel(coeffs) / num_trees ;
  
  for( l = 1 : level)
  
    % range of coefficients in block
    i_y = [4^(l-1) : 4^l];
    
    for( i = 1 : num_trees)
  
      indices = i_y + (i - 1) * num_trees;
      
      avg_per_level(l) = avg_per_level(l) + mean( abs(coeffs(indices)));
    
    end  % end for all blocks
  
  end % end for all levels
   
  avg_per_level = avg_per_level / num_trees;
  
end