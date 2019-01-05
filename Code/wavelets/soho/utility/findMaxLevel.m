function levels = findMaxLevel( tri, level)
%
%  levels = findMaxLevel( tri, level)
%
% Find the maximum level of the tree with non-zero coefficients
%
% @return  -1 if the whole tree including tri is zero, otherwise the level
% @param   tri  root node of wavelet tree
% @param   level  maximum traversal depth

  childs = getChilds( tri);
  levels = -1 * ones( 1, numel( childs));
  
  if( 0 ~= getScaleCoeff( tri))
    levels = 0;
  end
  
  for( i = 1 : numel( childs))
    levels(i) = findMaxLevelPrivate( childs(i), level);
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function level = findMaxLevelPrivate( tri, level)
  
  level = -1;
  childs = getChilds(tri);
  
  % check if nonzero coefficients at childs
  for( i = 1 : numel( childs))
    level = max( level, findMaxLevelPrivate( childs(i)));
  end

  % all childs are zero
  if( -1 == level)
    wc = [ getWaveletCoeff( tri, 1), ...
           getWaveletCoeff( tri, 2), ...
           getWaveletCoeff( tri, 3) ];
    if( 0 ~= sum( abs( wc(:))))
      level = getLevel( tri);
    end
  end

end