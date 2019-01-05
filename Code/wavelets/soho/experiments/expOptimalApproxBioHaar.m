function [ err_optimal, err_largest] = ...
                                   expOptimalApproxBioHaar( platonic_solid, ...
                                                            basis, ...
                                                            signal_file, ...
                                                            level, ...
                                                            coeffs_retained )
%
%  expOptimalApproxBioHaar( platonic_solid, basis, signal_file, level, ...
%                                                             coeffs_retained )
%
% Find the optimal approximation of a signal in an biorthogonal Haar
% wavelet basis (and compare it to an approximation where the k-largest
% coefficients have been retained).
%
% @return  err_optimal  L1 and L2 error for 
  
  % pre-process optional input arguments
  cr = getCoeffsRetained( level);
  if( nargin > 4)
    cr = coeffs_retained;  
  end
  coeffs_retained = cr;

  % setup experiment environment
 
  % functions for basis
  fhs = getFunctionHandlesBasis( basis);
  
  % get partition
  forest = getForestPlatonicSolid( platonic_solid, level, ...
                                   fhs.enforce_equal_area );
  
  % read signal and resample onto the finest level of the partition
  signal = imread( signal_file);
  forest_sampled = sampleSphericalMap( forest, signal, 10, level, 0);                               
  
  % perform full analysis
  forest_analysed = dswtAnalyseFull( forest_sampled, level, ...
                                     fhs.filters_analysis, fhs.normalize);

  % do for all trees of the forest
  contrib_coeffs = [];
  for( i = 1 : numel( forest_analysed))

    % for each partition compute the accumulated contribution of the
    % associated wavelet basis functions / wavelet basis function
    % coefficients
    temp = [];
    temp = getContribCoeffs( forest_analysed(i), level, temp, fhs);

    contrib_coeffs = [contrib_coeffs  temp];
    
  end

  % sort coefficients
  contrib_coeffs = sort( abs( contrib_coeffs), 2, 'descend' );

  % variables to store the result
  err_optimal.l1 = zeros(1,numel( coeffs_retained));
  err_optimal.l2 = zeros(1,numel( coeffs_retained));  
  err_largest.l1 = zeros(1,numel( coeffs_retained));
  err_largest.l2 = zeros(1,numel( coeffs_retained));  
 
  % perform approximation
  for( i = 1 : numel( coeffs_retained))
  
    num_coeffs_retained = coeffs_retained(i);
    
    % determine threshold (midpoint between k and k+1)
    coeffs_wavelets_retained = num_coeffs_retained - numel( forest);
    thresholds_optimal = (contrib_coeffs(:,coeffs_wavelets_retained) + ...
                          contrib_coeffs(:,coeffs_wavelets_retained + 1)) / 2;

    % reference: compute the
    thresholds_largest = getThresholdLargestK( forest_analysed, level, ...
                                               num_coeffs_retained);

    % set all coefficients which are smaller than the threshold to 0
    forest_approx_optimal = [];
    for( t = 1 : numel( forest_analysed))
      
      q =thresholdContribCoeffs( forest_analysed(t), level, ...
                                 thresholds_optimal, fhs);
      forest_approx_optimal = [forest_approx_optimal q ];
                                
    end
    forest_approx_largest = approxSWT( forest_analysed, level, ...
                                       thresholds_largest);

    % perform reconstruction of approximated signal
    forest_synth_optimal = dswtSynthesiseFull( forest_approx_optimal, level, ...
                                     fhs.filters_synthesis, fhs.denormalize, ...
                                     0, 1);

    forest_synth_largest = dswtSynthesiseFull( forest_approx_largest, level, ...
                                     fhs.filters_synthesis, fhs.denormalize, ...
                                     0, 1);                            

    % compute errors
    [err_l1, err_l2] = getError( forest_synth_optimal, forest_sampled, level);
    err_optimal.l1(i) = mean( err_l1);
    err_optimal.l2(i) = mean( err_l2);  

    [err_l1, err_l2] = getError( forest_synth_lar gest, forest_sampled, level);
    err_largest.l1(i) = mean( err_l1);
    err_largest.l2(i) = mean( err_l2);  


    coeffs_optimal = getCoeffsForest( forest_synth_optimal, level);
    coeffs_largest = getCoeffsForest( forest_synth_largest, level);
    nnz_optimal = int16( round( numel( find( coeffs_optimal ~= 0)) / 3));
    nnz_largest = int16( round( numel( find( coeffs_largest ~= 0)) / 3));
    
    disp( sprintf('L2 (optimal / largest) with coeffs :: %f  / %f', ...
                    err_optimal.l2(i), err_largest.l2(i)) );
    disp( sprintf( 'Coeffs retained :: %i :: %i / %i\n', ...
                    num_coeffs_retained, ...
                    nnz_optimal , nnz_largest) );
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tri = thresholdContribCoeffs( tri, level, thresholds, fhs)
%
% tri = thresholdContribCoeffs( tri, level, thresholds, fhs)
%
% Threshold all wavelet coefficients below 
%

  % get accumulated contribution for the basis function coefficients
  % associated with the current triangle
  contrib_coeffs_partition = getContribCoeffsPartition( tri, fhs);
  
  temp = repmat(thresholds , 1 , size( contrib_coeffs_partition, 2));   
  indices = find( contrib_coeffs_partition <= temp );
  w_coeffs = getWaveletCoeffs( tri);
  w_coeffs(indices) = 0;  
  tri = setWaveletCoeffs( tri, w_coeffs);
  
  % recursively traverse wavelet tree if not at the finest level 
  if( getLevel( tri) < (level - 1))

    childs = getChilds( tri);

    for( i = 1 : numel( childs))
      childs(i) = thresholdContribCoeffs( childs(i), level, thresholds, fhs);
    end
    
    tri = setChilds( tri, childs);
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  contrib_coeffs = getContribCoeffs( tri, level, contrib_coeffs, fhs)
%
% contrib_coeffs = getContribCoeffs( tri, level, contrib_coeffs, fhs)
%
% Compute the accumulated contribution of each coefficient 
%
% @return  linear list of the accumulated contribution of each coefficient
% @param  tri  root node of tree of spherical triangles
% @param  level  level on which the data is defined (i.e. the tree is
%                traversed up to (level - 1))
% @param contrib_coeffs  linear list of the accumulated contribution of
%                        each coefficient

  % get accumulated contribution for the basis function coefficients
  % associated with the current triangle
  contrib_coeffs_partition = getContribCoeffsPartition( tri, fhs);
  
  % store coefficients (ignore order, only absolute value is relevant
  contrib_coeffs = [contrib_coeffs  contrib_coeffs_partition];
  
  % recursively traverse wavelet tree if not at the finest level 
  if( getLevel( tri) < (level - 1))

    childs = getChilds( tri);

    for( i = 1 : numel( childs))
      contrib_coeffs = getContribCoeffs( childs(i), level, contrib_coeffs, fhs);
    end
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function contrib_coeffs = getContribCoeffsPartition( tri, fhs)
%
% contrib_coeffs = getContribCoeffsPartition( tri, fhs)
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
  filters = fhs.filters_synthesis( tri);
      
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
  contrib(:,1) = w_coeffs(:,1) .* w_coeffs(:,2) .* ...
    getInnerProductWavelets(areas_childs, filters(:,2), filters(:,3));
  contrib(:,2) = w_coeffs(:,1) .* w_coeffs(:,3) .* ...
    getInnerProductWavelets(areas_childs, filters(:,2), filters(:,4));
  contrib(:,3) = w_coeffs(:,2) .* w_coeffs(:,3) .* ...
    getInnerProductWavelets(areas_childs, filters(:,3), filters(:,4));  

	% accumulate contribution for each wavelet basis function / associated
	% wavelet basis function filter coefficient
    
  contrib_coeffs(:,1) = abs( contrib(:,1)) + abs( contrib(:,2)); 
  contrib_coeffs(:,2) = abs( contrib(:,1)) + abs( contrib(:,3));  
  contrib_coeffs(:,3) = abs( contrib(:,2)) + abs( contrib(:,3));    
    
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