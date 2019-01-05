function ipoint = intersectEdges( e0, e1, face)
%
%
%
%
%

  % compute intersection point of the lines
  ipoint = intersectLines( e0, e1, face);
  if( 0 == numel( ipoint))
    ipoint = [];
    return;
  end
  
  % check if intersection point lies between points on the lines
  if( ~(     (1 == isPointOnEdge( e0, ipoint)) ...
          && (1 == isPointOnEdge( e1, ipoint)) ))
    ipoint = [];    
  end

end