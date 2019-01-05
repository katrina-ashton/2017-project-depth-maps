function stris = setDataSWTNode( stris, pos, val, level, fhandle_update)
%
% function data = setDataDWTNode( stris, pos, val, level, fhandle_update)
%
% Set data \a val for the node into which \a pos falls on level \a level of
% the wavelet tree specified by stris
%
% @param  stris  root node of a spherical wavelet tree (initially this
%                should be the root nodes of the trees of the forest)
% @param  pos    position on the unit sphere
% @param  val    value to set
% @param  level  level on which the data ought to be set
% @param  fhandle_update  update policy (should be min, max, or mean (avg.))
  
  node = -1;
  for( t = 1 : numel( stris))
    
    if( 1 == checkPointInsideSTri( stris(t), pos))
      node = t;
      break;
    end
    
  end
  
  % the point has to be in one of the triangles
  condition( node > -1);
  
  % process node
  if( getLevel( stris(node)) == level)
    
    stris(node) = ...
      setData( stris(node), fhandle_update( [getData( stris(node)), val]));
    
  else
    
    % recursively traverse nodes
    childs = setDataSWTNode( getChilds( stris(node)), pos, val, level, ...
                             fhandle_update );
    stris(node) = setChilds( stris(node), childs);
    
  end
  
end