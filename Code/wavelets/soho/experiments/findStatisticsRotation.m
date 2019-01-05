function stat = findStatisticsRotation( err, btm)
%
% stat = computeStatistics( err, btm)
%
% Compute average L1 and L2 error, and sparsity for the rotation with the 
% basis transformation matrix \a btm
%
% @return  stat  struct containing average L1 and L2 error and sparsity
% @param  err  error for the rotated signal in the target basis
% @param  btm  basis transformation matrix
  
  % compute average errors
  
  err_l1 = 0;
  err_l2 = 0;  
  for( k = 1 : size( err,1))
    err_l1 = err_l1 + (norm( err(k,:), 1) / size( err,2));
    err_l2 = err_l2 + (norm( err(k,:), 2) / size( err,2));
  end
  err_l1 = err_l1 / size( err,1);
  err_l2 = err_l2 / size( err,1);  

  % sparsity
  
  sparsity = (nnz( btm) * 100) / numel(btm);
  
  % store result
  
  stat.err_l1 = err_l1;
  stat.err_l2 = err_l2; 
  stat.sparsity = sparsity;  
    
end
