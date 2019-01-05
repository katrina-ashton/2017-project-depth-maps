
% COMPARE SOHO AND HAAR CUBEMAP BASIS

ylabel_str = 'L1 Error';

title_str = 'Texture Map';

osh_err = osh_full_l1;
cmap_err = cmap_full_l1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = 2 : 4;

legend_str = {'SOHO', 'Haar Cubemap'};
xlabel_str = 'Level';

plot( x, osh_err(:), '-rx', ...
      x, cmap_err(1:3), '-bs');

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

set(gca,'FontName','helvetica', 'FontSize',14);
set(get(gca,'XLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'YLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'Title'),'FontName','helvetica', 'FontSize',14);
      