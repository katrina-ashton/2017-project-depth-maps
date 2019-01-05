function forest = getForestPlatonicSolid( platonic_solid, level, ...
                                          area_constraint)
%
% forest = getForestPlatonicSolid( platonic_solid, level, area_constraint)
%
% Get the forest of partition trees derived from \a platonic_solid until
% level \a level.
%
% @param  platonic_solid  {'octahedron', 'tetrahedron', 'icosahedron'}
%                          platonic solid from which the partition is
%                          derived over which the basis is constructed
% @param  level  maximal  level of the partition trees
% @param  area_constraint  {0,1} flag indicating if the tree is to be
%                          constructed with enforcing the area constraint
%                          for the three outer child triangles or not

  if( 1 == strcmp( 'octahedron', platonic_solid))
    forest = createForestSymmetric( platonic_solid, level, area_constraint);
  elseif( 1 == strcmp( 'icosahedron', platonic_solid))    
    forest = createForestSymmetric( platonic_solid, level, area_constraint);
  elseif( 1 == strcmp( 'tetrahedron', platonic_solid))
    roots = create_tetrahedron();
    forest = create_swtree( roots, level, area_constraint);
  else
    error( 'Platonic solid not supported.');
  end
    
end
