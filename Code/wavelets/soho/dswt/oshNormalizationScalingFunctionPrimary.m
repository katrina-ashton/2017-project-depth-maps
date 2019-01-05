function eta = oshNormalizationScalingFunctionPrimary( tri)
%
% eta = oshNormalizationScalingFunctionPrimary( tri)
%
% Normalization constant for the scaling basis function associated with
% partition \a tri for the SOHO wavelet basis.
%
% @param  tri  partition over which the scaling basis function is defined

  eta = 1.0 / sqrt( getArea( tri));

end