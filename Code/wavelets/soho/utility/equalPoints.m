function is_equal = equalPoints( p0, p1)
%
% is_equal = equalPoints( p0, p1)
%
% Check if two points are equal (up to a numerical error)
%
% @return  1 if the points are equal, otherwise 0
% @param p0  point
% @param p1  point
  
  epsilon = 10^-8;
  
  is_equal = 0;
  if(sum( abs( p0 - p1)) < epsilon)
    is_equal = 1;
  end
end