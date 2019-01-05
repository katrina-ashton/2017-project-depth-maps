function out = new_scoord(theta, phi, r, t, rot)
[x,y,z] = sph2cart(phi, pi/2-theta, r);
x = x-t(:,1);
y = y-t(:,2);
z = z-t(:,3);

v = [x,y,z]';
% rotM = eul2rotm(rot);
v = rot*v;

v = v';
x = v(:,1);
y = v(:,2);
z = v(:,3);

[phi, theta, r] = cart2sph(x,y,z);

theta = abs(theta-pi/2);

out = [theta, phi, r];
end