
title_str = '';

level = 7;

levels = [1 : level];

% plot comparison of mean for different signals

figure;
hold on;

semilogy( levels, osh_world(2,:), '-rx', ...
          levels, osh_lambertian(2,:), '-bo', ...
          levels, osh_visibility(2,:), '-g*');
    
legend_str = { 'Texture Map' , 'BRDF', 'Visibility Map'};
xlabel_str = 'Level';
ylabel_str = 'Mean of Magnitude of the Coefficients';


% % plot comparison of zero coefficients for different signals
% 
% figure;
% hold on;
% 
% plot( levels, bioh_world(1,:), '-rx', ...
%       levels, bioh_lambertian(1,:), '-bo', ...
%       levels, bioh_visibility(1,:), '-g*');
%     
% legend_str = { 'Earth' , 'Lambertian BRDF', 'Visibility'};
% xlabel_str = 'Level';
% ylabel_str = 'Ratio of Zero Coefficients';
% 
% set(gca,'YLim',[0 1.05]);
% 
% % 

% plot comparison nnz elements visibility vs. inverse visibility
% 
% figure;
% hold on;
% 
% bar( [osh_visibility(2,:) ; osh_inv_visibility(2,:)]', 'group');
% 
% legend_str = { 'Visibility', 'Inverse Visibility'};
% xlabel_str = 'Level';
% ylabel_str = 'Ratio of Non-Zero Coefficients';
% 
% legend( legend_str);
% xlabel( xlabel_str);
% ylabel( ylabel_str);
% 
% 
% % comparison of mean across bases for earth texture map

% figure;
% hold on;
% 
% plot( levels, osh_world(2,:), '-rx', ...
%       levels, bioh_world(2,:), '-bo', ...
%       levels, pwh_world(2,:), '-g*');
%     
% legend_str = {'SOHO' , 'Bio-Haar', 'Pseudo Haar'};
% xlabel_str = 'Level';
% ylabel_str = 'Mean of Magnitude of the Coefficients';


% comparison of nnz coeffs across bases

% figure;
% hold on;
% 
% plot( levels, osh_visibility(1,:), '-rx', ...
%       levels, bioh_visibility(1,:), '-bo', ...
%       levels, pwh_visibility(1,:), '-g*');
%     
% legend_str = {'SOHO' , 'Bio-Haar', 'Pseudo Haar'};
% xlabel_str = 'Level';
% ylabel_str = 'Ratio of Zero Coefficients';
% 
% set(gca,'YLim',[0 1.05]);


% general post

h = legend( legend_str, 3);
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

