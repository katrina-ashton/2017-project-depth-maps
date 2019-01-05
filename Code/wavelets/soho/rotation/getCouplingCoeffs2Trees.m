function btm = getCouplingCoeffs2Trees( tri_src, tri_target,  ...
                                        level_src, level_target, fhs_basis, ...
                                        btm )
%
%  btm = getCouplingCoeffs2Trees( tri_src, tri_target,  ...
%                                 level_src, level_target, btm )
%
% Compute coupling coefficients for a pair of wavelet trees, i.e. one
% source and one target tree
%
% @return  btm  basis transformation matrix mapping from the source to the
%               target basis
% @param tri_src  wavelet tree representing the source basis 
% @param  tri_target  wavelet tree representing the target basis
% @param  level_src  level on which the data is defined on the source tree
% @param  level_target  level on which the data is defined on the target
%                       tree
% @param  fhs_basis  struct containing the function handles of the wavelet 
%                    basis for which the basis transformation matrix is
%                    generated
% @param  btm  basis transformation matrix mapping from the source to the
%             target basis

  % coupling coefficient with scaling function of the source basis on the 
  % top-most level, first column of block in matrix
  if( getLevel( tri_src) == 0)
    
    btm(:,1) = getCouplingCoeffsScalingSrcPartition( tri_src, tri_target, ...
                                                     level_target, ...
                                                     fhs_basis, btm(:,1) );
    
    if( sum( btm(:,1)) == 0)
      return;
    end
    
  end

  % end of recursion
  if( getLevel( tri_src) < level_src)

    % filter coefficients associated with the partition
    filters_src = fhs_basis.filters_synthesis( tri_src);

    % three wavelets defined over the source partition
    coeffs_partition = zeros( size(btm, 1), 3);

    % get coupling coefficients for fixed source domain
    coeffs_partition = ...
      getCouplingCoeffsWaveletsSrcPartition( tri_src, tri_target,  ...
                                             filters_src, level_target, ...
                                             fhs_basis, coeffs_partition );

    indices = linearIndex( tri_src);

    % offset for tree
    btm(:,indices(1)) = coeffs_partition(:,1);
    btm(:,indices(2)) = coeffs_partition(:,2);
    btm(:,indices(3)) = coeffs_partition(:,3);                            

    % recursively traverse the source tree
    childs = getChilds( tri_src);
    for( i = 1 : numel( childs))
      btm = getCouplingCoeffs2Trees( childs(i), tri_target, ...
                                     level_src, level_target, ...
                                     fhs_basis, btm );
    end   

  end % max level reached
 
end