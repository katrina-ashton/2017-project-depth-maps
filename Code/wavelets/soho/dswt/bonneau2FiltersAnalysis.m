function ftabs = bonneau2FiltersAnalysis( tri)
%
% ftabs = bonneau1FiltersAnalysis( tri)
%
% Compute analysis filters for nearly orthogonal wavelets proposed by Bonneau
% for the domain specified by spherical triangle
% @return filter tabs in synthesis matrix (4x4 matrix)
% @param  tri  domain for which the filter coefficients have to be computed

  ftabs = inv( bonneau2FiltersSynthesis( tri));
 
end