function checkBTMForBlockSymmetry( btm, block_size)
%
% checkBTMForBlockPattern( btm, block_size)
%
% Check the basis transformation matrix \a btm with block size \a
% block_size for a pseudo block symmetry 
%
% @param btm  btm to check
% @param block_size  size of the blocks in the btm
  
  err_counter = 0;

  num_blocks = size( btm) / block_size;

  % for all rows
  for( row = 0 : (num_blocks - 1))

    i_y = (row * block_size + 1) : (row * block_size + block_size);    

    % for all columns in the current row
    for( col = 0 : (num_blocks - 1))

      i_x = (col * block_size + 1) : (col * block_size + block_size);

      % current block
      c_block = btm( i_y, i_x);

      % skip empty blocks
      if( nnz( c_block) > 0)
         s = checkBlockForSymmetry( btm, block_size, block_size, [row+1, col+1]);
         if( 0 == numel(s))
           err_counter = err_counter + 1;
           disp( sprintf( ['No symmetric block found for' ...
                            '%i  / %i (row / column)'], row, col));
         end
      end

    end  
  end
  
  if( 0 == err_counter)
    disp( sprintf( 'Matrix is pseudo block symmetric.'));
  end

end