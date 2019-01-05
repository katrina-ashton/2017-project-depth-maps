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
% level = 3;
% nc = 64;       
% level = 10;
% nc = 1500;

tic;

% construct forest of partition trees
forest = getForestPlatonicSolid( platonic_solid, level, fhs.enforce_equal_area);

% function
%sphere
f = @(t,p) 1;

%cylinder.
% R = 1;
% H = 2;
% f = @(t,p) (t<=atan(2*R/H)||t>=pi-atan(2*R/H))*(H/2)/cos(t) ...
%     + (t>atan(2*R/H)&&t<=pi/2)*R/cos(pi/2-t) ...
%     + (t>pi/2&&t<pi-atan(2*R/H))*R/cos(t-pi/2);


% sample signal onto the domains on the finest level of the partition trees
forest_sampled = sampleSphericalMapF( forest, f, 3, level, 0);

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
% [err_l1, err_l2, diff] = getError( forest_synth, forest_sampled, level);
% disp( sprintf( 'L1 error: %f / %f / %f', err_l1(1), err_l1(2), err_l1(3)));
% disp( sprintf( 'L2 error: %f / %f / %f', err_l2(1), err_l2(2), err_l2(3)));

% display approximated signal
%points/triangles
plotDataFastF( forest_sampled, level) 
figure
plotDataFastF(forest_synth, level)

%surf (interpolated)
% plotDataFastFull( forest_sampled, level, 200) 
% figure
% plotDataFastFull(forest_synth, level, 200)