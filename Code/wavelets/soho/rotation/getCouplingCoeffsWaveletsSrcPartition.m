function coeffs = getCouplingCoeffsWaveletsSrcPartition( tri_src, tri_target,...
                                                         filters_src, ...
                                                         level, fhs_basis, ...
                                                         coeffs)
% 
% coeffs = getCouplingCoeffsWaveletsSrcPartition( tri_src, tri_target,...
%                                                 filters_src, ...
%                                                 level, fhs_basis, coeffs)
% 
% Compute coupling coefficient for the three wavelet basis functions associated 
% with a fixed source partition 
%
% @param  coeffs   [n x 3] coupling coefficients
% @param  tri_src  spherical triangle corresponding to the partition which
%                  is the domain of the three wavelet basis functions
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

  % scaling function coefficient for target basis if on top-most level
  if( getLevel( tri_target) == 0)
    [coeffs(1,:) , overlaps] = getCoeffsScalingWavelet( tri_target, tri_src,...
                                   fhs_basis.normalization_scaling_dual, ...
                                   fhs_basis.normalization_scaling_primary, ...
                                   fhs_basis.filters_synthesis( tri_src) );
    
    % no overlap with root node of wavelet tree, skip whole subtree
    if( sum(overlaps) == 0)
      return;
    end
    
  end

  % get coupling coefficients for wavelet basis functions
  [w_ccoeffs overlaps] = getCoeffsWaveletWavelet( tri_src, tri_target, ...
                                                  filters_src, fhs_basis );

  % get the indices for storing the coupling coefficients of the wavelet
  % basis functions
  indices = linearIndex( tri_target);

  % store coupling coefficients 
  for( i = 1 : 3)
    coeffs( indices, i) = w_ccoeffs(i,:);
  end

  % collapse the rows, k-th element of the resulting vector states if 
  % there is any overlap of the k-th child of the target triangle with
  % the source triangles
  overlaps = sum( overlaps, 1);

  % stop at max level
  if(( level - 1) ~= getLevel( tri_target))

    childs_target = getChilds( tri_target);
    
    % skip childs which do not overlap src triangle
    for( i = 1 : numel( childs_target))
      
       % skip sub-tree if there was no overlap for the current triangle 
      if( overlaps(i) > 0)
        coeffs = ...
          getCouplingCoeffsWaveletsSrcPartition( tri_src, childs_target(i),  ...
                                                 filters_src, level, ...
                                                 fhs_basis, coeffs);    
      end
    end  % end for all childs

  end  % end if not final level
      
end
