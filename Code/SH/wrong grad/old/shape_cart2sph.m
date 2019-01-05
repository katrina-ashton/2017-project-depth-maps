function [theta, phi, r] = shape_cart2sph(x,y,z, O)
x = x - O(1);
y = y - O(2);
z = z - O(3);

r = sqrt(x.^2+y.^2+z.^2);
theta = acos(z./r);
phi = atan(y./x);
end