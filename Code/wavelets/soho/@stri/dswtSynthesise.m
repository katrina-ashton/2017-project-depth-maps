function stris = dswtSynthesise( stris, level, ....
                                 fh_filters, fh_denormalization, ...
                                 check_transform, store_data )
% @note Use dswtSynthesiseFull as public interface)
%
% stris = dswtSynthesise( stris, level, check_transform, store_data )
% 
% Reconstruct / synthesis a signal 
% @return forest of wavelet trees (see options below)
% @param  stris  root node of spherical wavelet tree (result of analysis / coefficients are
%                initialized
% @param level  level on which to reconstruct the signal
% @param check_transform  {0,1}  if 1, then the reconstruction is compared to
%                         the scaling function coefficients which are stored in
%                         the wavelet tree and the data fields of the nodes at
%                         level \a level, validates perfect reconstruction
%                         condition
% @param store_data  {0,1} if 1, then the reconstructed data /
%                    signal is stored at the nodes at level \a
%                    level, otherwise not

  if(( check_transform == 0) && (store_data == 0))
    warning( 'dswtSynthesise() :: no operation requested.');
    return;
  end
  
  for( t = 1 : numel( stris))
  
    % perform reconstruction for the triangle

    % get filters (reconstruction is transpose of analysis)
    filters = fh_filters( stris(t));

    % reconstruction step
    coeffs = filters * [stris(t).s_coeff stris(t).w_coeffs]';
    coeffs = coeffs';

    % check if scaling function coefficients match
    if( check_transform > 0)
      epsilon = 10^-5;
      for i = 1 : numel( stris(t).childs)
        checkEpsilon( stris(t).childs(i).s_coeff - coeffs(:,i), epsilon);
      end
    end

    % store scaling function coefficients
    for i = 1 : numel( stris(t).childs)
      stris(t).childs(i).s_coeff = coeffs(:,i);
    end
    
    if( stris(t).level == (level - 1))
      
      stris(t) = processNodesLastLevel( stris(t), coeffs, ...
                                        check_transform, store_data, ...
                                        fh_denormalization );

    else

      % do for all childs
      for i = 1 : numel( stris(t).childs)
        stris(t).childs(i) = dswtSynthesise( stris(t).childs(i), level, ...
                                            fh_filters, fh_denormalization, ...
                                            check_transform, store_data);
      end

    end

  end % end for all triangles in tris
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tri = processNodesLastLevel( tri, coeffs, check_transform, ...
                                      store_data, fh_denormalization)
  % Process nodes on final level                                  

  % denormalize coefficients at finest level
  data = fh_denormalization( coeffs, tri);

  % check if data matches
  if( check_transform > 0)

    epsilon = 10^-5;
    for i = 1 : numel( tri.childs)
      checkEpsilon( tri.childs(i).data - data(:,i), epsilon);
    end

  end
  
  % store reconstructed signal
  if( 1 == store_data)

    % store signal coefficients
    for( i = 1 : numel( tri.childs))
      tri.childs(i).data = data(:,i);
    end
  end
  
end

