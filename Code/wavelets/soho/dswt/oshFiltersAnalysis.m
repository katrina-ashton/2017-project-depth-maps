function ftabs = oshFiltersAnalysis( tri)
%
% ftabs = oshFiltersAnalysis( tri)
%
% Compute analysis filters for osh wavelets for domain specified by spherical 
% triangle
% @return filter tabs in analysis matrix (4x4 matrix)
% @param  tri  domain for which the filter coefficients have to be computed

  childs = getChilds( tri);
  area_0 = getArea( childs(1));
  area_1 = (getArea(childs(2)) + getArea(childs(3)) + getArea(childs(4))) / 3;
  area_p = getArea( tri);
  
  % compute wavelet basis parameter a
 	a = computeParamA( area_0, area_1);

  % cache values
  sqrt_areas = [sqrt( area_0) , sqrt( area_1), sqrt( area_p)];

  % compute filter coefficients
  ftabs = [];
  
  % scaling function
  ftabs(1,1) = sqrt_areas(1) / sqrt_areas(3);
  ftabs(1,2) = sqrt_areas(2) / sqrt_areas(3);
  ftabs(1,3) = ftabs(1,2);
  ftabs(1,4) = ftabs(1,2);

  % first wavevelet basis function
  ftabs(2,1) = - (sqrt_areas(2) / sqrt_areas(1));
  ftabs(2,2) = -2 * a + 1;
  ftabs(2,3) = a;
  ftabs(2,4) = a;
  
  % reuse cached the values 
  ftabs(3,1) = ftabs(2,1);
  ftabs(3,2) = a;
  ftabs(3,3) = ftabs(2,2);
  ftabs(3,4) = a;
  
  ftabs(4,1) = ftabs(2,1);
  ftabs(4,2) = a;
  ftabs(4,3) = a;
  ftabs(4,4) = ftabs(2,2);
  
  % normalize wavelet basis functions
  % (analytic solution leads to higher error accumulation => numerically
  % normalize basis functions)
  ftabs(1,:) = ftabs(1,:) / norm( ftabs(1,:));
  ftabs(2,:) = ftabs(2,:) / norm( ftabs(2,:));
  ftabs(3,:) = ftabs(3,:) / norm( ftabs(3,:));
  ftabs(4,:) = ftabs(4,:) / norm( ftabs(4,:)); 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = computeParamA( area_0, area_1)
% Compute parameter a of the filter tabs

  % two possible branches for a, global flag 'osh_sign_a' can be used to
  % change which branch is used

  set_locally = 0;

  global osh_sign_a;
  if( 0 == numel( osh_sign_a))
    osh_sign_a = 0;
    set_locally = 1;
  end

  temp_sqrt = sqrt( (area_0 * area_0) + 3 * area_0 * area_1);
  
  if( 0 == osh_sign_a)
    a = ((area_0 - temp_sqrt) / (3 *  area_0));
  else
    a = ((area_0 + temp_sqrt) / (3 *  area_0));
  end
  
  if( 1 == set_locally)
    clear global osh_sign_a;
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function n = computeNormWavelets( a)
% Compute normalization coefficient of the wavelet basis functions

  n = 1 / sqrt( 9 * a * a - 6 * a + 1);
  
end
