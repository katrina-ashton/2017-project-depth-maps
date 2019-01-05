

% COMPARE SOHO AND HAAR CUBEMAP BASIS

level = 4;
level = level - 1;

ylabel_str = 'Sparsity';
osh_err = osh_world_sparsity_approx(level,:);
cmap_err = cmap_world_sparsity_approx(level,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = thresholds;

legend_str = {'SOHO', 'Haar Cubemap'};
xlabel_str = 'Threshold';

plot( x, osh_err(:), '-rx', ...
      x, cmap_err(:), '-bs');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% general 

% 
h = legend( legend_str, 1);
legend('boxoff')
set( h,'FontName','helvetica', 'FontSize',14);
xlabel( xlabel_str);
ylabel( ylabel_str);

set(gca,'XTick', x);
set(gca,'XTickLabel',x);

set(gca,'FontName','helvetica', 'FontSize',14);
set(get(gca,'XLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'YLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'Title'),'FontName','helvetica', 'FontSize',14);
      