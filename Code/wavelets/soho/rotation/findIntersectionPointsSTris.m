function ipoints = findIntersectionPointsSTris( t0, t1)
%
% ipoints = findIntersectionPointsSTris( t0, t1)
%
% Find the intersection points between the arcs of the two spherical
% triangels \a t0 and \a t1
%
% @return  list of intersection points
% @param  t0  spherical triangle
% @param  t1  spherical triangle


  % compute planes corresponding to the great arcs forming the sides of the
  % spherical triangles

  arcs_t0 = {};
  arcs_t0{1} = [ getVertex( t0, 2), getVertex( t0, 1)];  
  arcs_t0{2} = [ getVertex( t0, 3), getVertex( t0, 2)]; 
  arcs_t0{3} = [ getVertex( t0, 1), getVertex( t0, 3)];
  
  arc_t1 = {};
  arc_t1{1} = [ getVertex( t1, 2), getVertex( t1, 1)];  
  arc_t1{2} = [ getVertex( t1, 3), getVertex( t1, 2)]; 
  arc_t1{3} = [ getVertex( t1, 1), getVertex( t1, 3)];
  
  % compute the intersection points between the arcs
  
  ipoints = [];
  
  for( i = 1 : 3)
    for( k = 1 : 3)
      
      ipoint = checkIntersectionArcs( arcs_t0{i}, arc_t1{k});
      
      if( numel( ipoint) > 0)
        
        temp.vert = ipoint;
        temp.a0 = i - 1;
        temp.a1 = k - 1;
        
        ipoints = [ipoints temp];
      end
      
    end
  end
  
end