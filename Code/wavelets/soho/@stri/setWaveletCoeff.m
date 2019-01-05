function st = setWaveletCoeff( st, index, val)
%
% st = setWaveletCoeff( st, index, val)
%
% Set the wavelet basis function coefficient for the index-th wavelet
% defined over \a st

  st.w_coeff(:,index) = val;

end