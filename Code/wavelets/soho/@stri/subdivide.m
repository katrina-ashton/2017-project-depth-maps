function st = subdivide( st, enforce_area_constraint)
%
% st = subdivide( st)
%
% Generate spherical triangles at next finer subdivision level
% @return  st  subdivided spherical triangle
% @param  st  spherical triangle to subdivide
% @param  enforce_area_constraint  {0,1} if 1, the subdivision enforces that 
%                                  the area of the three outer child triangles 
%                                  (index 2, 3, 4) is equal

  v_new = zeros(3,3);
    
  % new vertex with index 1 is opposite to old vertex with index 1
  v_new(:,1) = st.verts_ec(:,2) + st.verts_ec(:,3);
  v_new(:,1) = v_new(:,1) / norm( v_new(:,1));
  
  v_new(:,2) = st.verts_ec(:,3) + st.verts_ec(:,1);
  v_new(:,2) = v_new(:,2) / norm( v_new(:,2));
  
  v_new(:,3) = st.verts_ec(:,1) + st.verts_ec(:,2);
  v_new(:,3) = v_new(:,3) / norm( v_new(:,3));

  % generate new triangles 
  
  % first triangle is the sub-domain in the center formed by the three new
  % verts
  childs(1) = stri(v_new, st, 0);
  
  % subsequent triangles are formed by cw traversing the domain beginning
  % in the lower right corner  
  childs(2) = stri( [v_new(:,2) st.verts_ec(:,1) v_new(:,3)], st, 1);
  childs(3) = stri( [v_new(:,3) st.verts_ec(:,2) v_new(:,1)], st, 2);
  childs(4) = stri( [v_new(:,1) st.verts_ec(:,3) v_new(:,2)], st, 3);
  
  % enforce area constraint on three of the childs if requested
  if( enforce_area_constraint > 0)

    % perform area correction of childs(4) so that the wavelets are orthogonal
    % do the expensive computations only if necessary 
    if(    (abs(childs( 2).area - childs( 4).area) > 10E-12) ...
        || (abs(childs( 2).area - childs( 3).area) > 10E-12))

      % backup for debug purposes   
  %     childs_old = childs;

      % get the corrected vertex
      [v_new(:,2), v_new(:,3)] = getVertexEqualArea( st, childs, v_new);  

      % recompute the childs which change
      childs(1) = stri(v_new, st, 0);  
      childs(2) = stri( [v_new(:,2) st.verts_ec(:,1) v_new(:,3)], st, 1);
      childs(3) = stri( [v_new(:,3) st.verts_ec(:,2) v_new(:,1)], st, 2);
      childs(4) = stri( [v_new(:,1) st.verts_ec(:,3) v_new(:,2)], st, 3);

    end
    
  end

  % compute average shape distortion

%   global sum_shape_distortion;
%   global num_triangles;
%   global sum_variance;
%   global min_angle;
% 
%   num_triangles = num_triangles + 4;
%   
%   % do for all child triangles
%   for( i = 1 : numel( childs))
% 
%     % compute the arc lengths
%     al(1) = acos( dot( childs(i).verts_ec(:,1), childs(i).verts_ec(:,2)));
%     al(2) = acos( dot( childs(i).verts_ec(:,2), childs(i).verts_ec(:,3)));
%     al(3) = acos( dot( childs(i).verts_ec(:,3), childs(i).verts_ec(:,1))); 
%     
%     % variance
%     sum_variance = sum_variance + var( al);
%     
%     % employ a L2 error metric, the first side is employed as reference
%     al = al - al(1);  
%     sum_shape_distortion = sum_shape_distortion + norm( al);
% 
%     min_angle = min( min_angle, getMinAngleSTri( childs(i).verts_ec));
%     
%   end

  
%   % some validation    
%   global  max_error;
%   err = max( [abs( childs(2).area - childs(3).area), ...
%               abs( childs(2).area - childs(4).area), ...
%               abs( childs(3).area - childs(4).area)] );
%   if( max_error < err)
%     max_error = err;
%   end
  
  st.childs = childs;
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function min_alpha = getMinAngleSTri( verts_ec)
% 
% min_alpha = getMinAngleSTri( verts_ec)
% 
% Compute the minimal inner angle of the spherical triangle (measure for
% shape distortion
%
% @return  min_alpha  minimum angle
% @param  verts_ec  vertices in euclidean coordinates
  
    % compute the cosine of the angular length of the sides of the spherical 
  % triangle
  % the sides are defined in the standard way, i.e. e1 with |e1| = l1 is 
  % opposite to v1 = a and therefore spanned by v2 = b and v3 = c
  % formula: http://mathworld.wolfram.com/SphericalDistance.html
  cos_a = dot( verts_ec(:,2), verts_ec(:,3));
  cos_b = dot( verts_ec(:,3), verts_ec(:,1));  
  cos_c = dot( verts_ec(:,1), verts_ec(:,2));  
  % cache some more values
  sin_a = sin( acos( cos_a));
  sin_b = sin( acos( cos_b));
  sin_c = sin( acos( cos_c));  
  
  % compute the diphedral angles of the spherical triangle (angle between
  % the planes of the great arcs)
  alpha_a = acos( (cos_a - cos_b * cos_c) / (sin_b * sin_c));
  alpha_b = acos( (cos_b - cos_c * cos_a) / (sin_c * sin_a));
  alpha_c = acos( (cos_c - cos_a * cos_b) / (sin_a * sin_b));  

  min_alpha = min( [alpha_a, alpha_b, alpha_c]);
  
end