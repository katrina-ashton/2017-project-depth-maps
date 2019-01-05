function  [num_trees_zt , num_trees_nzt] = findZerotrees( forest, level, ...
                                                          threshold, fhs)
%
% [num_trees_zt , num_trees_nzt] = findZerotrees( forest, threshold, level, fhs)
%
% Find the number of zerotrees \a num_trees_zt  vs. the number of trees
% where this assumption is violated \a num_trees_nzt  for \a forest
%
% @return  num_trees_zt   number of zerotrees in forest
% @return  num_trees_nzt  number of trees where the zerotree assumption is
%                         violated
% @param  forest  forest for which to determine the number of zerotrees
% @param threshold  threshold below all coefficients are considered as
% insignificant
% @param  fhs  function handles corresponding to the spherical Haar wavelet
%              basis employed

  num_trees_zt = zeros(1,level);
  num_trees_nzt = zeros(1,level);
  
  % do for all input trees
  for( t = 1 : numel( forest))
    [num_trees_zt , num_trees_nzt] = ...
      findZerotreesPrivate( forest(t), threshold, fhs, ...
                            num_trees_zt, num_trees_nzt ); 
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function is_irrel = checkThreshold( tri, threshold, fhs)
%
% is_true = checkThreshold( tri, threshold)
%
% Check if wavelet coefficients of \a tri are irrelevant w.r.t. to the
% threshold
%
% @param 1 if the wavelet coefficients are below the threshold, otherwise 0
% @param tri  spherical triangle to check
% @param threshold  threshold which determines irrelevance

  % get data
  w_coeffs = fhs.approx( tri);
  
  % operate on average
  w_coeff_avg = mean( w_coeffs(:));
  
  is_irrel = ( w_coeff_avg < threshold);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [num_trees_zt , num_trees_nzt] =  ...
   findZerotreesPrivate( tree_root, threshold, fhs, num_trees_zt, num_trees_nzt)
%
%
%

  childs = getChilds( tree_root);
  
  if( numel( childs) > 0)
  
    is_irrel = checkThreshold( tree_root, threshold, fhs);
    if( is_irrel > 0)

      % check if whole tree below the current root node satisfies the
      % zerotree condition
      num_violations = 0;
      num_violations = checkZerotreesChilds( childs, threshold, fhs, ...
                                             num_violations);

      c_level = getLevel( tree_root) + 1;
                                             
      % abort recursion / traversal of tree if zerotree assumption holds,
      % otherwise mark failure and continue traversal
      if( 0 == num_violations)
        num_trees_zt(c_level) = num_trees_zt(c_level) + 1;
        return;
      else
        num_trees_nzt(c_level) = num_trees_nzt(c_level) + 1;
      end

    end

    % recursively traverse the tree
    for( i = 1 : numel( childs))
      [num_trees_zt , num_trees_nzt] = ...
        findZerotreesPrivate( childs(i), threshold, fhs, ...
                              num_trees_zt, num_trees_nzt); 
    end
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function num_violations = checkZerotreesChilds( trees, threshold, fhs, ...
                                                num_violations)
%
%
%
 
  is_zt = 1;

  for( t = 1 : numel( trees))
  
    childs = getChilds( trees(t));
  
    if( numel( childs) > 0)

      is_irrel = checkThreshold( trees(t), threshold, fhs);
      num_violations = num_violations + (~is_irrel);
    
    
      for( i = 1 : numel( childs))
        num_violations = checkZerotreesChilds( childs(i), threshold, fhs, ...
                                               num_violations );      
      end

    end
  end
  
end