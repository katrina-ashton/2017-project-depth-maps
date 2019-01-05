
figure;
hold on;

platonic_solid = 'octahedron';
signal = 'world';
lp_norm = 1;
level = 7;

x = getCoeffsRetained( level);

    
plot( x, bioh_largest_world(:,lp_norm), '--r', ...
      x, bioh_optimal_world(:,lp_norm), '-r', ...
      x, bioh_largest_lambertian(:,lp_norm), '--b', ...
      x, bioh_optimal_lambertian(:,lp_norm), '-b', ...
      x, bioh_largest_visibility(:,lp_norm), '--g', ...
      x, bioh_optimal_visibility(:,lp_norm), '-g' );

% plot( x, bioh_largest(:,lp_norm), '-ms', ...
%       x, bioh_optimal(:,lp_norm), '-bo', ...
%       x, osh_optimal(:,lp_norm), '-rx', ...
%       x, pwh_optimal(:,lp_norm), '-g*');
     
% setup annotations
x_label_str = 'Coefficients Retained';
y_label_str = ['L' num2str( lp_norm) ' Error'];
% title_str = sprintf( 'Platonic Solid = %s , Signal = %s, Level = %i', ...
%                      platonic_solid, signal, level);
% legend_str = {'Bio-Haar, k-largest' , 'Bio-Haar, optimal', ...
%              'SOHO Wavelets', 'Pseudo-Haar'};
legend_str = {'Texture Map, k-largest', 'Texture Map, optimal', ...
              'BRDF, k-largest', 'BRDF, optimal', ...
              'Visibility Map, k-largest', 'Visibility, optimal'};

title_str = ''; 
title( title_str);
xlabel( x_label_str);
ylabel( y_label_str);

h = legend( legend_str, 1);
legend('boxoff');
set( h,'FontName','helvetica', 'FontSize',14);

set( gca, 'Box', 'on');
set(gca,'FontName','helvetica', 'FontSize',14);
set(get(gca,'XLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'YLabel'),'FontName','helvetica', 'FontSize',14);
set(get(gca,'Title'),'FontName','helvetica', 'FontSize',14);

