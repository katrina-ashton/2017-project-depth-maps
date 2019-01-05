function stris = dswtSynthesiseFull( stris, level, ...
                                    fh_filters, fh_denormalization, ...
                                    check_transform, store_data )
%
% stris = dswtSynthesiseFull( stris, level, check_transform, store_data)
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
  
  % pre-process input args
  ct = 0;
  if( nargin > 4)
    ct = check_transform;
  end
  check_transform = ct;
  
  rs = 0;
  if( nargin > 5)
    rs = store_data;
  end
  store_data = rs;

  % perform synthesis
  stris = dswtSynthesise( stris, level, ...
                          fh_filters, fh_denormalization, ...
                          check_transform, store_data);
  
  if( check_transform)
    % no error up to this point => reconstruction succeeded
    disp( sprintf('Reconstruction succeeed.')); 
  end
  
end
