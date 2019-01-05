function coeffs = pwhnNormalizeData( data, tri)
% 
% coeffs = pwhnNormalizeData( data, tri)
%
% Normalize input data (usually at the finest level) so that it can be used
% as scaling function coefficients
%
% @return normalized coefficients
% @param data   input data to normalize
% @param tri    triangle those childs are associated with the data

  childs = getChilds( tri);
  area = (   getArea( childs(1)) + getArea(childs(2)) ...
          + getArea(childs(3)) + getArea(childs(4)) ) / 4;

  coeffs = [];
  coeffs(:,1:4) = data(:,1:4) * sqrt(area);
  
end