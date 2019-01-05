function p = shLegendre( l, m, x)
%
% function p = shLegendre( l, m, x)
%
% Evaluate the (l,m)-th Legendre polynomial at x

  p = 0.0;

  pmm = 1.0;
  if(m>0) 
    
    somx2 = sqrt((1.0-x)*(1.0+x));
    fact = 1.0;
  
    for( i = 1 : m)
      pmm = pmm * ((-fact) * somx2);
      fact = fact + 2.0;
    end
  end

  if(l==m) 
    p = pmm;
    return;
  end
    
  pmmp1 = x * (2.0*m+1.0) * pmm;
  
  if(l==m+1) 
    p = pmmp1;
    return;
  end
  
	pll = 0.0;
  
  for( ll=m+2 : l)
    pll = ( (2.0*ll-1.0)*x*pmmp1-(ll+m-1.0)*pmm ) / (ll-m);
    pmm = pmmp1;   
    pmmp1 = pll;
  end

  p = pll;
  
end
