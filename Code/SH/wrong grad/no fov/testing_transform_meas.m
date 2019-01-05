%Set parameters
type = 'sphere';
O = [0.1, 0.1, 0];
%rote = [3.4,0.7297,0];
rote = [0,0,0];
invrote = [-rote(3), -rote(2), -rote(1)];
rot = eul2rotm(rote);
invrot = rot';
ntest = 10000;
nbase = 10000;
nmeas = 2000;
R0 = 1;
h0 = 2;
R = 1.5;
h = 2.5;
n = 20;
lam = 0.1;
lr = 1;
resplot = 150;

%Generate data points
base = generate_points(type, [0,0,0], eye(3), nbase, R0, h0);
meas = generate_points(type, O, rot, nmeas, R0, h0);
%test = generate_points(type, [0,0,0], eye(3), ntest, R, h);

%Find initial model using base data
wb = getweights_initial(base(:,1:2), base(:,3), n, lam);

%Get the transformed weights
% if O~= [0,0,0]
    x = -O(1);
    y = -O(2);
    z = -O(3);
    [phiv, thetav, rv] = cart2sph(x,y,z);

    thetav = abs(thetav-pi/2);
    phiv = mod(phiv, 2*pi);
    v = [thetav, phiv, rv];   
% else
%     v = [0,0,0];
% end   

wn = transform_weights(wb, n, v, rote, R0);
wnt = getweights_initial(meas(:,1:2), meas(:,3), n, lam);

plot_sbf(wn, n, resplot); 
xlabel('x');
ylabel('y');
zlabel('z');
plot_points(meas); 

