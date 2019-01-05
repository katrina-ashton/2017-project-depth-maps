R = 1;
h = 2;
res = 20;
spt = 0;
ept = pi;
spp = 0;
epp = pi;
O = [0,0,0];

[X0, r0] = getdatapoints(R, h, res, spt, ept, spp, epp, O);

spt = 0;
ept = pi;
spp = pi;
epp = 2*pi;
On = [0.1, 0.1, 0];
[X1, r1] = getdatapoints(R, h, res, spt, ept, spp, epp, On);


theta_p = X0(:,1);
phi_p = X0(:,2);
r_p = r0;
x = abs(r_p).*sin(theta_p).*cos(phi_p); 
y = abs(r_p).*sin(theta_p).*sin(phi_p);
z = abs(r_p).*cos(theta_p);
scatter3(x,y,z, '*', 'filled', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')

% [thetam,phim,rm] = new_scoord(X1(:,1), X1(:,2), r1, On);
% Xm = [thetam, phim];
Xm = X1;
rm = r1;

theta_p = Xm(:,1);
phi_p = Xm(:,2);
r_p = rm;
x = abs(r_p).*sin(theta_p).*cos(phi_p); 
y = abs(r_p).*sin(theta_p).*sin(phi_p);
z = abs(r_p).*cos(theta_p);
figure;
scatter3(x,y,z, '*', 'filled', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')