function ftabs = biohFiltersSynthesis( tri)
%
% ftabs = biohFiltersSynthesis( tri)  
%
% Compute reconstruction / synthesis filters for Bio-Haar wavelets 
% [Schroeder 1995]
% @return filter tabs matrix (4x4 matrix) with reconstruction filters
% @param  tri  domain for which the filter coefficients have to be computed
  
  % cache some values for convenience
  childs = getChilds( tri);
  area_child_1 = getArea( childs(1));
 
  ftabs = eye( 4, 4) * 2;
  
  % scaling basis function filter coefficients
  ftabs(:,1) = 1;
  
  % wavelet basis function filter coefficients (elements which are not set
  % are zero, the diagonal is already initialized to 2)
  ftabs(1,2) = -2.0 * getArea( childs(2)) / area_child_1;
  ftabs(1,3) = -2.0 * getArea( childs(3)) / area_child_1;
  ftabs(1,4) = -2.0 * getArea( childs(4)) / area_child_1;
  
end
  
