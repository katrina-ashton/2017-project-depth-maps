function ftabs = oshFiltersSynthesis( tri)
%
% ftabs = oshFilters( tri)
%
% Compute synthesis filters for osh wavelets for domain specified by spherical 
% triangle
% @return filter tabs in analysis matrix (4x4 matrix)
% @param  tri  domain for which the filter coefficients have to be computed

  % synthesis matrix is transpose of analysis
  ftabs = oshFiltersAnalysis( tri)';
  % ftabs = inv( oshFiltersAnalysis( tri));
  
end
