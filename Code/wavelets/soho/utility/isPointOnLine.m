function is_on = isPointOnLine( line, point, face)
%
% is_on = isPointOnLine( line, point, face)
%
% Test if \a point lies on the line spanned by the two vertices in \a line
% 
% @return  1 if \a point lies on \a line, otherwise 0
% @param  line  vertices which span the line
% @param  point   point to test if it lies on \a line
% @param  face    face of the hemicube on which line and point lie

  epsilon = 10^-14;

  % remove numerical noise
  line( find( abs( line) < epsilon)) = 0;

  is_on = 0;
  
  % difference vector, 2D problem
  dim_params = getDimParamCubemapFace( face);    
  diff = line(dim_params,2) - line(dim_params,1);
  diff( find( abs( diff) < epsilon)) = 0;
  
  % non-degenerated case
  if( 2 == nnz( diff))
    
    % get line equation
    [m , n] = findLineEquation2D( line(dim_params,1), line(dim_params,2));
    
    % compute y value for x of point
    y = m * point( dim_params(1)) + n;
    
    % line equation has generate point.y if point is on line
    if( abs( y - point( dim_params(2))) < epsilon)
      is_on = 1;
    end
    
  elseif( 0 == diff(1))  % horizontal line

    if( abs( line(dim_params(1),1) - point(dim_params(1))) < epsilon)
      is_on = 1;
    end

  elseif( 0 == diff(2))  % vertical line

    if( abs( line(dim_params(2),1) - point(dim_params(2))) < epsilon)
      is_on = 1;
    end
    
  else
    
    error( 'Unknown configuration.');
    
  end


end
