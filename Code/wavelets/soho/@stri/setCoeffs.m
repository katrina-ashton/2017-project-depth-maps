function  tri = setCoeffs( tri, level, coeffs) 
%
% tri = setCoeffs( tri, level, coeffs) 
% 
% Set the basis coefficients for a wavelet tree 
%
% @return  root node of wavelet trees where the basis function coefficients
%          from \a coeffs have been stored in the appropriate nodes of the
%          tree
% @param  tri    root node of wavelet tree
% @param  level  the wavelet coefficients are defined on level 0 to level
%                \a (level - 1), i.e. the signal which has been represented
%                in the basis has been defined on level \a level
% @param  coeffs  vector of basis function coefficients 


  % pre-process optional input args
  
  % coefficients with root partition
  tri.s_coeff = coeffs(:,1);
  tri.w_coeffs = coeffs(:,2:4);
  
  % set coefficients on finer levels
  for( i = 1 : numel( tri.childs))
    tri.childs(i) = setCoeffsPrivate( tri.childs(i), level, coeffs);
  end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tri = setCoeffsPrivate( tri, level, coeffs )
  
  % store coefficients

  % linear indices of the wavelet basis function associated with the
  % partition which corresponds to tri
  indices = linearIndex( tri);

  % store coefficient(s) for wavelet of type 1
  tri.w_coeffs = ...
    [ coeffs( :, indices(1)) , coeffs( :, indices(2)) , coeffs( :, indices(3))] ;
 
  % process childs if not the final level
  if( (level - 1) > tri.level)

    % recursively traverse the tree : process the children
    for( i = 1 : numel( tri.childs))
      tri.childs(i) = setCoeffsPrivate( tri.childs(i), level, coeffs );
    end

  end % if final level

end

