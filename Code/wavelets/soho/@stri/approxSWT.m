function stris = approxSWT( stris, level, threshold, fh_approx )
%
% stris = approxSWT( stris, level, threshold, fh_approx_weight)
%
% Approximation signal by setting  all coefficients to 0 which are
% smaller than \a threshold
% @return forest of wavelet trees where all coefficients in \a
%         stris which are less than \a threshold are set to zero
% @param  stris  root nodes of forest of wavelet trees
% @param  level  level on which the data is defined (levels on which
%                coefficients are defined + 1)
% @param threshold  zero-threshold
% @param  fh_approx_weight  handle to function which provides the full
%                           contribution of each basis function coefficient
%                           / each basis function to the signal
% @note  data channels are treated independently

  % pre-process optional input arguments

  fa = @getWaveletCoeffs;
  if( nargin > 3)
    fa = fh_approx;
  end
  fh_approx = fa;
  
  % do for all root nodes
  for( t = 1 : numel( stris))

    % wavelet basis function coefficients

    % get the weight
    w_coeffs = abs( fh_approx( stris(t)));

    indices = find( w_coeffs < repmat( threshold,1,size(w_coeffs,2)));
    stris(t).w_coeffs(indices) = 0;   
            
    % recursively traverse tree
    if(  (level - 1) > stris(t).level )
      % do for all childs
      for( i = 1 : numel( stris(t).childs))
        stris(t).childs(i) = approxSWT( stris(t).childs(i), ...
                                        level, threshold, fh_approx );
      end
    end
    
  end % end for all input triangles
  
end