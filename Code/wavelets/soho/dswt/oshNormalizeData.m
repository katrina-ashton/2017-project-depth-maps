function coeffs = oshNormalizeData( data, tri)
% 
% coeffs = oshNormalizeData( data, tri)
%
% Normalize input data (usually at the finest level) so that it can be used
% as scaling function coefficients
%
% @return normalized coefficients
% @param data   input data to normalize
% @param tri    triangle those childs are associated with the data

  childs = getChilds( tri);
  area_0 = getArea( childs(1));
  area_1 = (getArea(childs(2)) + getArea(childs(3)) + getArea(childs(4))) / 3;

  coeffs = [];
  coeffs(:,1) = data(:,1) * sqrt(area_0);
  coeffs(:,2:4) = data(:,2:4) * sqrt(area_1);
  
end