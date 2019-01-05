function data = pwhnDeNormalizeData( coeffs, tri)
% 
% data = pwhnDeNormalizeData( coeffs, tri)
%
% De-normalize scaling function coefficients to obtain data
%
% @return de-normalized data
% @param coeffs  scaling function coefficients to denormalize
% @param tri    triangle those childs are associated with the data

  childs = getChilds( tri);
  area = (  getArea( childs(1)) + getArea(childs(2)) ...
          + getArea(childs(3)) + getArea(childs(4))) / 4;

  data = [];
  data(:,1:4) = coeffs(:,1:4) * ( 1.0 / sqrt(area));
  
end