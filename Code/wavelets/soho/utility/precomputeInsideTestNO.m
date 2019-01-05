function msh = precomputeInsideTestNO( msh)
%
% stris = precomputeInsideTest( stris)
%
% Precompute values for inside test

  epsilon = 10^-14;

  n1 = crosses( msh.stris_v2, msh.stris_v1); 
  msh.n1 = n1 ./ repmat( norms( n1), 3, 1);
  n2 = crosses( msh.stris_v3, msh.stris_v2); 
  msh.n2 = n2 ./ repmat( norms( n2), 3, 1); 
  n3 = crosses( msh.stris_v1, msh.stris_v3); 
  msh.n3 = n3 ./ repmat( norms( n3), 3, 1);  
  
  % construct plane in which all three points lie, p has to be on the same
  % side relative to the origin than these points
  l1 = msh.stris_v2 - msh.stris_v1;
  l2 = msh.stris_v3 - msh.stris_v1;  
  n = crosses( l1, l2);
  msh.N = n ./ repmat( norms( n), 3, 1);
  msh.s_v1 = sign( dots( msh.N, msh.stris_v1 + epsilon));
  
end
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function cs = crosses( as, bs)
%
% cs = cross_products( as, bs)
%
% Compute multiple cross products vectorize

  cs = [as(2,:).*bs(3,:)-as(3,:).*bs(2,:)
        as(3,:).*bs(1,:)-as(1,:).*bs(3,:)
        as(1,:).*bs(2,:)-as(2,:).*bs(1,:)];
      
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function ns = norms( vec)
%
% ns = norms( vec)
%
% Compute norms of vectors
  
  vec2 = vec.^2;
  vec2s = sum( vec2, 1);
  ns = sqrt( vec2s);

end