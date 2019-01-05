function r = new_scoordr(theta, phi, r, trans, rot)
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

x = x-trans(1);
y = y-trans(2);
z = z-trans(3);

[~, ~, r] = cart2sph(x,y,z);

end