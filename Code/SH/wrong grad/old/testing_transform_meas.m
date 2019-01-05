%Set parameters
type = 'cylinder';
O = [0.1, 0.1, 0];
ntest = 100;
nbase = 10000;
nmeas = 2000;
R0 = 1;
h0 = 2;
R = 1.5;
h = 2.5;
n = 1;
lam = 0.1;
lr = 1;
resplot = 150;

%Generate data points
base = generate_points(type, [0,0,0], eye(3), nbase, R0, h0);
meas = generate_points(type, O, eye(3), nmeas, R0, h0);
%test = generate_points(type, [0,0,0], eye(3), ntest, R, h);

%Find initial model using base data
wb = sc2sbf_lr(base(:,1:2), base(:,3), n, lam);

%Get the transformed weights
x = O(1);
y = O(2);
z = O(3);
% [phiv, thetav, rv] = cart2sph(x,y,z);
% thetav = abs(thetav-pi/2);
% v = [thetav, phiv, rv];    
r = sqrt(x^2+y^2+z^2);
theta = acos(z/r);
phi = atan(y/x);
v = [theta, phi, r];

wn = transform_weights(wb, n, v);
wn = real(wn);

N = 1;
theta = meas(N,1);
phi = meas(N,2);
r = meas(N,3);

sbf_plot(wb, base(:,1:2), base(:,3), n, res);

sbf_plot(wn, meas(:,1:2), meas(:,3), n, res);