function a = getOverlapArea( t0, t1, inside_t0, inside_t1, ipoints)
%
%
%
% Compute the area of overlap

  num_ipoints = size( ipoints, 2);

  a = 0;
  
  if( 1 == num_ipoints)
    
    a = getOverlap1IPoints( t0, t1, inside_t0, inside_t1, ipoints);
    
  elseif( 2 == num_ipoints)
    
    a = getOverlap2IPoints( t0, t1, inside_t0, inside_t1, ipoints);
    
  elseif( 3 == num_ipoints)
    
    a = getOverlap3IPoints( t0, t1, inside_t0, inside_t1, ipoints);
    
  elseif( 4 == num_ipoints)
      
    a = getOverlap4IPoints( t0, t1, inside_t0, inside_t1, ipoints);
   
  elseif( 5 == num_ipoints)

    a = getOverlap5IPoints( t0, t1, inside_t0, inside_t1, ipoints);

  elseif( 6 == num_ipoints)

    a = getOverlap6IPoints( t0, t1, inside_t0, inside_t1, ipoints);

  else
    
    error( 'Unknown configuration.');
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = getOverlap6IPoints( t0, t1, inside_t0, inside_t1, ipoints)

  a = 0;
  degenerated = 0;

  arcs = { [2 1], [3 2] [1 3]}; 

  % there are three pairs of points
  
  p1 = 1;
  for( i = 2 : numel( ipoints))
    if( ipoints(i).a0 == ipoints(p1(1)).a0)
      p1 = [p1 i];
    end
  end
  condition( numel(p1) == 2);
  
  temp = setdiff( [1 : numel( ipoints)], p1);
      
  p2 = temp(1);
  for( i = temp(2:end))
    if( ipoints(i).a0 == ipoints(p2(1)).a0)
      p2 = [p2 i];
    end
  end
  condition( numel(p2) == 2);
  
  p3 = setdiff( [1 : numel( ipoints)], [p1 p2]);
  condition( ipoints(p3(1)).a0 == ipoints(p3(2)).a0);
  
  top = intersect( arcs{ipoints(p1(1)).a1+1}, arcs{ipoints(p1(2)).a1+1});
  condition( numel( top) == 1);
  
  verts(:,1) = t1.verts_ec(:,top);
  verts(:,2) = ipoints(p1(1)).vert;
  verts(:,3) = ipoints(p1(2)).vert; 
  [a, degenerated] = area( t0, t1, verts, a, degenerated);   
 
  
  top = intersect( arcs{ipoints(p2(1)).a1+1}, arcs{ipoints(p2(2)).a1+1});
  condition( numel( top) == 1);
  
  verts(:,1) = t1.verts_ec(:,top);
  verts(:,2) = ipoints(p2(1)).vert;
  verts(:,3) = ipoints(p2(2)).vert; 
  [a, degenerated] = area( t0, t1, verts, a, degenerated); 
  
  
  top = intersect( arcs{ipoints(p3(1)).a1+1}, arcs{ipoints(p3(2)).a1+1});
  condition( numel( top) == 1);
  
  verts(:,1) = t1.verts_ec(:,top);
  verts(:,2) = ipoints(p3(1)).vert;
  verts(:,3) = ipoints(p3(2)).vert; 
  [a, degenerated] = area( t0, t1, verts, a, degenerated); 
  
  a = t1.area - a;
