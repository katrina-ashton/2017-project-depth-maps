function ftabs = biohFiltersAnalysis( tri)
%
% ftabs = biohFiltersAnalysis( tri)  
%
% Compute analysis filters for Bio-Haar wavelets [Schroeder 1995]
% @return filter tabs matrix (4x4 matrix) with analysis filters
% @param  tri  domain for which the filter coefficients have to be computed
    
%   % cache some values for convenience
%   childs = getChilds( tri);
%   area_p = getArea( tri);
%   
%   L1 = getArea( childs(1)) / area_p;
%   L2 = getArea( childs(2)) / area_p;
%   L3 = getArea( childs(3)) / area_p;
%   L4 = getArea( childs(4)) / area_p;  
%   
%   ftabs = zeros(4,4);
%   
%   % scaling basis function filter coefficients
%   ftabs(1,1) = L1;
%   ftabs(1,2) = L2;
%   ftabs(1,3) = L3;
%   ftabs(1,4) = L4;  
%   
%   % wavelet basis function filter coefficients 
%   
%   ftabs(2,1) = -1/2 * L1;
%   ftabs(2,2) =  1/2 * ( 1 - L2);
%   ftabs(2,3) = -1/2 * L3;
%   ftabs(2,4) = -1/2 * L4;
%   
%   ftabs(3,1) = -1/2 * L1;
%   ftabs(3,2) = -1/2 * L2;
%   ftabs(3,3) =  1/2 * ( 1 - L3);
%   ftabs(3,4) = -1/2 * L4;
%   
%   ftabs(4,1) = -1/2 * L1;
%   ftabs(4,2) = -1/2 * L2;
%   ftabs(4,3) = -1/2 * L3; 
%   ftabs(4,4) =  1/2 * ( 1 - L4);
  
  ftabs = inv( biohFiltersSynthesis( tri));
  
end
  
