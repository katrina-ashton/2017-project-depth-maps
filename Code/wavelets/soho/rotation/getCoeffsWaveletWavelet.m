function [coeffs , overlaps] = getCoeffsWaveletWavelet( tri_src, tri_target,...
                                                        filters_src, ...
                                                        fhs_basis )
%
% [coeffs , overlaps] = getCoeffsWaveletWavelet( tri_src, tri_target, ...
%                                                filters_src, fhs_basis )
%
% Get the nine coupling coefficients between the wavelet basis functions defined
% over tri_src and tri_target
%
% @return  coeffs  [3x3]  coupling coefficients, the i-th row corresponds to the
%                         coupling coefficietns of the i-th wavelet basis 
%                         function defined over tri_src
% @param  overlaps [4x4]  overlap between the child domains of the two
%                         spherical triangles
% @param  tri_src     partion over which the wavelets are defined
% @param  tri_target  partion over which the wavelets are defined
% @param  filters_src  filter tabs associated with \a tri_src which form
%                      the wavelets defined over \a tri_src as linear
%                      combination of the scaling functions at the next
%                      finer level
% @param   fhs_basis      struct containing the function handles corresponding
%                         to the basis for which the basis transformation 
%                         matrix is computed

  coeffs = zeros(3,3);

  % get childs for source and target (the basis functions are defined
  % over the child domains
  childs_src = getChilds( tri_src);
  childs_target = getChilds( tri_target);

  overlaps = zeros( 4, 4);
  
  % do for all child triangles
  for( i = 1 : numel( childs_src))
    
    % temp_sqrt_area = sqrt( getArea( childs_src(i)));
    eta_src = fhs_basis.normalization_scaling_primary( childs_src(i));
    
    for( k = 1 : numel( childs_target))
      
      overlaps(i,k) = findAreaOverlapSTris( childs_src(i), childs_target(k));      
      overlaps(i,k) = overlaps(i,k) ...
          * (eta_src * fhs_basis.normalization_scaling_dual(childs_target(k)));
    end
    
  end
  
  % if there is any overlap
  if( sum( overlaps(:)) > 0)

    % filter tabs g_{j,k,l} which define the 
    % \psi_{j,m} = \sum_l g_{j,k,l} \varphi_{j+1,l}
    filters_target = fhs_basis.filters_analysis( tri_target)';    

    % three wavelets defined over the source partition
    for( i = 1 : 3)

      gs = filters_src(:,i+1);

      % three wavelets defined over the target partition
      for( k = 1 : 3)

        gt = filters_target(:,k+1);

        % product of g_{j,k,l} terms
        % the i-th row contains the g_{j,k,i} of the source basis multiplied
        % with all g_{j,k,l} of the target basis
        gf = gs * gt';

        temp = gf .* overlaps;
        coeffs(i,k) = sum(temp(:));
        
      end
    end

 end
  
end
