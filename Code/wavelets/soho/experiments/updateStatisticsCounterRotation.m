function stat = updateStatisticsCounterRotation( stat, c_stat)
%
% stat = updateStatisticsCounterRotation( stat, c_stat)
%
% Update a (global) stat counter with values from the current iteration
% (append to list of all values in stat)
%
% @return  updated stats counter
% @param  stat  statistics counter
% @param  c_stat  current statistics
  
  stat.err_l1 = [stat.err_l1  c_stat.err_l1];
  stat.err_l2 = [stat.err_l2  c_stat.err_l2];
  stat.sparsity = [stat.sparsity  c_stat.sparsity];  
  
end