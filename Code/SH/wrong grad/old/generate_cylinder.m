function [theta, phi, r] = generate_cylinder(R, h, res)
%Generating theta and phi 
delta = pi/res;
theta = delta:delta:pi;
phi = 2*delta:2*delta:2*pi;
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
end