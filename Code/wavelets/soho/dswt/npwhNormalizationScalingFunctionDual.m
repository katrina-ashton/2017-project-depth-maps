function eta = npwhNormalizationScalingFunctionDual( tri)
%
% eta = npwhNormalizationScalingFunctionPrimary( tri)
%
% Normalization constant for the scaling basis function associated with
% partition \a tri for the normalized pseudo Haar wavelet basis.
%
% @param  tri  partition over which the scaling basis function is defined

  eta = 1.0 / sqrt( getArea( tri));

end