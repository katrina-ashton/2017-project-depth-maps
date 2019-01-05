function  swt_tree = sampleMesh( swt_tree, level, mesh, mode, fhandle_update) 
%
% swt_tree = sampleMesh( swt_tree, level, mesh, mode, fhandle_update)
%
% Sample the mesh onto the \a level of \a swt_tree
%
% @param  swt_tree  spherical wavelet tree with at least \a level levels
% @param  level     level onto which the data 
% @param  mesh      structure containing the vertices and faces of the mesh
%                   as returned by loadObj
% @param  mode      mode = 1 => vertices
%                   mode = 2 => face centroids
% @param  fhandle_update  function used to update a node which is already
%                         initialized (should be max. or avg.)

  if( strcmp( func2str( @min), func2str( fhandle_update)))
    disp( sprintf( ['Warning: "min" not supported. Requires ' ...
                    'initialization of tree with max. possible value.']));
    return;
  end

  if( 2 == mode) 
   
    disp( sprintf( 'Mode currently not supported.'));
    
  elseif( 1 == mode) 
    
    swt_tree = sampleMeshVert( swt_tree, level, mesh, fhandle_update); 
    
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  swt_tree = sampleMeshVert( swt_tree, level, mesh, fhandle_update) 
%
% swt_tree = sampleMesh( swt_tree, level mesh, fhandle_update)
%
% Sample the mesh vertices onto the \a level of \a swt_tree
%
% @param  swt_tree  spherical wavelet tree with at least \a level levels
% @param  level     level onto which the data 
% @param  mesh      structure containing the vertices and faces of the mesh
%                   as returned by loadObj
% @param  fhandle_update  function used to update a node which is already
%                         initialized (should be max. or avg.)

  % compute normalization constant

  norm_val = 0.0;
  % do for all vertices
  for( i = 1 : size( mesh.V, 2))
    norm_val = max( norm_val, norm( mesh.V(1:3,i)));
  end
  
  % sampling
  
  for( i = 1 : size( mesh.V, 2))
    
    % compute normalized distance to unit sphere
    d = (norm( mesh.V(1:3,i)) / norm_val) * 255.0;
    pos = (mesh.V(1:3,i)) ./ norm( mesh.V(1:3,i));
    % disp( sprintf( '%i :: %f / %f / %f\n', i, pos(1), pos(2), pos(3)));
    
    % set the data at the right node in the tree
    swt_tree = setDataSWTNode( swt_tree, pos, d, level, fhandle_update);
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
