function data = oshDeNormalizeData( coeffs, tri)
% 
% data = oshDeNormalizeData( coeffs, tri)
%
% De-normalize scaling function coefficients to obtain data
% @return de-normalized data
% @param coeffs  scaling function coefficients to denormalize
% @param tri    triangle those childs are associated with the data

  childs = getChilds( tri);
  area_0 = getArea( childs(1));
  area_1 = (getArea(childs(2)) + getArea(childs(3)) + getArea(childs(4))) / 3;

  data = [];
  data(:,1) = coeffs(:,1) / sqrt(area_0);
  data(:,2:4) = coeffs(:,2:4) * ( 1.0 / sqrt(area_1));
  
end