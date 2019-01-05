%Set parameters
type = 'cylinder';
O = [0, 0.01, 0];
rote = [pi/64,pi/64,0];
%rote = [0,0,0];
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

tic
%Generate data points
base = generate_points(type, [0,0,0], eye(3), nbase, R0, h0);
meas = generate_points(type, O, rot, nmeas, R, h);
test = generate_points(type, [0,0,0], eye(3), ntest, R, h);

fprintf('Generating data - ');
toc
%Find initial model using base data
wb = getweights_initial(base(:,1:2), base(:,3), n, lam);

fprintf('Finding inital model - ');
toc
sse = get_sse(wb, n, test);
sse = sse/size(test,1);
fprintf('Average SSE - %d\n', sse);
plot_sbf(wb, n, resplot)
title('Initial model')

fprintf('Plotting inital model - ');
toc

%Get the transformed weights
x = O(1);
y = O(2);
z = O(3);
rv = sqrt(x^2+y^2+z^2);
thetav = acos(z/rv);
phiv = atan2(y,x);
v = [thetav, phiv, rv];    

wn = transform_weights(wb, n, v, rote);
wn = real(wn);
fprintf('Transforming model - ');
toc
sse = get_sse(wn, n, test);
sse = sse/size(test,1);
fprintf('Average SSE - %d\n', sse);
plot_sbf(wn, n, resplot);
title('Model after moving origin')
fprintf('Plotting transformed model - ');
toc


%Input measurements to transformed model
delR = r2delR(meas(:,1:2), meas(:,3), wn, n);
w1 = grad_descent(meas(:,1:2), delR, n, wn, lr);
fprintf('Getting new weights (transform model method) - ');
toc

w1n = transform_weights(w1, n, -v, invrote);
w1n = real(w1n);
fprintf('Transforming model back - ');
toc
sse = get_sse(w1n, n, test);
sse = sse/size(test,1);
fprintf('Average SSE - %d\n', sse);

plot_sbf(w1n, n, resplot);
title('Updated model (transform model method)')
fprintf('Plotting updated model (transform model method) - ');
toc

%Input measurements to original model
transmat = new_scoord(meas(:,1), meas(:,2), meas(:,3), O, invrot);
delR = r2delR(transmat(:,1:2), transmat(:,3), wb, n);
w2 = grad_descent(transmat(:,1:2), delR, n, wb, lr);
fprintf('Getting new weights (transform measurements method) - ');
toc
sse = get_sse(w2, n, test);
sse = sse/size(test,1);
fprintf('Average SSE - %d\n', sse);


plot_sbf(w2, n, resplot);
title('Updated model (transform measurements method)')
fprintf('Plotting updated model (transform measurements method) - ');
toc

