function ftabs = npwhFiltersSynthesis( tri)
%
% ftabs = npwhFiltersSynthesis( tri)  
%
% Analysis filters for normalized pseudo wavelets
%
% @return filter tabs matrix (4x4 matrix) with analysis filters
% @param  tri  domain for which the filter coefficients have to be computed
  
  ftabs = npwhFiltersAnalysis( tri)';
    
end
  
