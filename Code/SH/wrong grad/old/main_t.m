%Making a cylinder
X = [pi/2,0;    pi/2, pi/2;     pi/2, pi;   pi/2, 3*pi/2;   0,0;    pi,0; ...
    atan(0.5), 0;  atan(0.5), pi/2; atan(0.5), pi;    atan(0.5), 3*pi/2; ...
    pi-atan(0.5), 0;  pi-atan(0.5), pi/2; pi-atan(0.5), pi;    pi-atan(0.5), 3*pi/2; ...
    atan(0.5), pi/4;  atan(0.5), 3*pi/4; atan(0.5), 5*pi/4;    atan(0.5), 7*pi/4; ...
    pi-atan(0.5), pi/4;  pi-atan(0.5), 3*pi/4; pi-atan(0.5), 5*pi/4;    pi-atan(0.5), 7*pi/4; ...
    atan(1), 0;  atan(1), pi/2; atan(1), pi;    atan(1), 3*pi/2; ...
    pi-atan(1), 0;  pi-atan(1), pi/2; pi-atan(1), pi;    pi-atan(1), 3*pi/2; ...
    atan(1), pi/4;  atan(1), 3*pi/4; atan(1), 5*pi/4;    atan(1), 7*pi/4; ...
    pi-atan(1), pi/4;  pi-atan(1), 3*pi/4; pi-atan(1), 5*pi/4;    pi-atan(1), 7*pi/4];

t = [1;1;1;1;2;2;sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5); ...
    sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5); ...
    sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2); ...
    sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2)];

%X gives (theta, phi) pairs: one per row
%t gives corresponding r values


n = 3; %Highest l used for spherical harmonics (ones from 0 to n will be used)
lam = 0.1; %Regularisation constant
res = 500; %Resolution for plotting shape
x = 0.1;
y = 0.1;
z = 0;
r = sqrt(x^2+y^2+z^2);
theta = acos(z/r);
phi = atan(y/x);
v = [theta, phi, r];

vx = [x,y,z];

%Get the weights
w = sc2sbf_lr(X, t, n, lam);

%Plot the model of the shape and mark the training points
sbf_plot(w, X, t, n, res);

%Get the transformed weights
wn = transform_weights(w, n, v);
sbf_plot(wn, X, t, n, res);