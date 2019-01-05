%Set parameters
type = 'cylinder';
%Number of points
ntest = 10000;
nbase = 10000;
nmeas = 2000;
R0 = 1;
h0 = 2;
R = 1.5;
h = 3;
n = 40;
lam = 0.1;
lr = 10^(-3);
resplot = 150;
N = 2;  %Number of times to move camera

%Generate data points
base = generate_points(type, [0,0,0], eye(3), nbase, R0, h0);
test = generate_points(type, [0,0,0], eye(3), ntest, R, h);

%Find initial model using base data
wb = getweights_initial(base(:,1:2), base(:,3), n, lam);

w1o = wb;
w1 = wb;
w2 = wb;

err_ms = zeros(N+1,1);
err_mm = zeros(N+1,1);

sse = get_sse(wb, n, test);
sse = sse/size(test,1);

err_ms(1) = sse;
err_mm(1) = sse;

times = zeros(N, 3);
tic


roteo = [0, 0, 0];
Oo = [0, 0, 0];
for i = 1:N  
    %Rotate according to Fibonacci Spiral
    invrat = (1+sqrt(5))/2 -1;
    lat = asin(2*i/(2*N+1));
    lon = 2*pi*i*invrat;
    phi = mod(lon, 2*pi);
    theta = mod(pi/2 - lat, pi);
    theta = pi/2 - theta;
    rote = [phi, theta, 0];
    invrote = [-rote(3), -rote(2), -rote(1)];
    rot = eul2rotm(rote);
    invrot = rot';
    
    %Translate in a loop
%     r = 0.01;
%     ang = 2*pi*i/8;
%     O = [r*cos(ang), r*sin(ang), 0];
    O = [0,0,0];
    
    meas = generate_points(type, O, rot, nmeas, R, h);
    times(i,1) = toc;
    
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
    
    rotet = rote - ;
    
    w1 = transform_weights(w1, n, v, rote);
    
    plot_sbf(w1, n, resplot);
    plot_points(meas);

    %Input measurements to transformed model
    delR = r2delR(meas(:,1:2), meas(:,3), w1, n);
    w1 = grad_descent(meas(:,1:2), delR, n, w1, lr);
    w1o = w1;
    
    w1 = transform_weights(w1, n, -v, invrote);
    
    sse = get_sse(w1, n, test);
    sse = sse/size(test,1);
    err_ms(i+1) = sse;
    
    times(i,2) = toc;
    
    %Input measurements to original model
%     transmat = new_scoord(meas(:,1), meas(:,2), meas(:,3), O, invrot);
%     delR = r2delR(transmat(:,1:2), transmat(:,3), w2, n);
%     w2 = grad_descent(transmat(:,1:2), delR, n, w2, lr);
% 
%     sse = get_sse(w2, n, test);
%     sse = sse/size(test,1);
%     err_mm(i+1) = sse;
%     
%     times(i,3) = toc;
    
    roteo = rote;
    Oo = O;
end

plot_sbf(w1, n, resplot);
title('Updated model (transform model method)')

plot_sbf(w2, n, resplot);
title('Updated model (transform measurements method)')

figure;
plot(err_ms)
title('Sum-squared Error (transform model method)')

figure;
plot(err_mm)
title('Sum-squared Error (transform measurements method)')