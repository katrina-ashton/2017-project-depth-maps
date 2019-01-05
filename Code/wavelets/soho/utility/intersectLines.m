function ipoint = intersectLines( e0, e1, face);
%
%
%
% Compute the intersection point of the two lines spanned by the vertices
% of e0 and e1, respectively

  epsilon = 10^-14;

  dim_params = getDimParamCubemapFace( face);

  % map problem to 2D
  e0 = e0(dim_params,:);
  e1 = e1(dim_params,:);  
  
  % difference vectors
  d0 = e0(:,2) - e0(:,1);
  d1 = e1(:,2) - e1(:,1);
  % remove numerical noise
  d0( find( abs( d0) < epsilon)) = 0.0;
  d1( find( abs( d1) < epsilon)) = 0.0;

  if( ( 2 == nnz( d0)) && ( 2 == nnz( d1)) )
    
    [m0, n0] = findLineEquation2D( e0(:,1) , e0(:,2) );
    [m1, n1] = findLineEquation2D( e1(:,1) , e1(:,2) );    
    
    % check if lines are parallel
    if( abs( m1 - m0) > epsilon)
    
      x = (n0 - n1) / (m1 - m0);
      y = m1 * x + n1; 

      % the intersection point has to satisfy both line equations
      epsilon = 10^-8;
      checkEpsilon( y - (m0 * x + n0), epsilon);
      checkEpsilon( y - (m1 * x + n1), epsilon);    

      ipoint = [x y];

    else
      
      ipoint = [];
      
    end
      
  elseif( (1 == nnz( d0)) && (1 == nnz(d1)))
    
    z0 = find( d0 == 0);
    z1 = find( d1 == 0);
    
    % lines are parallel
    if( z0 == z1)
      ipoint = [];
    else
      ipoint(z0) = e0(z0,1);
      ipoint(z1) = e1(z1,1);    
    end
      
  elseif( (1 == nnz( d0)) && (2 == nnz(d1)))
    
    [m, n] = findLineEquation2D( e1(:,1) , e1(:,2) );
    z = find( d0 == 0);
    
    if( 1 == z)
      x = e0(z,1);
      y = m * x + n;
    else
      y = e0(z,1);
      x = (y - n) / m;
    end
    
    ipoint = [x y];
    
  elseif( (2 == nnz( d0)) && (1 == nnz(d1)))
    
    [m, n] = findLineEquation2D( e0(:,1) , e0(:,2) );
    z = find( d1 == 0);
    
    if( 1 == z)
      x = e1(z,1);
      y = m * x + n;;
    else
      y = e1(z,1);
      x = (y - n) / m;
    end
    
    ipoint = [x y];
    
  else
    
    error('Lines are co-linear.');
    
  end
  
  
  if( numel( ipoint) ~= 0)

    temp( dim_params) = ipoint;
    temp( getDimFixedCubemapFace( face)) = getFixedValueCubemapFace( face);
  
    ipoint = temp';
  end
  
end
