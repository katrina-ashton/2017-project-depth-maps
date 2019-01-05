function [l1, l2] = shExpApprox( bands, level_ref, signal_file)
%
% [l1, l2] = shExpApprox( bands, level_ref, signal_file)
%
% Run SH experiment for different bands and compute \ell_1 and \ell_2 error
% of representation.
%
% @param  bands   bands to use for expriments (as array)
% @param  level_ref  level to use for reference solution
% @param  signal_file  path to the signal file

  % fixed parameters
  sqrt_samples = 100;
  platonic_solid = 'octahedron';
  
  % general setup
   
  signal = imread( signal_file);

  % construct forest of partition trees 
  % (do not construct SOHO equal area partition)
  forest = getForestPlatonicSolid( platonic_solid, level_ref, 0);
  
  % initialize result
  l1 = [];
  l2 = [];
  
  % do for all bands
  for( num_bands = bands)

    % generate samples (for specific band)
    samples = shGenerateSamples( sqrt_samples, num_bands);

    % project signal into the basis
    coeffs = shProjectSphericalMap( samples, num_bands, signal);

    % sample signal onto the domains on the finest level of the partition trees
    forest_sampled = sampleSphericalMap( forest, signal, 10, level_ref, 0);

    forest_sh = shVisualize( platonic_solid, coeffs, level_ref);
    [err_l1, err_l2, diff] = getError( forest_sh, forest_sampled, level_ref);
  
    disp( sprintf( 'L1 error: %f / %f / %f', err_l1(1), err_l1(2), err_l1(3)));
    disp( sprintf( 'L2 error: %f / %f / %f', err_l2(1), err_l2(2), err_l2(3)));
  
    l1 = [l1  err_l1];
    l2 = [l2  err_l2];
    
  end  % end for all bands
  
end