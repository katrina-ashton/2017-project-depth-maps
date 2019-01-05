function stris = dswtAnalyse( stris, level_signal, ...
                              fh_filters, fh_normalization) 
%(use oshAnalyseFull as public interface)
%
% stris = dswtAnalyse( stris, level_signal,fh_ filters, fh_normalization, 
%                      normalize)
% 
% Perform full osh wavelet analysis
% @return  root nodes of forest of wavelet trees which contains the wavelet
%          coefficients 
% @param  stris  root nodes of forest of wavelet trees
% @param  level_signal  level on which the signal is defined in the source
%                       basis (for the projection wavelet basis function
  
  for( t = 1 : numel( stris))

    if( stris(t).level == (level_signal - 1)) 

      % local signal
      coeffs = [ stris(t).childs(1).data, stris(t).childs(2).data, ...
                 stris(t).childs(3).data, stris(t).childs(4).data ];

      % normalization
      coeffs = fh_normalization( coeffs, stris(t));

      % store scaling function coefficients for childs
      for( i = 1 : numel( stris(t).childs))
        stris(t).childs(i).s_coeff = coeffs(:,i);
      end

    else

      % process childs firt
      for i = 1 : numel( stris(t).childs)
        stris(t).childs(i) = dswtAnalyse( stris(t).childs(i), level_signal, ...
                                         fh_filters, fh_normalization );
      end    

    end

    % analysis step 
    stris(t) = dswtAnalysisStep( stris(t), fh_filters);
  
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function st = dswtAnalysisStep( st, fh_filters)

  % local signal
  coeffs = [ st.childs(1).s_coeff, st.childs(2).s_coeff, ...
             st.childs(3).s_coeff, st.childs(4).s_coeff ]';
    
  % get filter coefficients
  filters = fh_filters( st);

  % perform analysis
  coeffs = filters * coeffs;
  % re-transpose
  coeffs = coeffs';
  st.s_coeff = coeffs(:,1);

  % store result
  st.w_coeffs = coeffs(:,2:4);

end

