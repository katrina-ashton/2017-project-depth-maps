function ftabs = bonneau2FiltersSynthesis( tri)
%
% ftabs = bonneau2FiltersSynthesis( tri)
%
% Compute synthesis filters for nearly orthogonal wavelets proposed by Bonneau
% for the domain specified by spherical triangle
% @return filter tabs in synthesis matrix (4x4 matrix)
% @param  tri  domain for which the filter coefficients have to be computed

  a = 1.0;
  % octahedron
  b = -0.061;
  % icosahedron
  % b = -0.067;

  % pseudo coefficient over which the filters are parametrizeds
  c = -(a + 5 * b) / 3;
  
  % get areas of child triangles
  childs = getChilds( tri);
  alpha_0 = getArea( childs(1));
  alpha_1 = getArea( childs(2));
  alpha_2 = getArea( childs(3));
  alpha_3 = getArea( childs(4));  
  
  
  ftabs = ones( 4, 4);
  
  ftabs(1,2) = a * alpha_1 + b * alpha_2 + b * alpha_3;
  ftabs(1,3) = b * alpha_1 + a * alpha_2 + b * alpha_3;
  ftabs(1,4) = b * alpha_1 + b * alpha_2 + a * alpha_3;
  
  ftabs(2,2) = -a * alpha_0 + c * (alpha_2 + alpha_3);
  ftabs(2,3) = -b * alpha_0 - c * alpha_2;
  ftabs(2,4) = -b * alpha_0 - c * alpha_3;

  ftabs(3,2) = -b * alpha_0 - c * alpha_1;
  ftabs(3,3) = -a * alpha_0 + c * (alpha_1 + alpha_3);
  ftabs(3,4) = -b * alpha_0 - c * alpha_3;
  
  ftabs(4,2) = -b * alpha_0 - c * alpha_1;
  ftabs(4,3) = -b * alpha_0 - c * alpha_2;
  ftabs(4,4) = -a * alpha_0 + c * (alpha_1 + alpha_2);
  
  % normalize matrix (first column is guaranteed to be normalized)
 
  ftabs(:,1) = ftabs(:,1) / norm( ftabs(:,1));
  ftabs(:,2) = ftabs(:,2) / norm( ftabs(:,2));
  ftabs(:,3) = ftabs(:,3) / norm( ftabs(:,3));
  ftabs(:,4) = ftabs(:,4) / norm( ftabs(:,4));
  
end