function wc = getWaveletCoeff( tri, index)
%
% wc = getWaveletCoeff( tri, index)
%
% Get wavelet coefficient of wavelet \a index associated with the
% sub-domain which corresponds to \a tri
%
% @return  wc     wavelet coefficient
% @param  tri    spherical triangle over those direct childs the wavelet
%                basis function is defined
% @param  index  {1,2,3} index of the wavelet basis function

  wc = tri.w_coeffs(index);

end