function res = expFindOptimalBasis( platonic_solid, signal, level, sign_a)
%
% res = expFindOptimalBasis( platonic_solid, signal, level, sign_a)
%
% Find the optimal wavelet basis from the family of SOHO wavelets.
%
% @result  res  [size( c_values) , size( coeffs_retained) , 2] L1 and L2 error
%               rates for each value of c, and the different number of
%               retained coefficients
% @param  platonic_solid   {'octahedron', 'tetrahedron', 'icosahedron'}
%                          platonic solid from which the partition is
%                          derived over which the basis is constructed
% @param  signal  file name + path of the signal to use for the experiments
%                 or matrix containing the signal as spherical map
% @param  level  on which the data is defined
% @param  sign_a  {0,1} determines which branch of the solution for a is used,
%                 default is 0 which corresponds to the negative branch

  sa = 0;
  if( nargin > 3)
    sa = sign_a;
  end
  sign_a = sa;

  % set which branch for a is used
  global osh_sign_a;
  osh_sign_a = sign_a;
  
  % set of list of values for c
  c_values = [1];

  % get the number of coefficients to retain
  coeffs_retained = getCoeffsRetained( level);

  % create the forest over which the data is defined
  area_constraint = 1;
  forest = getForestPlatonicSolid( platonic_solid, level, area_constraint);
  
  % load visibility signal if not directly provided
  if( 1 == isstr( signal))
    signal = imread( signal);
  end

  % results
  res = zeros( numel(c_values), numel(coeffs_retained), 2);

  % run test for visibility signal
  for( i = 1 : numel( c_values))

    global osh_c;
    osh_c = c_values(i);

    temp = expBatchTestCompression( forest, 'osh', signal, level, ...
                                    coeffs_retained);
                                    
    res(i,:,:) = temp;
    
  end
         
  % cleanup
  clear global osh_sign_a;
  clear global osh_c;
  
end