function verts_singular = removeDuplicateVerts( verts)
%
% verts_singular = removeDuplicateVerts( verts)
% 
% Remove duplicate vertices in \a verts
%
% @return  [3,k] list of vertices with no duplicated entry
% @param verts  [3,n] list of n vertices

  
  epsilon = 10^-12;
  
  duplicate = zeros( 1, size( verts,2));
  
  % first tag duplicate entries, instantenously removing the verts is
  % problematic because the iterator range would have to be readjusted too
  for( i = 1 : size( verts,2))
    for( k = i+1 : size( verts,2))  
     
      % tag vertex if identical
      if( sum( abs( verts(:,i) - verts(:,k))) < epsilon)
        duplicate(k) = 1;
      end
      
    end
  end
  
  % copy non-duplicate entries
  verts_singular = [];
  for( i = 1 : size( verts,2))
    if( 0 == duplicate(i))
      verts_singular = [verts_singular  verts(:,i)];
    end
  end
  
end