%Set parameters
type = 'cylinder';
O = [0, 0, 0];
rote = [pi/64,pi/64,pi/64];
%rote = [0,0,0];
invrote = [-rote(3), -rote(2), -rote(1)];
rot = eul2rotm(rote);
invrot = rot';
ntest = 10000;
nbase = 10000;
nmeas = 20000;
R = 1;
h = 2;
n = 40;
lam = 0.1;
lr = 5e-4;
resplot = 150;

tic
%Generate data points
base = generate_points(type, O, eye(3), nbase, pi, 2*pi, R, h);

meas= generate_points(type, O, rot, nmeas, pi/4, pi/4, 1.1, 2.2);

test= generate_points(type, O, rot, ntest, pi/4, pi/4, 1.1, 2.2);

fprintf('Generating data - ');
toc
%Find initial model using base data
wb = getweights_initial(base(:,1:2), base(:,3), n, lam);

fprintf('Finding inital model - ');
toc
sse = get_sse(wb, n, meas);
sse = sse/size(test,1);
fprintf('Average SSE - %d\n', sse);

%Input measurements to original model
transmat = new_scoord(meas(:,1), meas(:,2), meas(:,3), O, invrot);
delR = r2delR(transmat(:,1:2), transmat(:,3), wb, n);
w2 = grad_descent(transmat(:,1:2), delR, n, wb, lr);
fprintf('Getting new weights (transform measurements method) - ');
toc
sse = get_sse(w2, n, meas);
sse = sse/size(test,1);
fprintf('Average SSE - %d\n', sse);

plot_sbf_points(transmat(:,1:2), transmat(:,3), wb, n, resplot)
plot_sbf_points(transmat(:,1:2), transmat(:,3), w2, n, resplot)

