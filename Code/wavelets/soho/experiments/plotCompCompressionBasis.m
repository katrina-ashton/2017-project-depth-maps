
lp_norm = 1;

osh = res_osh(:,lp_norm);
bioh = res_bioh(:,lp_norm);
pwh = res_pwh(:,lp_norm);

legend_str = {'SOHO Wavelets', 'Bio-Haar Wavelets', 'Pseudo-Haar Basis'};
ylabel_str = ['L' num2str(lp_norm) ' Error'];

xlabel_str = 'Coefficients Retained';
% xlabel_str = 'Level';

title_str = ['Visibility'];

% x = [64 256 512 1024 1536 2056 2568 3080];
% x = [32 64 128 256 512 1024 2056];
x = [64 256 512 1024 2056 4096 8192 16384 32768];
% x = [512 1024 2056 4096 8192 16384 32768];
% x = [4096 8192 16384 32768]
% x = [2 3 4 5];

% start plotting

figure;
plot( x, osh, '-rx', x, bioh, '-bo', x, pwh, '-gs');
% semilogx( x, osh, 'r', x, bioh, 'b', x, pwh, 'g'); 
% loglog( x, osh, '-rx', x, bioh, '-bo', x, pwh, '-gs'); 

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

xlim( [55 33000]);
% xlim( [55 10000]);
% set(gca,'XTick',[2500;5000;7500;10000]);
% set(gca,'XTickLabel',[2500;5000;7500;10000]);