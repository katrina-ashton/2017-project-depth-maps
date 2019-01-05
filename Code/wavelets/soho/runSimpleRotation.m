% run runSimpleExperiment before running this script
% runSimpleExperiment;

% start timing
tic;

rand('twister', sum(100*clock));

% create random rotation
% note that rand returns uniformly distributed random numbers in [0,1] 
% arbitrarily oriented axis
axis = (2 * rand( 3,1)) - 1.0;
axis = axis / norm( axis);
% rotation angle in degrees
angle = 360.0 * rand();

% compute 3x3 rotation matrix
R = getRotationMatrix( axis, angle);

% create rotated basis
forest_rotated = rotateForest( forest, R);

% compute basis transformation matrix
btm = computeCouplingCoeffs( forest_rotated, forest, level, level, basis);

toc;
