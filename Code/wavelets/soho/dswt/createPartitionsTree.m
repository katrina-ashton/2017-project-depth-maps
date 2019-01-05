function st = createPartitionsTree( st, num_levels, enforce_area_constraint )
%
% st = createPartitionsTree( st, num_levels, enforce_area_constraint )
%
% Recursively generate a tree of partitions over which a wavelet basis can
% be defined
%
% @return  root node of the tree of partition
% @param  st  spherical triangle which is the initial partition
% @param  num_levels  number of levels remaining in the tree
% @param  enforce_area_constraint  {0,1}{1 == default}  if 1, the subdivision 
%                                  enforces that the area of the three outer 
%                                  child triangles (index 2, 3, 4) is equal
  
  if( num_levels > 0)
  
    % subdivide the current stri
    st = subdivide( st, enforce_area_constraint);

    % generate the tree recursively

    childs = getChilds( st);

    for( i = 1 : numel( childs))
      
      childs(i) = createPartitionsTree( childs(i), num_levels - 1, ...
                                        enforce_area_constraint );
    end
                                     
    % store childs
    st = setChilds( st, childs);
    
  end
  
end