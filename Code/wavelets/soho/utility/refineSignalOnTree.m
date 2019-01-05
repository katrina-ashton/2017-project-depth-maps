function forest = refineSignalOnTree( forest, num_levels, ...
                                      enforce_area_constraint)
%
% forest = refineSignalOnTree( forest, num_levels, enforce_area_constraint)
%
% Refine the given forest and propagate the data defined on the current
% leaves to the new leaves on (max_current_level + num_levels)
% @param enforce_area_constraint  area constraint enforcement for SOHO
%                                 wavelets (default = 0)

  eaf = 0;
  if( nargin > 2)
    eaf = enforce_area_constraint;
  end
  enforce_area_constraint = eaf;

  
  if( 0 == num_levels)
    return;
  end

  for( i = 1 : numel( forest))

    % subdivide the current stri
    forest(i) = subdivide( forest(i), enforce_area_constraint);
    
    % update the data fields and refine children
    childs = getChilds( forest(i));
    
    data = getData( forest(i));
    
    for( j = 1 : numel( childs))
      
      childs(j) = setData( childs(j), data);
      childs(j) = refineSignalOnTree( childs(j), num_levels - 1, ...
                                      enforce_area_constraint );
    end
                                     
    % store childs
    forest(i) = setChilds( forest(i), childs);
    
  end
  
end