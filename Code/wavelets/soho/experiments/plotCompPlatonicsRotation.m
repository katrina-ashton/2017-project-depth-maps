
figure;
hold on;

% COMPARE SPHERICAL HAAR WAVELET BASES

approx_index = 1;

ylabel_str = 'L2 error';

octahedron_measure = osh_visibility_sparsity_full;
icosahedron_measure = osh_icosahedron_world_sparsity_full;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = 2 : 4;

legend_str = {'Octahedron', 'Icosahedron'};
xlabel_str = 'Level';

plot( x, octahedron_measure, '-rx', ...
      x, icosahedron_measure, '-bs' );

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
      