R = 1;
H = 3;
% f = @(t,p) abs((t<=atan(2*R/H)||t>=pi-atan(2*R/H))*(H/2)/cos(t) ...
%     + (t>atan(2*R/H)&&t<=pi/2)*R/cos(pi/2-t) ...
%     + (t>pi/2&&t<pi-atan(2*R/H))*R/cos(t-pi/2));

% f = @(t,p) cos(p)/(t+1);

% f = @(t,p) ((abs(t-pi/2)< 0.1) && (abs(p-pi/3)< 0.1)) + 1;
% % 
% del = pi/100;
% t = 0:del:pi;
% p = 0:2*del:2*pi;
% [p,t] = meshgrid(p,t);
% N = numel(t);
% t= reshape(t, [N, 1]);
% p = reshape(p, [N, 1]);
% r = zeros(N,1);
% for i = 1:N
%     r(i) = f(t(i),p(i));
% end
% base = [t,p,r];

base = generate_points('cylinder', [0,0,0], eye(3), 10000, pi, 2*pi, 0, R, H);
n = 40;
lam = 0.1;
wb = getweights_initial(base(:,1:2), base(:,3), n, lam);
resplot = 150;
% plot_sbf_points(base(:,1:2), base(:,3), wb, n, resplot);
plot_sbf(wb, n, resplot);
xlabel('x')
ylabel('y')
zlabel('z')

% %Set parameters
% type = 'cylinder';
% O = [0, 0.01, 0];
% rote = [pi/64,pi/64,0];
% %rote = [0,0,0];
% invrote = [-rote(3), -rote(2), -rote(1)];
% rot = eul2rotm(rote);
% invrot = rot';
% ntest = 10000;
% nbase = 10000;
% nmeas = 5000;
% R0 = 1;
% h0 = 2;
% R = 1.5;
% h = 2.5;
% n = 40;
% lam = 0.1;
% lr = 0.001;
% resplot = 150;
% 
% tic
% %Generate data points
% base = generate_points(type, [0,0,0], eye(3), nbase, pi, 2*pi, 0, R0, h0);
% meas = generate_points(type, O, rot, nmeas, pi, 2*pi, 0, R, h);
% test = generate_points(type, [0,0,0], eye(3), ntest, pi, 2*pi, 0, R, h);
% 
% fprintf('Generating data - ');
% toc
% %Find initial model using base data
% wb = getweights_initial(base(:,1:2), base(:,3), n, lam);
% 
% fprintf('Finding inital model - ');
% toc
% sse = get_sse(wb, n, test);
% sse = sse/size(test,1);
% fprintf('Average SSE - %d\n', sse);
% plot_sbf(wb, n, resplot)
% title('Initial model')
% 
% fprintf('Plotting inital model - ');
% toc
% 
% % %Get the transformed weights
% % x = O(1);
% % y = O(2);
% % z = O(3);
% % rv = sqrt(x^2+y^2+z^2);
% % thetav = acos(z/rv);
% % phiv = atan2(y,x);
% % v = [thetav, phiv, rv];    
% % 
% % wn = transform_weights(wb, n, v, rote);
% % wn = real(wn);
% % fprintf('Transforming model - ');
% % toc
% % sse = get_sse(wn, n, test);
% % sse = sse/size(test,1);
% % fprintf('Average SSE - %d\n', sse);
% % plot_sbf(wn, n, resplot);
% % title('Model after moving origin')
% % fprintf('Plotting transformed model - ');
% % toc
% % 
% % 
% % %Input measurements to transformed model
% % delR = r2delR(meas(:,1:2), meas(:,3), wn, n);
% % w1 = grad_descent(meas(:,1:2), delR, n, wn, lr);
% % fprintf('Getting new weights (transform model method) - ');
% % toc
% % 
% % w1n = transform_weights(w1, n, -v, invrote);
% % w1n = real(w1n);
% % fprintf('Transforming model back - ');
% % toc
% % sse = get_sse(w1n, n, test);
% % sse = sse/size(test,1);
% % fprintf('Average SSE - %d\n', sse);
% % 
% % plot_sbf(w1n, n, resplot);
% % title('Updated model (transform model method)')
% % fprintf('Plotting updated model (transform model method) - ');
% % toc
% 
% %Input measurements to original model
% delR = r2delR(meas(:,1:2), meas(:,3), wb, n, 1);
% r = delR2r(meas(:,1:2), delR, wb, n);
% transmat = new_scoord(meas(:,1), meas(:,2), r, O, invrot);
% delRt = r2delR(transmat(:,1:2), transmat(:,3), wb, n, 1);
% 
% % transmat = new_scoord(meas(:,1), meas(:,2), meas(:,3), O, invrot);
% % delRt = r2delR(transmat(:,1:2), transmat(:,3), wb, n, 1);
% w2 = grad_descent(meas(:,1:2), delRt, n, wb, lr);
% fprintf('Getting new weights (transform measurements method) - ');
% toc
% sse = get_sse(w2, n, test);
% sse = sse/size(test,1);
% fprintf('Average SSE - %d\n', sse);
% 
% transmat = new_scoord(meas(:,1), meas(:,2), meas(:,3), O, invrot);
% %plot_sbf(w2, n, resplot);
% plot_sbf_points(transmat(:,1:2), transmat(:,3), w2, n, resplot)
% title('Updated model (transform measurements method)')
% fprintf('Plotting updated model (transform measurements method) - ');
% toc
% 
