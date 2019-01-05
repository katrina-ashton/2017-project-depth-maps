% add necessary paths to the environment
addpath utility rotation experiments dswt

% basis defined over a partition derived from an octahedron
platonic_solid = 'octahedron';

% other bases are 'bioh', 'pwh' (pseudo Haar), 'bonneau1', ...
basis = 'osh';

% get function handles for basis
fhs = getFunctionHandlesBasis( basis); 

% level -1 on which the input signal is sampled / number of levels over which
% the wavelet transform is performed
level = 5;
nc = 512;
%level = 3;
%nc = 64;

tic;

% construct forest of partition trees
forest = getForestPlatonicSolid( platonic_solid, level, fhs.enforce_equal_area);

% signal file
%signal_file = 'experiments/signals/world.jpg';
signal_file = 'experiments/signals/lambertian.jpg';

% load signal file (long / lat map)
signal = imread( signal_file);

% sample signal onto the domains on the finest level of the partition trees
forest_sampled = sampleSphericalMap( forest, signal, 10, level, 0);

% perform forward transform
forest_analysed = dswtAnalyseFull( forest_sampled, level, ...
                                   fhs.filters_analysis, fhs.normalize);

% find thresholds so that 512 coefficients are non-zero after approximation
thresholds = getThresholdLargestK( forest_analysed, level, nc, fhs.approx );

% set all coefficients smaller than 'thresholds' to zero
forest_approx = approxSWT( forest_analysed, level, thresholds, fhs.approx );

% reconstruct the approximated signal
forest_synth = dswtSynthesiseFull( forest_approx, level, ...
                                 fhs.filters_synthesis, fhs.denormalize, 0, 1);

toc;                               
      
% compute error
[err_l1, err_l2, diff] = getError( forest_synth, forest_sampled, level);
disp( sprintf( 'L1 error: %f / %f / %f', err_l1(1), err_l1(2), err_l1(3)));
disp( sprintf( 'L2 error: %f / %f / %f', err_l2(1), err_l2(2), err_l2(3)));

% display approximated signal
plotDataFast( forest_synth, level) 