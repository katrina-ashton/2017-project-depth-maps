function on_arc = checkPointOnArc( v0, v1, vt, plane_check)
%
% on_arc = checkPointOnArc( v0, v1, vt)
%
% Test if \a vt lies on the arc spanned by v0 and v1
%
% @return  1 if \a vt lies on the arc, otherwise 0
% @param v0  first vertex forming the arc
% @param v1  second vertex forming the arc
% @param vt  vertex to test  
% @param plane_check  test if \a vt lies in the same plane as v0 and v1 
%                     (optional, default == 1)
% @note It is assumed that the inputs vectors are normalized, i.e. they
%        lie on the unit sphere.

  epsilon = 10^-14;

  on_arc = 0;
    
  pc = 1;
  if(nargin > 3)
    pc = plane_check;
  end
  plane_check = pc;
  
  if( plane_check > 0)
    % check if point is in the plane of the arc
    n = cross( v0, v1);
    n = n / norm( n);
    if( abs( dot( n, vt)) > epsilon)
      return;
    end
  end
    
  v0_dp0 = dot( v0, v1);
  v0_dp1 = dot( v0, vt);

  v1_dp0 = dot( v1, v0);
  v1_dp1 = dot( v1, vt);

  epsilon = 10^-14;
  if( ((v0_dp1 - v0_dp0) > -epsilon) && ((v1_dp1 - v1_dp0) > -epsilon) )
    on_arc = 1;
  end

end