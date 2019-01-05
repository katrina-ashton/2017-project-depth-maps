%Set parameters
type = 'cylinder';
O = [0, 0, 0];
rote = [3.4,0.7297,0];
invrote = [-rote(3), -rote(2), -rote(1)];
rot = eul2rotm(rote);
invrot = rot';
nmeas = 10000;
R = 1;
h = 2;
n = 40;
lam = 0.1;
lr = 1;
resplot = 150;

base = generate_points(type, O, rot, nbase, R, h);
wb = getweights_initial(base(:,1:2), base(:,3), n, lam);
plot_sbf(wb, n, resplot); 
