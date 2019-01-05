function  msh = projectMeshToSphere( msh)
%
% stris = projectMeshToSphere( msh)
%
% Project the triangles of the mesh \a msh onto the unit sphere and return
% the resulting spherical triangles
% 
% @return  stris  spherical triangles corrsponding to the projection of the
%          mesh triangles onto the sphere; the data field of the triangles
%          contains the distance of the three vertices from the unit sphere
% @param   msh   mesh
  
  % result
  stris_v1 = [];
  stris_v2 = [];
  stris_v3 = [];

  % do for all triangles of the mesh
  for( i = 1 : size( msh.F, 2))
 
    % euclidean coordinates of the vertices
    verts = zeros( 3, 3);
    
    % do for all three vertices of the current triangle
    for( k = 1 : 3)
    
      vert = msh.V( 1:3 , msh.F(k,i));
      verts(:,k) = vert / norm( vert);
   
    end
   
    stris_v1 = [stris_v1  verts(:,1)];
    stris_v2 = [stris_v2  verts(:,2)];
    stris_v3 = [stris_v3  verts(:,3)];
          
  end
  
  msh.stris_v1 = stris_v1;
  msh.stris_v2 = stris_v2;  
  msh.stris_v3 = stris_v3;    
  
end