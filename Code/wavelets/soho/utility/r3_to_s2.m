function s2 = r3_to_s2( r3)
%
% s2 = r3_to_s2( r3)
%
% Convert from euclidean coordinates in R^3 to spherical coordinates in S^2
%
% @return  s2 = [theta; phi]  coordintaes on S^2, theta is the colatidue;
%                             i.e. the angle between the positive Z axis
%                             and the point [0,pi]; phi is the longitude [0,2pi]
% @param   r3  coordinates in R^3 

  r3 = r3 / norm( r3);

  s2 = [];
  s2(1) = acos( r3( 3));
  
  % \phi is undefined is r3 is a pole
  if(( 0 == s2(1)) || (pi == s2(1)))
    s2(2) = 0;
  else 
    
    % atan has to be wrapped to provide phi \in [0,2 \pi]
    if( 0 == r3(1))
    
      % avoid divison by 0
      if( r3(2) > 0)
        s2(2) = pi / 2;
      else
        s2(2) = 3/2 * pi;
      end
    
    elseif( 0 == r3(2))
      
      if( r3(1) > 0)
        s2(2) = 0;
      else
        s2(2) = pi;
      end
      
    else
      
      % we have to take the quadrant into account to obtain the correct
      % angle (the code might be somewhat optimizable but we use a save 
      % implementation at the moment
      if( (r3(1) > 0) && (r3(2) > 0))
        % first quadrant
        s2(2) = atan( r3(2) / r3(1));
      elseif( (r3(1) < 0) && (r3(2) > 0))
        % second quadrant
        s2(2) = pi - atan( r3(2) / abs(r3(1)));
      elseif( (r3(1) < 0) && (r3(2) < 0))
        % third quadrant
        s2(2) = pi + atan( abs(r3(2)) / abs(r3(1)));
      elseif( (r3(1) > 0) && (r3(2) < 0))
        % fourth quadrant
        s2(2) = 2 * pi - atan( abs(r3(2)) / r3(1));
      else 
        assert(0);
      end
    
    end
  end % end r3 is at pole
  
  assert( (s2(1) >= 0) && (s2(1) <= pi));
  assert( (s2(2) >= 0) && (s2(2) <= (2*pi)));  

  s2 = s2';
  
end