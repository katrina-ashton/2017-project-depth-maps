
figure;
hold on;

levels = [2 : 7];

% COMPARE DIFFERENT BASES

title_str = 'Texture Map';
osh_data = cal_osh_octahedron_world;
bioh_data = cal_bioh_octahedron_world;
pwh_data = cal_pwh_octahedron_world;
bonneau1_data = cal_bonneau1_octahedron_world;
bonneau2_data = cal_bonneau2_octahedron_world;
nielson1_data = cal_nielson1_octahedron_world;
nielson2_data = cal_nielson2_octahedron_world;

% title_str = 'Visibility Map';
% osh_data = cal_osh_octahedron_visibility;
% bioh_data = cal_bioh_octahedron_visibility;
% pwh_data = cal_pwh_octahedron_visibility;
% bonneau1_data = cal_bonneau1_octahedron_visibility;
% bonneau2_data = cal_bonneau2_octahedron_visibility;
% nielson1_data = cal_nielson1_octahedron_visibility;
% nielson2_data = cal_nielson2_octahedron_visibility;

% title_str = 'BRDF';
% osh_data = cal_osh_octahedron_lambertian;
% bioh_data = cal_bioh_octahedron_lambertian;
% pwh_data = cal_pwh_octahedron_lambertian;
% bonneau1_data = cal_bonneau1_octahedron_lambertian;
% bonneau2_data = cal_bonneau2_octahedron_lambertian;
% nielson1_data = cal_nielson1_octahedron_lambertian;
% nielson2_data = cal_nielson2_octahedron_lambertian;



lp_norm = 1;

level = 7;

x = levels;

xlabel_str = 'Coefficients Retained';
ylabel_str = ['L' num2str( lp_norm) ' Error'];

loglog( x, osh_data(:,lp_norm), '-rx', ...
      x, bioh_data(:,lp_norm), '-bo', ...
      x, pwh_data(:,lp_norm), '-g*', ...
      x, nielson1_data(:,lp_norm), '--cx', ...
      x, nielson2_data(:,lp_norm), '--c*', ...
      x, bonneau1_data(:,lp_norm), '--mx', ...
      x, bonneau2_data(:,lp_norm), '--mo' );

legend_str = {'SOHO', 'Bio-Haar', 'Pseudo Haar', ...
              'Nielson1', 'Nielson2', 'Bonneau1', 'Bonneau2'};

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
