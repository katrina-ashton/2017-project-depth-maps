% Run simple Spherical Harmonics experiment

% parameters

sqrt_samples = 100;
num_bands = 3;
level_vis = 5;
% platonic solid used for visualization and reference solution
platonic_solid = 'octahedron';

% ico = create_truncated_icosahedron;
ico = create_octahedron;

samples = shGenerateSamples( 100, num_bands);

signal_file = 'experiments/signals/world.jpg';
signal = imread( signal_file);
 
%coeffs = shProjectPartition( samples, num_bands, ico, 0);
coeffs = shProjectSphericalMap( samples, num_bands, signal);

forest_sh = shVisualize( platonic_solid, coeffs, level_vis);
plotDataFast( forest_sh, level_vis)
      
% compute error

% construct forest of partition trees 
% (do not construct SOHO equal area partition)
forest = getForestPlatonicSolid( platonic_solid, level_vis, 0);

% sample signal onto the domains on the finest level of the partition trees
forest_sampled = sampleSphericalMap( forest, signal, 10, level_vis, 0);

[err_l1, err_l2, diff] = getError( forest_sh, forest_sampled, level_vis);
disp( sprintf( 'L1 error: %f / %f / %f', err_l1(1), err_l1(2), err_l1(3)));
disp( sprintf( 'L2 error: %f / %f / %f', err_l2(1), err_l2(2), err_l2(3)));



