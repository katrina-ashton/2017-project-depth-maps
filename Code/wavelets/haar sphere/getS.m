function S = getS(a0,a1,ap)
  a = (a0+sqrt(a0^2+3*a0*a1))/(3*a0); %Can be + or -
  
  %%%C&P from MATLAB implementaion of Lessig and Fiume (some variable name changes)%%%
  % cache values
  sqrt_areas = [sqrt(a0) , sqrt(a1), sqrt(ap)];

  % compute filter coefficients
  S = [];
  
  % scaling function
  S(1,1) = sqrt_areas(1) / sqrt_areas(3);
  S(1,2) = sqrt_areas(2) / sqrt_areas(3);
  S(1,3) = S(1,2);
  S(1,4) = S(1,2);

  % first wavevelet basis function
  S(2,1) = - (sqrt_areas(2) / sqrt_areas(1));
  S(2,2) = -2 * a + 1;
  S(2,3) = a;
  S(2,4) = a;
  
  % reuse cached the values 
  S(3,1) = S(2,1);
  S(3,2) = a;
  S(3,3) = S(2,2);
  S(3,4) = a;
  
  S(4,1) = S(2,1);
  S(4,2) = a;
  S(4,3) = a;
  S(4,4) = S(2,2);
  %%%
end