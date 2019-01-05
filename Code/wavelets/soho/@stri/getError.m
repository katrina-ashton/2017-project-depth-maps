function [err_l1, err_l2, diff] = getError( stris_approx, stris_ref, level)
%
% [err_l1, err_l2, diff] = getError( stris_approx, stris_ref, level)
%
% Compute L1 and L2 error norm (the domains are weighted according to its area)
%
% @return  err_l1  L1 error
% @return  err_l2  L2 error
% @return  diff  absolute difference value for each domain at level \a
%                level weighted by the area
% @param  stris_approx  root nodes of the forest of wavelet tree which
%                       contains the approximated signal
% @param  stris_ref     root nodes of the forest of wavelet tree which
%                       contains the reference solution
% @param  level         level on which the data is defined
% @note the wavelet tree have to have the same structure

  condition( numel( stris_approx) == numel( stris_ref));

  sig_approx = [];
  sig_ref = [];
  areas = [];
  
  % do for all trees
  for( i = 1 : numel( stris_approx))
    
    sig_approx = [sig_approx  getSignal( stris_approx( i), level)];
    sig_ref = [sig_ref  getSignal( stris_ref( i), level)];
    
  end
  
  % difference signal 
  diff = abs( sig_approx - sig_ref);
    
  % compute error norms
  err_l1 = [];
  err_l2 = [];  
  
  for( i = 1 : size( sig_approx, 1))
    err_l1(i,:) = norm( diff(i,:), 1) / size( diff, 2);
    err_l2(i,:) = norm( diff(i,:), 2) / size( diff, 2);
  end
  
end
