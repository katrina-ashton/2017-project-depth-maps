

% comparison signs, fixed level, fixed signal

% error norm L_{1,2}
err_norm = 2;

% level = 7;
% world_s0 = squeeze( world_l7_s0(1,:,:));        
% world_s1 = squeeze( world_l7_s1(1,:,:));
% lambertian_s0 = squeeze( lambertian_l7_s0(1,:,:));   
% lambertian_s1 = squeeze( lambertian_l7_s1(1,:,:));
% visibility_s0 = squeeze( visibility_l7_s0(1,:,:));   
% visibility_s1 = squeeze( visibility_l7_s1(1,:,:));

level = 5;
world_s0 = squeeze( world_l5_s0(1,:,:));        
world_s1 = squeeze( world_l5_s1(1,:,:));
lambertian_s0 = squeeze( lambertian_l5_s0(1,:,:));   
lambertian_s1 = squeeze( lambertian_l5_s1(1,:,:));
visibility_s0 = squeeze( visibility_l5_s0(1,:,:));   
visibility_s1 = squeeze( visibility_l5_s1(1,:,:));


x = getCoeffsRetained( level);

semilogx( x, world_s0(:,err_norm), '-rx', ...
          x, world_s1(:,err_norm), '--rx', ...
          x, lambertian_s0(:,err_norm), '-bs', ...
          x, lambertian_s1(:,err_norm), '--bs', ...
          x, visibility_s0(:,err_norm), '-go', ...
          x, visibility_s1(:,err_norm), '--go' );

legend_str = { 'Texture Map, Sign +', 'Texture Map, Sign -', ...
               'BRDF, Sign +', 'BRDF, Sign -', ...
               'Visibility Map, Sign +', 'Visibility Map, Sign -' };
title_str = '';
xlabel_str = 'Number of Coefficients Retained';
ylabel_str = ['L' num2str(err_norm) ' Error'];
             

% general part
% 
h = legend( legend_str, 1);
legend('boxoff')
set( h,'FontName','helvetica', 'FontSize',14);
title( title_str);
xlabel( xlabel_str);
ylabel( ylabel_str);

set(gca,'FontName','helvetica', 'FontSize',14);
set(get(gca,'XLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'YLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'Title'),'FontName','helvetica', 'FontSize',14);

xlim( [x(1) x(end)]);