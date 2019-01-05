
figure;
hold on;

% COMPARE SPHERICAL HAAR WAVELET BASES

ylabel_str = 'Sparsity';
title_str = '';

% soho_measure = osh_visibility_err_l2_full;
% bioh_measure = bioh_visibility_err_l2_full;
% pwh_measure = pwh_visibility_err_l2_full;

soho_measure = osh_full_sparsity;
bioh_measure = bioh_full_sparsity;
pwh_measure = npwh_full_sparsity;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = 2 : 4;

legend_str = {'SOHO', 'Bio-Haar', 'Pseudo Haar'};
xlabel_str = 'Level';

plot( x, soho_measure, '-rx', ...
      x, bioh_measure, '-bs', ...
      x, pwh_measure, '-go');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% general 

% 
h = legend( legend_str, 1);
legend('boxoff')
set( h,'FontName','helvetica', 'FontSize',14);
xlabel( xlabel_str);
ylabel( ylabel_str);
title( title_str);

set(gca,'XTick', x);
set(gca,'XTickLabel',x);

set(gca, 'box', 'on');
set(gca,'FontName','helvetica', 'FontSize',14);
set(get(gca,'XLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'YLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'Title'),'FontName','helvetica', 'FontSize',14);
      