%  plotEdges2D( t1, 1.01, [1 1 0]);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = getOverlap1IPoints( t0, t1, inside_t0, inside_t1, ipoints)

  % degenerated case: the single point has to coincide with one vertex of
  % at least one point
  t0_c = 0;
  for( i = 1 : 3)
    if( 1 == equalPoints( t0.verts_ec(:,i), ipoints.vert))
      t0_c = t0_c + 1;
    end
  end

  t1_c = 0;
  for( i = 1 : 3)
    if( 1 == equalPoints( t1.verts_ec(:,i), ipoints.vert))
      t1_c = t1_c + 1;
    end
  end
  
  condition( ( 1 == t1_c) || ( 1 == t0_c));
  
  a = 0;
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = getOverlap5IPoints( t0, t1, inside_t0, inside_t1, ipoints)

  a = 0;
  degenerated = 0;
  
  arcs = { [2 1], [3 2] [1 3]}; 

  % degenerated case: two sides, one of each triangle, are co-planar
  t0_n = zeros(3,3);
  [t0_n(:,1), t0_n(:,2), t0_n(:,3)] = getPlanes( t0);
  [t1_n(:,1), t1_n(:,2), t1_n(:,3)] = getPlanes( t1);  

  checker = 0;
  ip = -1;
  for( i = 1 : 3)
    for( k = 1 : 3)
      if( 1 == equalPoints( t0_n(:,i), t1_n(:,k)))
        checker = checker + 1;
        ip = i;
      end
    end
  end
  if( 1 == checker)
  
    % verts of arc
    arc = arcs{ip};
    arc = [t0.verts_ec(:,arc(1)) , t0.verts_ec(:,arc(2))];

    % find the two points which lie in the common plane of the two sides
    points_arc = [];
    for( i = 1 : numel( ipoints))
      if( 1 == checkPointOnArc( arc(:,1), arc(:,2), ipoints(i).vert))
          points_arc = [points_arc i];
      end
    end
    condition( numel( points_arc) == 2);

    % find the points which lie on the same arc as points_arc
    vs = {[], []};
    for( i = 1 : 2)
      for( k = 1 : numel( ipoints))
  
        if( points_arc(i) == k)
          continue;
        end

        if(    (ipoints(k).a0 == ipoints( points_arc(i)).a0) ...
            || (ipoints(k).a1 == ipoints( points_arc(i)).a1) )

          condition( numel( vs{i}) == 0);
          vs{i} = [k points_arc(i)];
        end

      end
    end

    v_top = setdiff( [1 : numel(ipoints)] , [vs{1}, vs{2}]);

    for( i = 1 : 2)

      temp = vs{i};
      verts(:,1) = ipoints(v_top).vert;
      verts(:,2) = ipoints(temp(1)).vert;
      verts(:,3) = ipoints(temp(2)).vert;
      [a, degenerated] = area( t0, t1, verts, a, degenerated); 

    end

    verts(:,1) = ipoints(v_top).vert;
    verts(:,2) = ipoints(points_arc(1)).vert;
    verts(:,3) = ipoints(points_arc(2)).vert;
    [a, degenerated] = area( t0, t1, verts, a, degenerated);

  else
    
    % second degenerated case: one of intersection points coincides with
    % one of the vertices
    v_special = [];
    k_special = [];
    verts = [t0.verts_ec t1.verts_ec];

    for( i = 1 : numel( ipoints))
      for( k = 1 : size( verts,2))
        if( 1 == equalPoints( ipoints(i).vert, verts(:,k)))
          v_special = [v_special i];
          k_special = [k_special k];
        end
      end
    end
    condition( numel( v_special) == 1);
    
    % construct an additional vertex so that it is the six point case
    ipoint_new = ipoints(v_special);
    if( mod( k_special, 3) == 1)
      set_arcs = [1 3];
    else        
      set_arcs = [k_special, k_special-1];
      if( k_special > 3)
        set_arcs = set_arcs - 3;
      end
    end
  
    % only a0 is considered for pairing in six point case
    if( k_special <= 3)
      ipoint_new.a0 = setdiff( set_arcs, [ipoint_new.a0+1]) - 1;
    else
      ipoint_new.a1 = setdiff( set_arcs, [ipoint_new.a1+1]) - 1;
    end
      
    a = getOverlap6IPoints( t0, t1, inside_t0, inside_t1, [ipoints ipoint_new]);

  end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = getOverlap3IPoints( t0, t1, inside_t0, inside_t1, ipoints)
