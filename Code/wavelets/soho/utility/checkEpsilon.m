function checkEpsilon( val, epsilon)
%
% checkEpsilon( val, epsilon)
%
% Check if abs( val) is less than epsilon. If this is not met, then an
% Matlab error is generated.
%
% @param  val  test value which absolute value is expected to be less than
%              epsilon
% @param  epsilon  epsilon to test against

  if( sum( abs( val)) > numel( val) * epsilon) 
    error( sprintf( 'Epsilon test failed: val = %e /  epsilon = %e', ...
                    val, epsilon ));
  end

end