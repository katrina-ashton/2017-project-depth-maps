%Set parameters
type = 'cylinder';
O = [0, 0, 0];
%rote = [3.4,0.7297,0];
rote = [3.4,0.7297,1];
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
n = 40;
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
if O~= [0,0,0]
    x = O(1);
    y = O(2);
    z = O(3);
    rv = sqrt(x^2+y^2+z^2);
    thetav = acos(z/rv);
    phiv = atan2(y,x);
    v = [thetav, phiv, rv];   
else
    v = [0,0,0];
end   

wn = transform_weights(wb, n, v, [3.4,0.7297,0]);

plot_sbf(wn, n, resplot); 
xlabel('x');
ylabel('y');
zlabel('z');
plot_points(meas); 
%Seems like it's an issue with my measurements rather than the
%transformation forumula (set alpha=0).
