function  coeffs = getCoeffsApprox( tri, level, fh_approx) 
%
% coeffs = getCoeffsApprox( tri, level, fh_approx) 
% 
% Get the basis coefficients from the nodes of the wavelet tree 
%
% @return  vector containing all basis coefficients (scaling function
%         coefficent at the top level and wavelet coefficients at the
%         subsequent coefficients), the coefficients are stored per level
%         and the coefficients of the same type are grouped per level
% @return  weights  vector of the same size as coeffs containing the weights
%                   associated with every basis function coefficient
% @param  tri    root node of wavelet tree
% @param  level  level on which the data is defined
% @param  fh_approx  helper function for computing the accumulated
%                    contribution of a wavelet basis function / wavelet
%                    basis function coefficient to find the *optimal*
%                    approximation in the L_2 norm

  % pre-process optional input arguments

  fa = @getWaveletCoeffs;
  if( nargin > 2)
    fa = fh_approx;
  end
  fh_approx = fa;

  coeffs = [];
  weights = [];

  coeffs = tri.s_coeff;
  coeffs(:,2:4) = fh_approx( tri);
  
  % gather coefficients for st.level > 0
  for( i = 1 : numel( tri.childs))
    coeffs = getCoeffsPrivate( tri.childs(i), level, coeffs, fh_approx);
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function coeffs = getCoeffsPrivate( tri, level, coeffs, fh_approx)
% Get the wavelet coefficients (for level > 1)  
  
  % store coefficients

  % linear indices
  indices = linearIndex( tri);

  w_coeffs = fh_approx( tri);

  % store coefficient(s) for wavelet of type 1
  coeffs( : , indices(1) ) = w_coeffs( : , 1);

  % update index (three coefficients per level, stored separately, i.e. first
  % all coefficients of wavelet type 1 for all nodes are stored, then all
  % coefficients for wavelet type 2, ...
  coeffs( : , indices(2) ) = w_coeffs( : , 2);

  coeffs( : , indices(3) ) = w_coeffs( : , 3);

  % process childs if not the final level
  if( (level - 1) > tri.level)

    % recursively traverse the tree : process the children
    for( i = 1 : numel( tri.childs))
      coeffs = getCoeffsPrivate( tri.childs(i), level, coeffs, fh_approx);
    end

  end % if final level

end
