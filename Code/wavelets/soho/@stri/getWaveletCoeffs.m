function wc = getWaveletCoeffs( tri)
%
% wc = getWaveletCoeff( tri)
%
% Get the wavelet coefficients associated with the wavelet basis functions
% defined over \a tri (for all data channels).
%
% @return  wc     wavelet coefficient
% @param  tri    spherical triangle over those direct childs the wavelet
%                basis function is defined

  wc = tri.w_coeffs;

end