
figure;
hold on;

% COMPARE DIFFERENT BASES

% title_str = 'Texture Map';
% osh_data = osh_octahedron_world_l7;
% bioh_data = bioh_octahedron_world_l7;
% pwh_data = pwh_octahedron_world_l7;
% bonneau1_data = bonneau1_octahedron_world_l7;
% bonneau2_data = bonneau2_octahedron_world_l7;
% nielson1_data = nielson1_octahedron_world_l7;
% nielson2_data = nielson2_octahedron_world_l7;

% title_str = 'Visibility Map';
% osh_data = osh_octahedron_visibility_l7;
% bioh_data = bioh_octahedron_visibility_l7;
% pwh_data = pwh_octahedron_visibility_l7;
% bonneau1_data = bonneau1_octahedron_visibility_l7;
% bonneau2_data = bonneau2_octahedron_visibility_l7;
% nielson1_data = nielson1_octahedron_visibility_l7;
% nielson2_data = nielson2_octahedron_visibility_l7;

title_str = 'BRDF';
osh_data = osh_octahedron_lambertian_l7;
bioh_data = bioh_octahedron_lambertian_l7;
pwh_data = pwh_octahedron_lambertian_l7;
bonneau1_data = bonneau1_octahedron_lambertian_l7;
bonneau2_data = bonneau2_octahedron_lambertian_l7;
nielson1_data = nielson1_octahedron_lambertian_l7;
nielson2_data = nielson2_octahedron_lambertian_l7;



lp_norm = 2;

level = 7;

x = getCoeffsRetained( level);

xlabel_str = 'Coefficients Retained';
ylabel_str = ['L' num2str( lp_norm) ' Error'];

plot( x, osh_data(:,lp_norm), '-rx', ...
      x, bioh_data(:,lp_norm), '-bo', ...
      x, pwh_data(:,lp_norm), '-g*', ...
      x, nielson1_data(:,lp_norm), '--cx', ...
      x, nielson2_data(:,lp_norm), '--co', ...
      x, bonneau1_data(:,lp_norm), '--mx', ...
      x, bonneau2_data(:,lp_norm), '--mo' );

legend_str = {'SOHO', 'Bio-Haar', 'Pseudo Haar', ...
              'Nielson1', 'Nielson2', 'Bonneau1', 'Bonneau2'};

            
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % COMPARE PARTITIONS BASED ON DIFFERENT PLATONIC SOLIDS
% 
% % title_str = 'Texture Map';
% % octahedron_data = osh_octahedron_world_l7;
% % icosahedron_data = osh_icosahedron_world_l7;
% % tetrahedron_data = osh_tetrahedron_world_l7;
% 
% title_str = 'Visibility Map';
% octahedron_data = osh_octahedron_visibility_l7;
% icosahedron_data = osh_icosahedron_visibility_l7;
% tetrahedron_data = osh_tetrahedron_visibility_l7;
% 
% % title_str = 'BRDF';
% % octahedron_data = osh_octahedron_lambertian_l7;
% % icosahedron_data = osh_icosahedron_lambertian_l7;
% % tetrahedron_data = osh_tetrahedron_lambertian_l7;
% 
% 
% 
% lp_norm = 2;
% 
% level = 7;
% 
% x = getCoeffsRetained( level);
% 
% xlabel_str = 'Coefficients Retained';
% ylabel_str = ['L' num2str( lp_norm) ' Error'];
% 
% semilogy( x, octahedron_data(:,lp_norm), '-rx', ...
%           x, icosahedron_data(:,lp_norm), '-bo', ...
%           x, tetrahedron_data(:,lp_norm), '-g*');
% 
% 
% % general
% 
% legend_str = {'Octahedron', 'Icosahedron', 'Tetrahedron'};
% 
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERAL

h = legend( legend_str, 1);
legend('boxoff')
set( h,'FontName','helvetica', 'FontSize',14);
title( title_str);
xlabel( xlabel_str);
ylabel( ylabel_str);

set( gca, 'Box', 'on');
set(gca,'FontName','helvetica', 'FontSize',14);
set(get(gca,'XLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'YLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'Title'),'FontName','helvetica', 'FontSize',14);

% set(gca,'XTick',x);
% set(gca,'XTickLabel',x);
