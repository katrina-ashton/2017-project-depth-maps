function plot_points(Xr)
theta = Xr(:,1);
phi = Xr(:,2);
r = Xr(:,3);
[x,y,z] = sph2cart(phi, pi/2-theta, r);
scatter3(x,y,z, '*', 'filled', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
xlabel('x')

end