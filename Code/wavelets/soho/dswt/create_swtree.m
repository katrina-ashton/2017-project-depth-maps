function stris = create_swtree( stris, num_levels, enforce_area_constraint)
%
% stris = create_swtree( stris, num_levels)
%
% Create the data structure which represents a spherical wavelet tree
% @return  stris   root nodes of forest of wavelet tris 
% @param  stris  root nodes of wavelet tree(s) to generate
% @param  num_levels  depth of generated wavelet tree(s)
% @param  enforce_area_constraint  {0,1}{1 == default}  if 1, the subdivision 
%                                  enforces that the area of the three outer 
%                                  child triangles (index 2, 3, 4) is equal

  % pre-process input args
  eac = 1;
  if( nargin > 2)
    eac = enforce_area_constraint;
  end
  enforce_area_constraint = eac;
    
  
  if( num_levels > 0)

    % do for all of the given domains
    for i = 1 : numel( stris)

      % subdivide the current stri
      if( nargin > 2)
        stris(i) = subdivide( stris(i), enforce_area_constraint);
         
        % recursively subdivide the children
        childs = create_swtree( getChilds( stris(i)), num_levels - 1, ...
                                enforce_area_constraint );
        % store childs
        stris(i) = setChilds( stris(i), childs);
                                              
      else
        stris(i) = subdivide( stris(i), enforce_area_constraint);

        % recursively subdivide the children
        stris(i) = setChilds( stris(i), create_swtree( getChilds( stris(i)), ...
                                                       num_levels - 1, ...
                                                      enforce_area_constraint));
 
      end
           
    end
    
  end  % if num_levels > 0

  
end % end function