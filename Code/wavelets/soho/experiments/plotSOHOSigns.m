

xlabel_str = 'Coefficients Retained';

ylabel_str = 'L1 Error';


lp_norm = 1;

level = 7;

x = getCoeffsRetained( level);

plot( x, world_l7_s0(:,:,lp_norm), '-rx', ...
      x, world_l7_s1(:,:,lp_norm), '--ro',...
      x, lambertian_l7_s0(:,:,lp_norm), '-bx', ...
      x, lambertian_l7_s1(:,:,lp_norm), '--bo',...
      x, visibility_l7_s0(:,:,lp_norm), '-gx', ...
      x, visibility_l7_s1(:,:,lp_norm), '--go' )

legend_str = { 'Texture Map, Sign -', ...
               'Texture Map, Sign +', ...
               'BRDF, Sign -', ...
               'BRDF, Sign +', ...
               'Visibility Map, Sign -', ...
               'Visibility Map, Sign +' };
               
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
      