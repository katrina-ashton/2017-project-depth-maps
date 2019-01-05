function is_sym = checkBlockForSymmetry( btm, kernel_size, block_size, ref_pos)
%
% checkBlockForSymmetry( btm, kernel_size, block_size, ref_pos)
%
% Check if the block at \a ref_pos in the BTM \a btm has a symmetric block
%
% @return is_sym  empty vector if no symmetric block exists, otherwise the
%                 block coordinates of the symmetric block
% @param  btm    basis transformation matrix containing the block at \a
%                ref_pos
% @param  kernel_size  size of the kernel to use to find the symmetric
%                      block
% @param block_size  size of the blocks in the matrix
% @param ref_pos  block position of the block whose symmetric counter-part
%                is seeked


  is_sym = [];

  window_size = block_size - 1;

   % pre-process optional input arguments
   rp = [1 1];
   if( nargin > 3)
     rp = ref_pos;
   end
   ref_pos = rp;


   % get the reference block

   min_y = (ref_pos(1)-1) * block_size + 1;  
   min_x = (ref_pos(2)-1) * block_size + 1;   

   ref_kernel = btm( min_y : min_y + (kernel_size-1) , ...
                     min_x : min_x + (kernel_size-1) );

   ref_block = btm( min_y : min_y + window_size , min_x : min_x + window_size );

   % skip empty blocks
   if( 0 == nnz( ref_block))
     return;
   end

   num_blocks = size(btm,1) / block_size;

   % do for all blocks in y direction
   for( y = 1 : num_blocks)

      min_y = (y-1) * block_size + 1; 

      % do for all blocks in x direction
      for( x = 1 : num_blocks)

        % skip self
        if(( y == ref_pos(1)) && ( x == ref_pos(2)))
          continue;
        end

        min_x = (x-1) * block_size + 1; 

        % get current block
        cb_kernel = btm( min_y : min_y + (kernel_size-1) , ...
                         min_x : min_x + (kernel_size-1) );

        % difference block
        diff = cb_kernel - ref_kernel;

        % threshold with given difference
        epsilon = 10^-7;
        diff( find( abs(diff) < epsilon)) = 0;

        % check if blocks are identical
        if( 0 == nnz( diff))

          is_sym = [y , x];

        end

      end
    end
    
end