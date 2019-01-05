function stris = dswtAnalyseFull( stris, level, fh_filters, fh_normalization)
%
% stris = dswtAnalyseFull( stris, level)
%
% OSH wavelet analysis of spherical signal 
% @return  forest of wavelet tree those nodes contain the wavelet
%          coefficients
% @param  stris  root nodes of forest of wavelet tree
% @param  level  level on which the data is defined (already stored in
%                the wavelet tree)

  stris = dswtAnalyse( stris, level, fh_filters, fh_normalization);
  
end
