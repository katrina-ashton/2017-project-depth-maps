function [res_vis , res_inv_vis] = expVisibilityInverse( level)
%
% [res_vis , res_inv_vis] = expVisibilityInverse( level)
%
% Evaluate performance difference if visibility signal or it's inverse is
% used.
%
% @result  res_vis  L1 and L2 error rates for the different numbers of
%                   coefficients retained for the visibility signal
% @result  res_vis  L1 and L2 error rates for the different numbers of
%                   coefficients retained for the inverse visibility signal
% @param  level  on which the data is defined

  % get the number of coefficients to retain
  coeffs_retained = getCoeffsRetained( level);

  % create the forest over which the data is defined
  forest = createForestOctahedron( level);
  
  % load visibility signal
  signal = imread( 'experiments/signals/visibility.jpg');

  % generate inverse signal
  % convert to binary data
  temp = signal ./ 255;
  signal_inv = ~temp;
  signal_inv = signal_inv * 255;

  % results
  res_vis = [];
  res_inv_vis = [];
  
  % run test for visibility signal
  res_vis = testTexMapCompression( forest, 'osh', signal, level, ...
                                   coeffs_retained);

  % run test for inverse visibility signal
  res_inv_vis = testTexMapCompression( forest, 'osh', signal_inv, level, ...
                                       coeffs_retained);
                                 
end