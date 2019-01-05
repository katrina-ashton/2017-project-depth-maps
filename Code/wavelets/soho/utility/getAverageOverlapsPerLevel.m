function  avg_per_level = getAverageOverlapsPerLevel( btm, block_size, level)
%
% avg_per_level = getAverageOverlapsPerLevel( btm, block_size, level)
%
% Get the average number of overlapping source partitions for each target
% partition, discriminated by level
% 
% @return  average number of overlapping source partition for each level
% @param  btm  basis transformation matrix top analyse
% @param  block_size  size of the blocks in the basis transformation matrix
% @param  level  level for which the btm is valid
  
  avg_per_level = zeros( 1, level);

  % number of blocks in the matrix
  num_blocks = size( btm, 1) / block_size;
  
  for( l = 1 : level)
  
    % range of coefficients in block
    i_y = [4^(l-1) : 4^l];
    
    for( i = 1 : num_blocks)
  
      indices = i_y + (i - 1) * num_blocks;
      
      temp = sum( logical(btm( indices, : )), 2);
      avg_per_level(l) = avg_per_level(l) + mean( temp);
    
    end  % end for all blocks
  
  end % end for all levels
   
  avg_per_level = avg_per_level / num_blocks;
  
end