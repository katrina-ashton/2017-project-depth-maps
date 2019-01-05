tic
R = 1;
h = 2;
res = 15;
spt = 0;
ept = pi;
spp = 0;
epp = 2*pi;
O = [0,0,0];

[X0, r0] = getdatapoints(R, h, res, spt, ept, spp, epp, O);

res = 10;
spt = 0;
ept = pi;
spp = 0;
epp = 2*pi;
On = [0.1, 0.1, 0];
[X1, r1] = getdatapoints(R, h, res, spt, ept, spp, epp, On);

toc

n = 40; %Highest l used for spherical harmonics (ones from 0 to n will be used)
lam = 1; %Regularisation constant
res = 500; %Resolution for plotting shape

%Get the weights
w = sc2sbf_lr(X0, r0, n, lam);
toc

%Plot the model of the shape and mark the training points
sbf_plot(w, X0, r0, n, res);
title('Original model')
toc

%tic
%Get the transformed weights
x = On(1);
y = On(2);
z = On(3);
rv = sqrt(x^2+y^2+z^2);
thetav = acos(z/rv);
phiv = atan(y/x);
v = [thetav, phiv, rv];

wn = transform_weights(w, n, v);
toc
sbf_plot_moved(wn, X0, r0, n, res, On);
title('Model after moving origin')
toc


% %Add the new points
% N = size(X1, 1);
% nb = 50; %mini-batch size
% lam = 0;
% lr = 2;
% wnn = wn;
% for i=1:nb:N
%     lr = 2*lr/nb;
%     j = min(N, i+nb-1);
%     wnn = sc2sbf_slr_mb(X1(i:j,:), r1(i:j), n, wnn, lr, lam);
% end
% 
% sbf_plot_moved(wnn, X1, r1, n, res, On);
% title('Model after added weights (moved origin method)')
% 
% toc
% 
% [theta2,phi2,rm] = new_scoord(X1(:,1), X1(:,2), r1, On);
% Xm = [theta2, phi2];
% lr = 2;
% wnm = w;
% for i=1:nb:N
%     lr = 2*lr/nb;
%     j = min(N, i+nb-1);
%     wnm = sc2sbf_slr_mb(Xm(i:j,:), rm(i:j), n, wnm, lr, lam);
% end
% 
% sbf_plot_movedm(wnm, X1, r1, n, res, On);
% title('Model after added weights (moved measurements method)')
% 
% toc