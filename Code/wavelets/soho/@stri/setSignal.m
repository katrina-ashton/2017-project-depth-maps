function stris = setSignal( stris, level, signal)
%
% stris = setSignal( stris, level, signal)
%
% Set \a signal at the data fields of \a stris at level \a level
% @return  forest of wavelet trees those nodes at level \a level contain
% signal
% @param  stris  root nodes of forest of wavelet trees
% @param  level  level on which to set the signal
% @param  signal signal to set (for each element in \a stris all data
%                elements are consecutive in \a signal and order according to 
%                the local index on level \a level)
  
  offset = 0;

  % for each wavelet tree
  for( t = 1 : numel( stris))
    
    stris(t) = setSignalPrivate( stris(t), level, signal, offset);
    
    offset = offset + (4^level);
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tri = setSignalPrivate( tri, level, signal, offset)
    
  if( tri.level == level)

    tri.data = signal( : , offset + tri.index_level + 1);
    
  else

    % recursively traverse tree
    for( i = 1 : numel( tri.childs))
      tri.childs(i) = setSignalPrivate( tri.childs(i), level, signal, offset);
    end

  end % end if at final level
  
end