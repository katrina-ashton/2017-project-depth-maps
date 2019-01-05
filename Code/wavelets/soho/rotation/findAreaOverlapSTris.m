function a = findAreaOverlapSTris( t0, t1)
%
% a = findAreaOverlapSTris( t0, t1)
%
% Compute the overlap between two spherical triangles
%
% @return  area of the overlap
% @param t0  spherical triangle
% @param t1  spherical triangle

  a = 0;

  % check if one triangle is fully contained in the second one
  
  [all_inside inside_t0] = allPointsInsideSTri( t0, t1);
  if(1 == all_inside)
    a = getArea( t1);
    return;
  end
  
  [all_inside inside_t1] = allPointsInsideSTri( t1, t0);
  if( 1 == all_inside )
    a = getArea( t0);
    return;
  end

  % find the intersection points between the arcs of t0 and t1
  ipoints = findIntersectionPointsSTris( t0, t1);

  
  if( numel( ipoints) > 0)
   
    % merge multiple points
    ipoints = removeDuplicateVertsStruct( ipoints);

    if( numel( ipoints) > 1)
  
      verts_overlap = findOverlapSTris( t0, t1, inside_t0, inside_t1, ipoints);

      % non-degenerated spherical polygon has at least three vertices
      if( size( verts_overlap, 2) > 2)
        
        verts(:,1) = verts_overlap(:,1);
        for( i = 2 : ( size( verts_overlap, 2) - 2))

          verts(:,2) = verts_overlap(:,i);
          verts(:,3) = verts_overlap(:,i+1);        

          a = a + computeAreaSTri( verts);

        end
        
      end
        
    end
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function verts_singular = removeDuplicateVertsStruct( verts)
%
% verts_singular = removeDuplicateVertsStruct( verts)
% 
% Remove duplicate vertices in \a verts
%
% @return  list of vertex structures with no duplicated entry
% @param  verts  list of vertex structures 

  
  epsilon = 10^-12;
  
  duplicate = zeros( 1, numel( verts));
  
  % first tag duplicate entries, instantenously removing the verts is
  % problematic because the iterator range would have to be readjusted too
  for( i = 1 : numel( verts))
    for( k = i+1 : numel( verts))  
     
      % tag vertex if identical
      if( duplicate(k) == 0)
        if( sum( abs( verts(i).vert - verts(k).vert)) < epsilon)
          duplicate(k) = i;
        end
      end
    end
  end
 
  % copy non-duplicate entries
  verts_singular = [];
  for( i = 1 : numel( verts))
    if( 0 == duplicate(i))
      verts_singular = [verts_singular  verts(i)];
    end
  end
  
end