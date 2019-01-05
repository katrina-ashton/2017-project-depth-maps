function eta = biohNormalizationScalingFunction( tri)
%
% eta = biohNormalizationScalingFunction( tri)
%
% Normalization constant for the scaling basis function associated with
% partition \a tri for the Bio-Haar wavelet basis.
%
% @param  tri  partition over which the scaling basis function is defined

  % no normalization of primary scaling functions
  eta = 1.0 / getArea( tri);

end
