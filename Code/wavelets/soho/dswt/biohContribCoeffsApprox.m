function contrib_coeffs = biohContribCoeffsApprox( tri)
%
% contrib_coeffs = biohContribCoeffsApprox( tri, fhs)
%
% Compute the contribution of each wavelet basis function / wavelet basis 
% function basis coefficient associated with tri
% 
% @return [3,1]  contribution of the three wavelet basis functions
% @param  tri  spherical triangle over which the wavelet basis functions
%              are defined
  
  % get child triangles
  childs = getChilds( tri);
  
  % get filter coefficients
  filters = biohFiltersSynthesis( tri);
      
  % get the wavelet basis function basis coefficients associated with tri
  % for all data channels
  w_coeffs = getWaveletCoeffs( tri);

  % get areas of child triangles
  for( i = 1 : 4)
    areas_childs(i) = getArea( childs(i));
  end

  % three possible combinations of coefficients

  num_data = size( w_coeffs, 1);
  
  contrib = zeros( size( w_coeffs, 1), 3);
  contrib(:,1) = getContribCoeff( 1, 2, areas_childs, filters, w_coeffs);
  contrib(:,2) = getContribCoeff( 1, 3, areas_childs, filters, w_coeffs);  
  contrib(:,3) = getContribCoeff( 2, 3, areas_childs, filters, w_coeffs);   
  
	% accumulate contribution for each wavelet basis function / associated
	% wavelet basis function filter coefficient
    
  contrib_coeffs(:,1) = abs( contrib(:,1)) + abs( contrib(:,2)) + ...
               abs( getContribCoeff( 1, 1, areas_childs, filters, w_coeffs));
  contrib_coeffs(:,2) = abs( contrib(:,1)) + abs( contrib(:,3)) + ...
               abs( getContribCoeff( 2, 2, areas_childs, filters, w_coeffs));
  contrib_coeffs(:,3) = abs( contrib(:,2)) + abs( contrib(:,3)) + ...
               abs( getContribCoeff( 3, 3, areas_childs, filters, w_coeffs));    
    
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c = getContribCoeff( index_1, index_2, areas_childs, filters, w_coeffs)
%
% c = getContribCoeff( index_1, index_2, areas_childs, filters, w_coeffs)
%
% Compute one coefficient
  
  c =    w_coeffs(:,index_1) ...
      .* w_coeffs(:,index_2) ...
      .* getInnerProductWavelets( areas_childs, ...
                                  filters(:,index_1+1), ...
                                  filters(:,index_2 + 1));  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function n = getInnerProductWavelets( areas_tri_childs, g_1, g_2)
% 
% n = getInnerProductWavelets( areas_tri_childs, g_1, g_2)
%
% Compute the inner product of two wavelet basis functions defined over the
% same spherical triangle
%
% @return  inner product (norm) of the two wavelet basis functions
% @param tri_childs  list of the areas of the four child triangles of the domain over
%                    which the two wavelet basis functions are defined
% @param  g_1  filter coefficients g_{j,m,l} of the first wavelet basis
%              function
% @param  g_2  filter coefficients g_{j,m,l} of the second wavelet basis
%              function
% @parma  num_channels  number of data channels
  
  n = 0;
  for( i = 1 : numel( g_1))
    n = n + (g_1(i) * g_2(i) * areas_tri_childs(i));
  end

end