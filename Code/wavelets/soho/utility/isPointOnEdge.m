function is_on = pointOnEdge( edge, point)
%
% is_on = pointOnEdge( edge, point)
%
% Check if the point \a point (which is assumed to be on the edge) is
% between the two endpoints of the edge
% 
% @return  1 is \a point lies on \a edge, otherwise 0 
% @param   edge  edge to test \a point against 
% @param   point  point to test if it lies on edge

  epsilon = 10^-14;

  is_on = 0;
  
  % edge vector
  ev = edge(:,2) - edge(:,1);

  % vector from the base point of the edge vector to the point under
  % consideration
  d = point - edge(:,1);

  % compute dot products, squarred lengths of projection onto ev (which is
  % just (norm( ev))^2 for dp2)
  dp = dot( d, ev);
  dp2 = dot( ev, ev);

  % remove numeric noise
  dp = double( single( dp));
  dp2 = double( single( dp2));  
  % avoid slightly negative values for dp
  if(( dp < 0) && (dp > -epsilon))
    dp = 0;
  end
      
  % case 1, point coincides with one of the endpoints of the edge
  if( dp == 0)
    is_on = 1;
  elseif( dp > 0)        
    is_on = ((dp2 - dp) > -epsilon);
  end
  % else dot product is less than 0, definitely not inside
      
end

