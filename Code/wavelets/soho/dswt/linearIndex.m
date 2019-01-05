function indices = linearIndex( tri)
%
% [index_w1 , index_w2 , index_w3] = linearIndex( tri)
%
% Get the linear index positions for the wavelet basis function coefficient
% for the wavelet basis functions associated with \a tri
%
% @return  indices [3x1] indices for the three wavelet basis functions
%                        associated with tri


  % offset for coefficients on coarser levels
  nodes_level = 4^( getLevel( tri));

  % offset of the triangle on the level
  indices(1) = nodes_level + getIndexLevel( tri) + 1;

  indices(2) = indices(1) + nodes_level;
  indices(3) = indices(2) + nodes_level;  
  
end