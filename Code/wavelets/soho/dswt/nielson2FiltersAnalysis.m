function ftabs = nielson2FiltersAnalysis( tri)
%
% ftabs = nielson2FiltersAnalysis( tri)
%
% Compute analysis filters for osh wavelets for domain specified by spherical 
% triangle
% @return filter tabs in analysis matrix (4x4 matrix)
% @param  tri  domain for which the filter coefficients have to be computed

  childs = getChilds( tri);
  alpha_o = getArea( childs(1));
  alpha_i = getArea( childs(2));
  alpha_j = getArea( childs(3));
  alpha_k = getArea( childs(4));  
 
  delta = alpha_o^2 + alpha_i^2 + alpha_j^2 + alpha_k^2;
  
  ftabs = ones( 4, 4);
  
  ftabs(2,1) = 1 - (alpha_o^2 - 3 * alpha_i * alpha_o) / delta;
  ftabs(3,1) = 1 - (alpha_o^2 - 3 * alpha_j * alpha_o) / delta;
  ftabs(4,1) = 1 - (alpha_o^2 - 3 * alpha_k * alpha_o) / delta;  
  
  ftabs(2,2) = -3 + (3 * alpha_i^2 - alpha_i * alpha_o) / delta;
  ftabs(3,2) = (-alpha_o * alpha_i + 3 * alpha_j * alpha_i) / delta;
  ftabs(4,2) = (-alpha_o * alpha_i + 3 * alpha_k * alpha_i) / delta;  

  ftabs(2,3) = (-alpha_o * alpha_j + 3 * alpha_i * alpha_j) / delta;
  ftabs(3,3) = -3 + (3 * alpha_j^2 - alpha_j * alpha_o) / delta;
  ftabs(4,3) = (-alpha_o * alpha_j + 3 * alpha_k * alpha_j) / delta;  
  
  ftabs(2,4) = (-alpha_o * alpha_k + 3 * alpha_i * alpha_k) / delta;
  ftabs(3,4) = (-alpha_o * alpha_k + 3 * alpha_j * alpha_k) / delta;  
  ftabs(4,4) = -3 + (3 * alpha_k^2 - alpha_k * alpha_o) / delta;
  
  % normalize filter coefficients (first row is normalized)

  ftabs(1,:) = ftabs(1,:) / norm( ftabs(1,:));
  ftabs(2,:) = ftabs(2,:) / norm( ftabs(2,:));
  ftabs(3,:) = ftabs(3,:) / norm( ftabs(3,:));  
  ftabs(4,:) = ftabs(4,:) / norm( ftabs(4,:));  
  
end
