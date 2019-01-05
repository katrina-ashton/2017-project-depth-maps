%Set parameters
type = 'cylinder';
O = [0.01, 0.01, 0];
rot = [0,0,0];
invrot = [-rot(3), -rot(2), -rot(1)];
resenv = 500;
resbase = 50;
nmeas = 2000;
R = 1;
h = 2;
R1 = 3;
h1 = 6;
n = 40;
lam = 0.1;
lr = 0.01;
resplot = 150;

tic
%Generate data points
base = generate_points(type, O, rot, resenv, resbase, nmeas, R, h);
[base1, meas, test] = generate_points(type, O, rot, resenv, resbase, nmeas, R1, h1);

fprintf('Generating data - ');
toc
%Find initial model using base data
wb = getweights_initial(base(:,1:2), base(:,3), n, lam);

fprintf('Finding inital model - ');
toc
plot_sbf(wb, n, resplot)

fprintf('Plotting inital model - ');
toc

%Get the transformed weights
if isequal(O, [0,0,0])
    wn = wb;
else
    x = O(1);
    y = O(2);
    z = O(3);
    rv = sqrt(x^2+y^2+z^2);
    thetav = acos(z/rv);
    phiv = atan2(y,x);
    v = [thetav, phiv, rv];    

    wn = transform_weights(wb, n, v, rot);
    fprintf('Transforming model - ');
    toc
    plot_sbf(wn, n, resplot);
    title('Model after moving origin')
    fprintf('Plotting transformed model - ');
    toc
end

%Input measurements to transformed model
delR = r2delR(meas(:,1:2), meas(:,3), wn, n);
w1 = grad_descent(meas(:,1:2), delR, n, wn, lr);
fprintf('Getting new weights (transform model method) - ');
toc

if isequal(O, [0,0,0])
    w1n = w1;
else
    w1n = transform_weights(w1, n, -v, invrot);
    fprintf('Transforming model back - ');
    toc
end

plot_sbf(w1n, n, resplot);
title('Updated model (transform model method)')
fprintf('Plotting updated model (transform model method) - ');
toc

%Input measurements to original model
transmat = new_scoord(meas(:,1), meas(:,2), meas(:,3), O, rot);
delR = r2delR(transmat(:,1:2), transmat(:,3), wb, n);
w2 = grad_descent(transmat(:,1:2), delR, n, wb, lr);
fprintf('Getting new weights (transform measurements method) - ');
toc

plot_sbf(w2, n, resplot);
title('Updated model (transform measurements method)')
fprintf('Plotting updated model (transform measurements method) - ');
toc