function pos = intersectPlanes( n1, n2)
%
% pos = intersectPlanes( n1, n2)
%
% Compute the intersection point of two planes on the unit sphere. Both planes
% have the origin as one of their points
% 
% @return  position of the intersection of the two planes on the unit
%          sphere
% @param  n1  plane in normal form (Hessian form)
% @param  n2  plane in normal form (Hessian form)
% @note The problem is an ill-conditioned linear system with infinite many
% solutions. The constraint that the intersection point has to lie on the
% unit sphere permits to find a unique solution.

  epsilon = 10^-14;

  % clamp very small values to 0
  n1( find( abs(n1) < epsilon)) = 0;
  n2( find( abs(n2) < epsilon)) = 0;
  
  nz_n1 = nnz( n1);
  nz_n2 = nnz( n2);

  % non-degenerated
  if( (3 == nz_n1) && (3 == nz_n2) )

    t1 = (n1 .* (-n2(1) / n1(1))) + n2;

    if( t1(3) == 0)

      % x and z are identical
      
      y = 0;
      x = -n1(3) / n1(1);
      z = 1;
      
    else
    
      z = -t1(2) / t1(3);
      y = 1;
      x = (-n1(2) * y - n1(3) * z) / n1(1);
    
    end
    
    pos = [x y z];

  elseif( (1 == nz_n1) || (1 == nz_n2))
    
    if( (1 == nz_n1) && (1 == nz_n2))

      t = n1 + n2;
      i = find( t == 0);
      condition( numel(i) == 1);
      
      pos = zeros(1,3);
      pos(i) = 1;
      
    elseif((3 == nz_n1) || (3 == nz_n2))

      t = n1 .* n2;
      i = find( t ~= 0);

      ii = zeros(1,3);
      ii(i) = 1;
      nz = find( (xor( [1 1 1], ii)) ~= 0);

      pos = ones(1,3);
      pos(i) = 0;

      n_full = n1;
      if( nnz(n_full) < 3)
        n_full = n2;
      end
      pos(nz(2)) = (-n_full(nz(1))) ./ n_full(nz(2));

    else % one vector has 2 non-zero elements
      
      t = n1 .* n2;

      if( 0 == nnz( t))
      
        n_2 = n1;
        n_1 = n2;
        if( nnz(n_2) < 2)
          n_2 = n2;
          n_1 = n1;
        end

        ii = find( n_2 ~= 0);

        pos = zeros( 1, 3);
        pos( ii(1)) = 1;      
        pos( ii(2)) = -n_2(ii(1)) / n_2(ii(2));

      else
        
        i1 = find( n1 == 0);
        i2 = find( n2 == 0);
        i = intersect( i1, i2);
        condition( numel( i) == 1);
        pos = zeros(1,3);
        pos(i) = 1;
        
      end
    end
      
  elseif( (2 == nz_n1) || (2 == nz_n2))
    
    if( (3 == nz_n1) || (3 == nz_n2))

      t = n1 .* n2;
      i = find( 0 == t);

      ii = zeros( 1,3);
      ii(i) = 1;
      nz = xor( [1 1 1], ii);
      nz = find( nz ~= 0);

      t1 = (n1 .* (-n2(nz(1)) / n1(nz(1)))) + n2;

      if( t1(nz(2)) == 0)
      
        pos = zeros(1,3);

        not_full = n1;
        if( nnz( not_full) == 3)
          not_full = n2;
        end
        
        pos(nz(1)) = -not_full(nz(2)) / not_full(nz(1));
        pos(nz(2)) = 1;
        
      else
      
        pos = ones(1,3);
        pos(nz(2)) = -t1(i) / t1(nz(2));

        not_full = n1;
        if( nnz( not_full) == 3)
          not_full = n2;
        end

        pos(nz(1)) = (-not_full(nz(2)) * pos(nz(2)) ) / not_full(nz(1));

      end
      
    else
      
      error( 'Unknown configuration.');
      
    end
    
  else
    error( 'Unknown configuration.');
  end

  pos = pos' / norm( pos);
  
  % check solution: both plane equations have to be satisfied
  epsilon = 10^-10;
  checkEpsilon( dot( pos, n1), epsilon);  
  checkEpsilon( dot( pos, n2), epsilon);  
  
end
