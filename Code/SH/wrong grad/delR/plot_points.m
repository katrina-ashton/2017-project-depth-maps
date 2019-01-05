function plot_points(Xr)
theta = Xr(:,1);
phi = Xr(:,2);
r = Xr(:,3);
x = abs(r).*sin(theta).*cos(phi); 
y = abs(r).*sin(theta).*sin(phi);
z = abs(r).*cos(theta);
scatter3(x,y,z, '*', 'filled', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')

end