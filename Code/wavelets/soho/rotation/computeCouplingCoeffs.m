function btm = computeCouplingCoeffs( stris_src, stris_target, ...
                                      level_src, level_target, ...
                                      basis_str )
%
% btm = computeCouplingCoeffs( stris_src, stris_target, level_src, level_target)
%
% Compute coupling coefficients mapping a vector of basis coefficients
% defined over the wavelet tree \a stris_src to the wavelet tree \a stris_target
%
% @param  stris_src  list of root nodes of a forest of wavelet trees
%                    representing the source basis
% @param  stris_target  list of root nodes of a forest of wavelet trees
%                       representing the target basis
% @param  level_src     level on which the data is defined on the source tree
% @param  level_target  level on which the data is defined on the target tree
% @param  basis_str     {'bioh', 'pwh', 'osh'} string identifying the basis
%                        to use
% @note The forest of wavelet trees in \a stris_src and \a stris_target
% have to generated for the basis in \a basis_str (in particular if an area
% constraint has been used during generation or not)

  % get the function handles for the basis to use 
  fhs_basis = getFunctionHandlesBasis( basis_str);

  % number of coefficients per wavelet tree
  num_coeffs_src_tree = 4^level_src;
  num_coeffs_target_tree = 4^level_target;
  
  btm_blocks = {};

  % process always one pair of trees at the time
  for( k = 1 : numel( stris_target))
    for( i = 1 : numel( stris_src))
      
      % storage for coupling coefficients of these two wavelet trees
      coeffs_tree = sparse( 4^level_target, num_coeffs_src_tree, 0);
      % coeffs_tree = zeros( 4^level_target, num_coeffs_src_tree);

      % get sub-matrix for the current source tree
      coeffs_tree = getCouplingCoeffs2Trees( stris_src(i), stris_target(k), ...
                                             level_src, level_target, ...
                                             fhs_basis, coeffs_tree );

      btm_blocks{ k, i } = coeffs_tree;
      
    end
    
  end

  btm = [];
  
  % assemble matrix
  for( k = 1 : numel( stris_target))
    
    % form one row of 
    row_blocks = [];    
    for( i = 1 : numel( stris_src))
      row_blocks = [row_blocks  btm_blocks{k,i}];
    end
    
    btm = [btm ; row_blocks];
    
  end
  
end
