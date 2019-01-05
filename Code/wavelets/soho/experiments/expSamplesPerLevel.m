function  samples = expSamplesPerLevel( level)
%
%  samples = expSamplesPerLevel( level)
%
% Get number of samples necessary on a level
  
  slist = [1000000, 100000, 5000, 1000, 500, 100, 50]; 

  samples = slist( level);
  
end