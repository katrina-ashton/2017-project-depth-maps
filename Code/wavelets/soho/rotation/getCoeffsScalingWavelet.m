function [coeffs , overlaps] = getCoeffsScalingWavelet( tri_scaling, ...
                                                        tri_wavelets, ...
                              fhs_tri_scaling_normalization_scaling, ...
                              fhs_tri_wavelet_normalization_scaling, ...
                                                        fhs_filters )
%
% coeffs = getCoeffsScalingWavelet( tri_scaling, tri_wavelets, ...
%                                   fhs_tri_scaling_normalization_scaling, ...
%                                   fhs_tri_wavelet_normalization_scaling, ...
%                                   fhs_basis )
%
% Compute coupling coefficients between the scaling basis function defined over 
% a\ tri_scaling and the wavelet basis functions defined over \a
% tri_wavelets
%
% @return  coeffs   [3,1]  coupling coefficients
% @return  overlaps [4,1]  overlap between the partion of \a tri_scaling
%                          and the four child domains of \a tri_wavelets
% @param   tri_scaling    partion over which the scaling basis function is 
%                         defined
% @param   tri_wavelets   partion over which the wavelet basis functions are
%                         defined
% @param   fhs_tri_scaling_normalization_scaling  function handle to the
%                         function providing the normalization constant of
%                         the scaling basis functions (either primary or
%                         dual) for the tri whose associated scaling basis
%                         function is under consideration
% @param   fhs_tri_wavelet_normalization_scaling  function handle to the
%                         function providing the normalization constant of
%                         the scaling basis functions (either primary or
%                         dual) for the tri whose associated wavelet basis
%                         functions are under consideration
% @param   fhs_filters

  % area overlaps 
  overlaps = zeros(4,1);

  childs_tri_w = getChilds( tri_wavelets);
  
  % do for all child domains
  for( i = 1 : numel( childs_tri_w))    
    overlaps(i) = findAreaOverlapSTris( tri_scaling, childs_tri_w(i));    
    overlaps(i) = ...
      overlaps(i) * fhs_tri_wavelet_normalization_scaling( childs_tri_w(i));
  end

  temp = fhs_filters( : , 2:4) .* repmat( overlaps, 1, 3);
  coeffs = sum( temp, 1);

  % normalization constant of scaling basis function
  coeffs = coeffs * fhs_tri_scaling_normalization_scaling( tri_scaling);
  
end
