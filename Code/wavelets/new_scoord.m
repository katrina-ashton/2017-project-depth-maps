function out = new_scoord(theta, phi, r, t, rot)
[x,y,z] = sph2cart(phi-pi, pi/2-theta, r);

v = [x,y,z]';
% rotM = eul2rotm(rot);
v = rot*v;

% v = rot(:,1:3)*v;
% v = rot(:,4:6)*v;
% v = rot(:,7:9)*v;

v = v';
x = v(:,1);
y = v(:,2);
z = v(:,3);

x = x-t(1);
y = y-t(2);
z = z-t(3);

[phi, theta, r] = cart2sph(x,y,z);

theta = abs(theta-pi/2);
phi = pi + phi;

out = [theta, phi, r];
end