
figure;
hold on;

% COMPARE SPHERICAL HAAR WAVELET BASES

approx_index = 1;

ylabel_str = 'L2 error';

full_measure = osh_visibility_err_l1_full;
approx_measure = osh_visibility_err_l1_approx(:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = 2 : 4;

legend_str = {'SOHO Full', 'SOHO Approx'};
xlabel_str = 'Level';

plot( x, full_measure, '-rx', ...
      x, approx_measure, '-bs' );

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
      