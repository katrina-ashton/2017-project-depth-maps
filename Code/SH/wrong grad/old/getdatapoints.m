function [X, r] = getdatapoints(R, h, res, spt, ept, spp, epp, O)
deltat = (ept-spt)/res;
deltap = deltat*(ept-spt)/(epp-spp);
theta = spt:deltat:ept;
phi = spp:deltap:epp;
[phi,theta] = meshgrid(phi,theta);
N = numel(theta);
theta = reshape(theta, [N, 1]);
phi = reshape(phi, [N, 1]);

[phi,theta] = meshgrid(phi,theta);
n = numel(theta);
theta = reshape(theta, [n, 1]);
phi = reshape(phi, [n, 1]);

%Getting radii
st = sin(theta);

r = R./st;
r(theta<atan(2*R/h)) = h./(2*cos(theta(theta<atan(2*R/h))));
r(theta>pi-atan(2*R/h)) = h./(2*cos(theta(theta>pi-atan(2*R/h))));
r(st==0) = h/2;

if O ~= [0,0,0]
    [theta,phi,r] = new_scoord(theta, phi, r, -O);
end

X = [theta, phi];

end