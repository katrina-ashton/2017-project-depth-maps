function forest = createForestSymmetric( platonic_solid, ...
                                         num_levels, ...
                                         enforce_area_constraint)
%
% forest = createForestSymmetric( platonic_solid, ...
%                                 num_levels, ...
%                                 enforce_area_constraint)
%
% Construct a partition tree which is symmetric w.r.t S^2, i.e. for every
% partition \tau_{j,k} with vertices v_i a dual partition \bar{\tau}_{j,k}
% exists where \bar{v}_i = v_i.
%
% @param platonic_solid   {'octahedron','icosahedron'} platonic solid from which
%                         the forest of partition trees is derived
% @param  num_levels  depth of the partition tree
% @param  enforce_area_constraint  enforce the area constraint for the
%                                  three outer child triangles during
%                                  construction
 
  if( 1 == strcmp( 'octahedron', platonic_solid))
    p_solid = create_octahedron();
  elseif( 1 == strcmp( 'icosahedron', platonic_solid))
    p_solid = create_icosahedron();
  else
    error('Platonic solid not supported or no symmetric construction possible');
  end
  
  num_half_trees = numel( p_solid) / 2;
  
  % construct the first 10 partitions regularaly
  for( p = 1 : num_half_trees)
    forest(p) = ...
      createPartitionsTree(p_solid(p), num_levels, enforce_area_constraint);
  end
  
  % the remaining 10 partitions are obtained by mirroring
  for( p = 1 : num_half_trees)
    forest(p+num_half_trees) = mirrorPartitionTree( forest(p));
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  tree_root = mirrorPartitionTree( tree_root)
%
% tree = mirrorPartitionTree( tree)
%
% Mirror the partition tree at the origin
%
% @return root node of mirrored partition tree
% @param  tree_root  root node of partition tree to mirror

  % mirror current partition
  verts = getVertsEC( tree_root);  
  verts = -1.0 * verts;
  verts = verts( : , [3 2 1]);
  tree_root = setVertsEC( tree_root, verts);
  
  % recursively traverse tree
  
  childs = getChilds( tree_root);
  for( i = 1 : numel( childs))
    childs(i) = mirrorPartitionTree( childs(i));
  end
  tree_root = setChilds( tree_root, childs);
  
end