% One of the intersection points coincides with a vertex
  
  % one intersection point coincides with an vertex
  
  ipoints_r = [];
  
  verts = [t0.verts_ec t1.verts_ec];
  for( k = 1 : numel( ipoints))
    for( i = 1 : size( verts, 2))
      if( 1 == equalPoints( ipoints(k).vert, verts(:,i)))
        ipoints_r = ipoints([ 1:(k-1) , (k+1):end]);
        break;
      end    
    end
    
    if( numel( ipoints_r) > 0)
      break;
    end
  end
  
  if( numel( ipoints_r) > 0)
    
  end
  
  condition( numel( ipoints_r) > 0);
  
  a = getOverlap2IPoints( t0, t1, inside_t0, inside_t1, ipoints_r);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = getOverlap4IPoints( t0, t1, inside_t0, inside_t1, ipoints)

  a = 0;
  degenerated = 0;
  
  arcs = { [2 1], [3 2] [1 3]}; 
  
  in_t0 = find( inside_t0 ~= 0);
  in_t1 = find( inside_t1 ~= 0);  
  
  if( ( 1 == numel( in_t0)) && ( 1 == numel( in_t1)) )
  
     if( 1 == equalPoints( t0.verts_ec(:,in_t1), t1.verts_ec(:,in_t0) ))
      
      % expecting degenerated case
  
      % find the two point
      
      % remove the point which coincides with the duplicate vertex
      ipoints_r = [];
      for( i = 1 : 4)
        if( 1 == equalPoints( ipoints(i).vert, t1.verts_ec(:,in_t0)))
          ipoints_r = ipoints([1:(i-1) , (i+1):end]);
          break;
        end
      end
      condition( numel( ipoints_r) > 0);

      if( ipoints_r(1).a0 == ipoints_r(2).a0)
        arc0 = [1 2];
        if( ipoints_r(3).a1 == ipoints_r(1).a1)
          arc1 = [1 3];
        else
          arc1 = [2 3];
        end
      else
        arc0 = [1  3];
         if( ipoints_r(2).a1 == ipoints_r(1).a1)
          arc1 = [1  2];
        else
          arc1 = [2  3];
         end
      end
      
      verts(:,1) = ipoints_r(arc0(1)).vert;
      verts(:,2) = ipoints_r(arc0(2)).vert;
      verts(:,3) = t0.verts_ec(:,in_t1);
      [a, degenerated] = area( t0, t1, verts, a, degenerated);
      
      verts(:,1) = ipoints_r(arc1(1)).vert;
      verts(:,2) = ipoints_r(arc1(2)).vert;
      verts(:,3) = t0.verts_ec(:,in_t1);
      [a, degenerated] = area( t0, t1, verts, a, degenerated);
      
     else
      
       % there is one pair of intersection points which lies on the same
       % arc 
       for( i = 1 : 4)
         arc = [i];
         for( k = i+1 : 4)
           if( ipoints(arc(1)).a0 == ipoints(k).a0)
             arc = [arc k];
           end
         end
         
         % stop if the arc and the vertices have been found
         if( numel(arc) > 1)
           break;
         end
       end
       condition( numel(arc) == 2);  
       
       
       % first triangle, simple, 1 arc of t0 and two arcs of t1
       
       v_up = intersect( arcs{ ipoints(arc(1)).a1+1}, ...
                         arcs{ ipoints(arc(2)).a1+1});
       condition( 1 == numel( v_up));
       
       verts(:,1) = t1.verts_ec(:,v_up);
       verts(:,2) = ipoints( arc(1)).vert;
       verts(:,3) = ipoints( arc(2)).vert;       
       [a , degenerated] = area( t0, t1, verts, a, degenerated);
       
       % two other triangles
       verts_rest = setdiff( [1:4], arc);
       condition( ipoints(verts_rest(1)).a0 ~= ipoints(verts_rest(2)).a0);
       condition( ipoints(verts_rest(1)).a1 ~= ipoints(verts_rest(2)).a1);       
       
       % find additional points necessary to compute the area, one of each
       % triangle
       v_1 = intersect( arcs{ ipoints(verts_rest(1)).a1+1}, ...
                        arcs{ ipoints(verts_rest(2)).a1+1} );
       condition( 1 == numel( v_1));
       v_0 = intersect( arcs{ ipoints(verts_rest(1)).a0+1}, ...
                        arcs{ ipoints(verts_rest(2)).a0+1} );
       condition( 1 == numel( v_0));
        
       % second triangle
       verts(:,1) = ipoints(verts_rest(1)).vert;
       verts(:,2) = t1.verts_ec(:,v_1);
       verts(:,3) = t0.verts_ec(:,v_0);  
       [a , degenerated] = area( t0, t1, verts, a, degenerated);
       
       % third triangle (only change of one vertex necessary
       verts(:,1) = ipoints(verts_rest(2)).vert;       
       [a , degenerated] = area( t0, t1, verts, a, degenerated);
       
    end
      
  elseif(( 1 == numel( in_t0)) && ( 0 == numel( in_t1)))

    % compute the area of the triangles which are not covered by both domains
    
    % find the intersection points which lie on the same arc

    v1 = ipoints(1);
    for( i = 2 : numel( ipoints))
      if( ipoints(i).a0 == v1(1).a0)
        v1 = [v1 ipoints(i)];
      end
    end
    condition( numel(v1) == 2);


    v2 = [];
    if( v1(1).a0 == ipoints(2).a0)
      v2 = [ipoints(3) ipoints(4)];
    elseif( v1(1).a0 == ipoints(3).a0)
      v2 = [ipoints(2) ipoints(4)];
    else
     v2 = [ipoints(2) ipoints(3)];
    end

    index = intersect( arcs{v1(1).a1+1}, arcs{v1(2).a1+1});

    verts(:,1) = v1(1).vert;
    verts(:,2) = v1(2).vert;    
    verts(:,3) = t1.verts_ec(:,index);
    [a, degenerated] = area( t0, t1, verts, a, degenerated);

    index = intersect( arcs{v2(1).a1+1}, arcs{v2(2).a1+1});

    verts(:,1) = v2(1).vert;
    verts(:,2) = v2(2).vert;    
    verts(:,3) = t1.verts_ec(:,index);
    [a , degenerated] = area( t0, t1, verts, a, degenerated);

    % the sub-triangles which are not in the overlap have been computed
    a = t1.area - a;
%     plotEdges2D( t1, 1.01, [1 1 0]);
  
  elseif(( 1 == numel( in_t1))  && ( 0 == numel( in_t0)))

    v1 = ipoints(1);
    for( i = 2 : numel( ipoints))
      if( ipoints(i).a1 == v1(1).a1)
        v1 = [v1 ipoints(i)];
      end
    end
    condition( numel(v1) == 2);
   
    v2 = [];
    if( v1(1).a1 == ipoints(2).a1)
      v2 = [ipoints(3) ipoints(4)];
    elseif( v1(1).a1 == ipoints(3).a1)
      v2 = [ipoints(2) ipoints(4)];
    else
     v2 = [ipoints(2) ipoints(3)];
    end

    index = intersect( arcs{v1(1).a0+1}, arcs{v1(2).a0+1});

    verts(:,1) = v1(1).vert;
    verts(:,2) = v1(2).vert;    
    verts(:,3) = t0.verts_ec(:,index);
    [a, degenerated] = area( t0, t1, verts, a, degenerated);

    index = intersect( arcs{v2(1).a0+1}, arcs{v2(2).a0+1});

    verts(:,1) = v2(1).vert;
    verts(:,2) = v2(2).vert;    
    verts(:,3) = t0.verts_ec(:,index);
    [a , degenerated] = area( t0, t1, verts, a, degenerated);

    % the sub-triangles which are not in the overlap have been computed
    a = t0.area - a;
%     plotEdges2D( t0, 1.01, [1 1 0]);
  
  elseif(    (( 1 == numel( in_t1))  && ( 2 == numel( in_t0))) ...
          || (( 2 == numel( in_t1))  && ( 1 == numel( in_t0))) )
    
      v_0 = [];
      for( p = 1 : 3)
        for( q = 1 : 3)
          if( 1 == equalPoints( t1.verts_ec(:,q), ipoints(p).vert))
            v_0 = [v_0 p];
          end
        end
      end
      
      v_1 = [];
      for( p = 1 : 3)
        for( q = 1 : 3)
          if( 1 == equalPoints( t0.verts_ec(:,q), ipoints(p).vert))
            v_1 = [v_1 p];
          end
        end
      end

      
      v = union( v_0, v_1);
      condition( 2 == numel(v));    
      
      v_2 = setdiff( [1:4], v);      
      a = getOverlap2IPoints( t0, t1, inside_t0, inside_t1, ipoints(v_2));

  else 
    
    % find the intersection points which lie on the same arc of t0

    v1 = 1;
    for( i = 2 : numel( ipoints))
      if( ipoints(i).a0 == ipoints(v1(1)).a0)
        v1 = [v1 i];
      end
    end
    condition( numel(v1) == 2);

    v2 = [];
    if( ipoints(v1(1)).a0 == ipoints(2).a0)
      v2 = [3 4];
    elseif( ipoints(v1(1)).a0 == ipoints(3).a0)
      v2 = [2 4];
    else
     v2 = [2 3];
    end
    
    v3 = 1;
    for( i = 2 : numel( ipoints))
      if( ipoints(i).a1 == ipoints(v3(1)).a1)
        v3 = [v3 i];
      end
    end
    condition( numel(v3) == 2);
    
    
    verts(:,1) = ipoints( v1(1)).vert;
    verts(:,2) = ipoints( v1(2)).vert;    
    verts(:,3) = ipoints( v3(2)).vert;
    [a, degenerated] = area( t0, t1, verts, a, degenerated);

    v4 = setdiff( v1, v3);
    
    verts(:,1) = ipoints( v2(1)).vert;
    verts(:,2) = ipoints( v2(2)).vert;    
    verts(:,3) = ipoints( v4).vert;
    [a, degenerated] = area( t0, t1, verts, a, degenerated);
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = getOverlap2IPoints( t0, t1, inside_t0, inside_t1, ipoints)
  
  arcs = { [2 1], [3 2] [1 3]}; 
  
	degenerated = 0;
  
  a = 0;
    
  % two cases: both interesection points lie on one edge of one of the
  % triangles or the two intersection points are on two different edges
  if( (ipoints(1).a0 ~= ipoints(2).a0) && (ipoints(1).a1 ~= ipoints(2).a1) )
   
    % compose the triangle from two sub-triangles
    
    in_t0 = find( inside_t0 ~= 0);
    in_t1 = find( inside_t1 ~= 0);
    
    verts = [];
    verts = [verts  t1.verts_ec(:,in_t0)];
    verts = [verts  t0.verts_ec(:,in_t1)];    
    
    % skip degenerated cases
    
    verts(:,3) = ipoints(1).vert;
    [a, degenerated] = area( t0, t1, verts, a, degenerated);
    
    verts(:,3) = ipoints(2).vert;
    [a, degenerated] = area( t0, t1, verts, a, degenerated);
    
  else
    
    % set up new triangle and get area
    verts = [];
    
    verts(:,1) = ipoints(1).vert;
    verts(:,2) = ipoints(2).vert;
    
    % find the third vertex
    
    if( ipoints(1).a0 == ipoints(2).a0)      
      
      index = intersect( arcs{ ipoints(1).a1+1}, arcs{ipoints(2).a1+1} );
      condition( numel( index) == 1);
      verts(:,3) = t1.verts_ec(:,index);
      
      % check if the point lies in the other triangle
      if( 1 == checkPointInsideSTri( t0, verts(:,3)))
        
        % compute the area
        [a , degenerated] = area( t0, t1, verts, a, degenerated);      
        
      else
        
        % two points of the second triangle lie in the first one

        % index of the other two points
        ii = ones( 1,3);
        ii(index) = 0;
        ii = find( ii ~= 0);
        
        % find out which point lie on the same arc
        index_v1 = intersect( arcs{ipoints(1).a1+1}, ii);
        index_v2 = intersect( arcs{ipoints(2).a1+1}, ii);        
        
        verts(:,1) = ipoints(1).vert;
        verts(:,2) = t1.verts_ec(:,index_v1);
        verts(:,3) = t1.verts_ec(:,index_v2);
        [a, degenerated] = area( t0, t1, verts, a, degenerated);
        
        verts(:,1) = ipoints(2).vert;
        verts(:,2) = t1.verts_ec(:,index_v2);
        verts(:,3) = ipoints(1).vert;
        [a, degenerated] = area( t0, t1, verts, a, degenerated);
        
      end
      
    else

      index = intersect( arcs{ipoints(1).a0+1}, arcs{ipoints(2).a0+1} );
      condition( numel( index) == 1);
      verts(:,3) = t0.verts_ec(:,index);
      
      % check if the point lies in the other triangle
      if( 1 == checkPointInsideSTri( t1, verts(:,3)))
        
        % compute the area
        [a , degenerated] = area( t0, t1, verts, a, degenerated);
        
      else
        
        % two points of the second triangle lie in the first one
        
        % index of the other two points
        ii = ones( 1,3);
        ii(index) = 0;
        ii = find( ii ~= 0);       
        
        % find out which point lie on the same arc
        index_v1 = intersect( arcs{ipoints(1).a0+1}, ii);
        index_v2 = intersect( arcs{ipoints(2).a0+1}, ii);        
        
        verts(:,1) = ipoints(1).vert;
        verts(:,2) = t0.verts_ec(:,index_v1);
        verts(:,3) = t0.verts_ec(:,index_v2);
        [a, degenerated] = area( t0, t1, verts, a, degenerated);

        verts(:,1) = ipoints(2).vert;
        verts(:,2) = t0.verts_ec(:,index_v2);
        verts(:,3) = ipoints(1).vert;
        [a, degenerated] = area( t0, t1, verts, a, degenerated);

      end
      
    end    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a , degenerated] = area( t0, t1, verts, a, degenerated)

  verts = removeDuplicateVerts( verts);
  if( size( verts, 2) == 3)
    a = a + computeAreaSTri( verts);
    % visAreaOverlap;
  else
    degenerated = degenerated + 1;
  end  

end
