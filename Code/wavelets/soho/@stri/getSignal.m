function signal = getSignal( tri, level)
% 
% signal = getSignal( tri, level)
% 
% Extract the signal defined at the data fields of the nodes from a wavelet tree  
% @param  tri  root node of wavelet tree  
% @param  level  level on which the signal is defined

  signal = [];
  signal = getSignalPrivate( tri, level, signal);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function signal = getSignalPrivate( tri, level, signal)
  
  if( tri.level == level)
    
    signal(:, tri.index_level + 1) = tri.data; 
    
  else
    
    % recursively traverse the tree
    for( i = 1 : numel( tri.childs))
      signal = getSignalPrivate( tri.childs(i), level, signal);
    end
    
  end
  
end