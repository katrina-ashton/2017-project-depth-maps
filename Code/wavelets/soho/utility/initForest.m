function  stris = initForest( stris, level, data);
%
% stris = initForest( stris, level, data);
%
% Initialize the data field of all nodes of \a stris and all corresponding 
% child nodes up to level \a level to \a data
% 
% @return  initialized spherical wavelet tree
% @param   stris   root node(s) of spherical wavelet tree
% @param   level   max. level to initialize
% @param   data    default data value 

  for( t = 1 : numel( stris))
    
    % initialize current node
    stris(t) = setData( stris(t), data);
  
    % recursively traverse the tree
    if( getLevel( stris(t)) < level)
    
      childs = initForest( getChilds( stris(t)), level, data);
      stris(t)  = setChilds( stris(t), childs);

    end
    
  end
    
end