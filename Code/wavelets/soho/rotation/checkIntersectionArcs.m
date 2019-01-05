function ipoint = checkIntersectionArcs( a0, a1, index_a0, index_a1)
%
% ipoint = checkIntersectionArcs( a0, a1, index_a0, index_a1)
%
% Compute the intersection point of the two arcs formed by the given
% vertices and check if this point lies on both arcs
%
% @return  the intersection point of the arcs if it lies on both, 
%          otherwise []
% @param  a0  arc specified as the two points which span it
% @param  a1  arc specified as the two points which span it 

  % form the planes corresponding to the arcs

  a0_n = cross( a0(:,1), a0(:,2));
  a0_n = a0_n / norm( a0_n);

  a1_n = cross( a1(:,1), a1(:,2));
  a1_n = a1_n / norm( a1_n);
  
  % ignore it if the planes are coplanar
  epsilon = 10^-14;
  if( abs(abs( dot( a0_n, a1_n)) - 1) < epsilon)
    ipoint = [];
    return;
  end
  
  % compute the intersection point
  ipoint = intersectPlanes( a0_n, a1_n);
  
  % do not perform plane check
  pcheck = 0;
  
  % check if intersection pint lies on arcs
  if( ~(    ( 1 == checkPointOnArc( a0(:,1), a0(:,2), ipoint, pcheck)) ...
         && ( 1 == checkPointOnArc( a1(:,1), a1(:,2), ipoint, pcheck)) ))

    ipoint = -1.0 * ipoint;

    if( ~(  ( 1 == checkPointOnArc( a0(:,1), a0(:,2), ipoint, pcheck)) ...
         && ( 1 == checkPointOnArc( a1(:,1), a1(:,2), ipoint, pcheck)) ))

      ipoint = [];

    end
  end
    
end