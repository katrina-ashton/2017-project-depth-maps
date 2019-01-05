function plotWaveletFunctions3D( tri, type) 
%
% plotWaveletFunctions3D( tri, type)
%
% Plot the wavelet basis functions corresponding to the spherical triangle
% tri
% @param  tri  spherical triangle whose associated wavelet basis function to 
%              visualize
% @param  type {1,2,3}  type of the wavelet

  type = type + 1;

  % get the filter coefficients
  ftabs = oshFiltersAnalysis( tri);

  % plot the childs with the correct coefficients
  for i = 1 : numel( tri.childs)

    a = 1.0 / sqrt( getArea( tri.childs(i)));
    a = a / 5;
    
    a = a * ftabs( type,i);

    plotTriCurved( tri.childs(i), 1.0 + a);  
  end
    
end  
