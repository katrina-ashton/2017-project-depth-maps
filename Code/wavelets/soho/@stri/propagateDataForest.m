function  forest = propagateDataForest( forest, level_origin, level_max)
%
% forest = propagateDataForest( forest, level_origin, level_max)
%
% Propagate the data from the nodes at level \a level_origin to the
% corresponding child nodes until level \a level_max (or until the maximal
% tree depth is reached)
%
% @return  forest of wavelet trees where the data from level \a
%          level_origin is propagated
% @param  forest  forest of partition trees
% @param  level_origin  level from which the data "originates"
% @param  level_max  maximum tree depth until which to propagate the data

  % do for all trees
  for( t = 1 : numel( forest))

    % get data and propagate to all childs if on origin level
    if( getLevel( forest(t)) == level_origin)
      
      data = getData( forest(t));      
      
      forest(t) = propagateData( forest(t), level_max, data);
      
    else
      
      % recursively traverse tree until origin level is reached
      
      childs = getChilds( forest(t));
      
      childs = propagateDataForest( childs, level_origin, level_max);
      
      forest(t) = setChilds( forest(t), childs);
      
    end
    
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  forest = propagateData( forest, level_max, data)
%
% forest = propagateData( forest, level_max, col)
%
% Propagate the data to all childs until level \a level_max is reached
%
% @return  forest where the data element has been propagated
% @param  forest  root nodes of forest of partition tree
% @param  level_max  maximum level
% @param  data  data to propagate

  for( t = 1 : numel( forest))
    
    forest(t) = setData( forest(t), data);
    
    % recursively traverse tree if not at final level
    if( getLevel( forest(t)) < level_max)
      
      childs = getChilds( forest(t));
      
      childs = propagateData( childs, level_max, data);
      
      forest(t) = setChilds( forest(t), childs);
      
    end
    
  end
    


end