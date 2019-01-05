function ftabs = nielson1FiltersSynthesis( tri)
%
% ftabs = nielson1FiltersSynthesis( tri)
%
% Compute synthesis filters for nearly orthogonal wavelets proposed by
% Nielson et al. for the domain specified by spherical triangle
% @return filter tabs in synthesis matrix (4x4 matrix)
% @param  tri  domain for which the filter coefficients have to be computed

  ftabs = inv( nielson1FiltersAnalysis( tri));

end