% load data
load ../face/projections/fig3_1_sr_min_10.mat
fig3_1 = forest_sampled;

% perform forward transform
fig3_1_analysed = dswtAnalyseFull( fig3_1, level, fhs.filters_analysis, fhs.normalize);

% get coefficients
coeffs_fig3_1_analysed = getCoeffsForest( fig3_1_analysed, level);

% find thresholds so that 512 coefficients are non-zero after approximation
thresholds = getThresholdLargestK( fig3_1_analysed, level, 512, fhs.approx );

% set all coefficients smaller than 'thresholds' to zero
fig3_1_approx = approxSWT( fig3_1_analysed, level, thresholds, fhs.approx );

% reconstruct the approximated signal
fig3_1_synth = dswtSynthesiseFull( fig3_1_approx, level, fhs.filters_synthesis, fhs.denormalize, 0, 1);

% get basis function coefficients
coeffs_fig3_1_synth = getCoeffsForest( fig3_1_synth, level);


% load data
load ../face/projections/fig3_2_sr_min_10.mat
fig3_2 = forest_sampled;

% perform forward transform
fig3_2_analysed = dswtAnalyseFull( fig3_2, level, fhs.filters_analysis, fhs.normalize);

% get coefficients
coeffs_fig3_2_analysed = getCoeffsForest( fig3_2_analysed, level);

% find thresholds so that 512 coefficients are non-zero after approximation
thresholds = getThresholdLargestK( fig3_2_analysed, level, 512, fhs.approx );

% set all coefficients smaller than 'thresholds' to zero
fig3_2_approx = approxSWT( fig3_2_analysed, level, thresholds, fhs.approx );

% reconstruct the approximated signal
fig3_2_synth = dswtSynthesiseFull( fig3_2_approx, level, fhs.filters_synthesis, fhs.denormalize, 0, 1);

% get basis function coefficients
coeffs_fig3_2_synth = getCoeffsForest( fig3_2_synth, level);


% load data
load ../face/projections/fig3_3_sr_min_10.mat
fig3_3 = forest_sampled;

% perform forward transform
fig3_3_analysed = dswtAnalyseFull( fig3_3, level, fhs.filters_analysis, fhs.normalize);

% get coefficients
coeffs_fig3_3_analysed = getCoeffsForest( fig3_3_analysed, level);

% find thresholds so that 512 coefficients are non-zero after approximation
thresholds = getThresholdLargestK( fig3_3_analysed, level, 512, fhs.approx );

% set all coefficients smaller than 'thresholds' to zero
fig3_3_approx = approxSWT( fig3_3_analysed, level, thresholds, fhs.approx );

% reconstruct the approximated signal
fig3_3_synth = dswtSynthesiseFull( fig3_3_approx, level, fhs.filters_synthesis, fhs.denormalize, 0, 1);

% get basis function coefficients
coeffs_fig3_3_synth = getCoeffsForest( fig3_3_synth, level);


% load data
load ../face/projections/fig3_4_sr_min_10.mat
fig3_4 = forest_sampled;

% perform forward transform
fig3_4_analysed = dswtAnalyseFull( fig3_4, level, fhs.filters_analysis, fhs.normalize);

% get coefficients
coeffs_fig3_4_analysed = getCoeffsForest( fig3_4_analysed, level);

% find thresholds so that 512 coefficients are non-zero after approximation
thresholds = getThresholdLargestK( fig3_4_analysed, level, 512, fhs.approx );

% set all coefficients smaller than 'thresholds' to zero
fig3_4_approx = approxSWT( fig3_4_analysed, level, thresholds, fhs.approx );

% reconstruct the approximated signal
fig3_4_synth = dswtSynthesiseFull( fig3_4_approx, level, fhs.filters_synthesis, fhs.denormalize, 0, 1);

% get basis function coefficients
coeffs_fig3_4_synth = getCoeffsForest( fig3_4_synth, level);