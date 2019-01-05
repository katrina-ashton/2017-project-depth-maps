function condtion( cond)
%  
% condtion( cond)
%
% Assert-like helper function to check if conditions are satisfied
% @param  cond  boolean condition, if false then the function fails
  
  if( ~ all( cond))
    error( 'Condition failed');
  end
  
end