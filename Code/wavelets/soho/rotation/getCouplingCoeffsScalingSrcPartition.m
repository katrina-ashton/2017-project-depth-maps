function coeffs = getCouplingCoeffsScalingSrcPartition( tri_src, tri_target, ...
                                                        level, fhs_basis, ...
                                                        coeffs )
% 
% coeffs = getCouplingCoeffsWaveletsSrcPartition( tri_src, tri_target,...
%                                                 filters_src, fhs_basis, ...
%                                                 level, coeffs)
% 
% Compute coupling coefficient for the scaling basis function associated 
% with a fixed source partition 
%
% @return  coeffs   [n x 1] coupling coefficients
% @param  tri_src  spherical triangle corresponding to the partition which
%                  is the domain of the scaling basis function
% @param  tri_target  root node of wavelet tree those node correspond to
%                     the target basis
% @param  filters_src  matrix with filter tabs g_{j,k,l} which define the 
%                      wavelet basis functions defined over \a tri_src in
%                      terms of the scaling basis functions at level j+1
% @param  level  level in the target tree on which the data will be defined
% @param  fhs_basis      struct containing the function handles corresponding
%                         to the basis for which the basis transformation 
%                         matrix is computed
% @param  coeffs   coupling coefficients


  % scaling-scaling coupling coefficient if root node for target tree
  if( getLevel( tri_target) == 0)
    coeffs(1) = getCoeffScalingScaling( tri_src, tri_target, fhs_basis );
    
    % skip tree if there is no overlap
    if( 0 == coeffs(1))
      return;
    end
    
  end
  
  % coupling coefficient for wavelet basis functions associated with 
  % \a tri_target
  [w_ccoeffs , overlaps] = getCoeffsScalingWavelet( tri_src, tri_target, ...
                                   fhs_basis.normalization_scaling_primary, ...
                                   fhs_basis.normalization_scaling_dual, ...
                                   fhs_basis.filters_analysis( tri_target)' );
  
  % get the indices for storing the coupling coefficients of the wavelet
  % basis functions
  indices = linearIndex( tri_target);

  % store coupling coefficients 
  coeffs( indices) = w_ccoeffs;

  % recursively traverse tree
  
  % stop at max level
  if(( level - 1) ~= getLevel( tri_target))

    childs_target = getChilds( tri_target);
    
    % skip childs which do not overlap src triangle
    for( i = 1 : numel( childs_target))
      
       % skip sub-tree if there was no overlap for the current triangle 
      if( overlaps(i) > 0)
        coeffs = ...
          getCouplingCoeffsScalingSrcPartition( tri_src, childs_target(i), ...
                                                level, fhs_basis, coeffs );    
      end
    end  % end for all childs

  end
  
end
