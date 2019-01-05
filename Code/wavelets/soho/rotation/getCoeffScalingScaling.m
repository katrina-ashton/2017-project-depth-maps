function coeff = getCoeffScalingScaling( tri_src, tri_target, fhs )
%
% coeff = getCoeffScalingScaling( tri_src, tri_target, fhs )
%
% Compute coupling coefficients between the two scaling functions
% associated with \a tri_src and \tri_target, respectively
%
% @return  coupling coefficient
% @param  tri_src  spherical triangle which is associated with first
%                  scaling function
% @param  tri_target  spherical triangle which is associated with second
%                     scaling function
% @param  fhs  function handles for basis

  % normalization constants of scaling basis functions
  eta_src = fhs.normalization_scaling_primary( tri_src);
  eta_target = fhs.normalization_scaling_dual( tri_target);  
  
  overlap = findAreaOverlapSTris( tri_src, tri_target);   
  
  coeff = eta_src * eta_target * overlap;
  
end  