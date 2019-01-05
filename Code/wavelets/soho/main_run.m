scales = [5, 3, 2, 1.5, 0.5, 0.1, 0.05, 0.01];
factors = [100, 50, 10, 0.01, 1/50, 0.001];
uncertainties = [1, 0.7, 0.4, 0.1, 0.05, 0.01, 0.001];
levelms = [3,4,5,6,7];
% fovts = [pi/4, pi/4, pi/3, pi/3, pi/2];
% fovps = [pi/4, pi/3, pi/3, pi/2, pi/2];
ncs = [2^6,2^7,2^8,2^10];


addpath utility rotation experiments dswt

level = 4;
nc = 2^10;

fovt = pi;
fovp = 2*pi;
scale = 1;
uncer = 0;
N = 100;
modflag = 1;
nmeas = 2000;

%1000 too high ~ 2
%500 too high ~ 4
%200 too high ~ 5
%100 ~ l=5, slow
p1n0 = 'wtransmod-4-100';
p2n0 = 'wtransmeas-4-100';
sse1n0 = 'wtransmodsse-4-100';
sse2n0 = 'wtransmeassse-4-100';
varn0 = 'wvar-4-100';
resplot = 200;

% function
%sphere
% f = @(t,p) 1;

%cylinder.
R = 1;
H = 2;
f = @(t,p) abs((t<=atan(2*R/H)||t>=pi-atan(2*R/H))*(H/2)/cos(t) ...
    + (t>atan(2*R/H)&&t<=pi/2)*R/cos(pi/2-t) ...
    + (t>pi/2&&t<pi-atan(2*R/H))*R/cos(t-pi/2));

R = 1.5;
H = 3;
% fm = @(t,p) abs((t<=atan(2*R/H)||t>=pi-atan(2*R/H))*(H/2)/cos(t) ...
%     + (t>atan(2*R/H)&&t<=pi/2)*R/cos(pi/2-t) ...
%     + (t>pi/2&&t<pi-atan(2*R/H))*R/cos(t-pi/2));


move_func(f, N, level, nc, fovt, fovp, scale, ...
    p1n0, p2n0, sse1n0, sse2n0, varn0, uncer, modflag, resplot, nmeas, 'cylinder', 100, R, H)

close all;
disp('done')

N = 50;
p1n0 = 'wtransmod-4-200';
p2n0 = 'wtransmeas-4-200';
sse1n0 = 'wtransmodsse-4-200';
sse2n0 = 'wtransmeassse-4-200';
varn0 = 'wvar-4-200';
move_func(f, N, level, nc, fovt, fovp, scale, ...
    p1n0, p2n0, sse1n0, sse2n0, varn0, uncer, modflag, resplot, nmeas, 'cylinder', 200, R, H)

N = 100;
p1n0 = 'wtransmod-4-150';
p2n0 = 'wtransmeas-4-150';
sse1n0 = 'wtransmodsse-4-150';
sse2n0 = 'wtransmeassse-4-150';
varn0 = 'wvar-4-150';
move_func(f, N, level, nc, fovt, fovp, scale, ...
    p1n0, p2n0, sse1n0, sse2n0, varn0, uncer, modflag, resplot, nmeas, 'cylinder', 150, R, H)




%%Robustness: initial model%%%
% N = 60;
% 
% for i=1:numel(factors)
%     sf = factors(i);
%     R0 = R*sf;
%     h0 = H*sf;
%     fb = @(t,p) abs((t<=atan(2*R0/h0)||t>=pi-atan(2*R0/h0))*(h0/2)/cos(t) ...
%     + (t>atan(2*R0/h0)&&t<=pi/2)*R0/cos(pi/2-t) ...
%     + (t>pi/2&&t<pi-atan(2*R0/h0))*R0/cos(t-pi/2));
%     p1n = ['R',p1n0,num2str(i)];
%     p2n = ['R',p2n0,num2str(i)];
%     sse1n = ['R',sse1n0,num2str(i)];
%     sse2n = ['R',sse2n0,num2str(i)];
%     varn = ['R',varn0,num2str(i)];
%     move_func(fb, fm, N, level, nc, fovt, fovp, scale, ...
%     p1n, p2n, sse1n, sse2n, varn, uncer, modflag, resplot, nmeas, 'cylinder', R, H)
%     close all;
% end

% R0 = 1;
% fb = @(t,p) R0;
% 
% p1n = ['C',p1n0,num2str(R0)];
% p2n = ['C',p2n0,num2str(R0)];
% sse1n = ['C',sse1n0,num2str(R0)];
% sse2n = ['C',sse2n0,num2str(R0)];
% varn = ['C',varn0,num2str(R0)];
% move_func(fb, fm, N, level, nc, fovt, fovp, scale, p1n, p2n, ...
%     sse1n, sse2n, varn, uncer, modflag, resplot, nmeas, 'cylinder', R0)
% close all;
% 
% R0 = 3;
% fb = @(t,p) R0;
% 
% p1n = ['C',p1n0,num2str(R0)];
% p2n = ['C',p2n0,num2str(R0)];
% sse1n = ['C',sse1n0,num2str(R0)];
% sse2n = ['C',sse2n0,num2str(R0)];
% varn = ['C',varn0,num2str(R0)];
% move_func(fb, fm, N, level, nc, fovt, fovp, scale, p1n, p2n, ...
%     sse1n, sse2n, varn, uncer, modflag, resplot, nmeas, 'cylinder', R0)
% close all;
% 
% disp('done')
% % 
% % %%%Robustness: uncertainties%%%
% N = 60;

% for i=4:numel(uncertainties)
%     uncer = uncertainties(i);
%     p1n = ['U',p1n0,num2str(i)];
%     p2n = ['U',p2n0,num2str(i)];
%     sse1n = ['U',sse1n0,num2str(i)];
%     sse2n = ['U',sse2n0,num2str(i)];
%     varn = ['U',varn0,num2str(i)];
%     move_func(f, fm, N, level, nc, fovt, fovp, scale, ...
%     p1n, p2n, sse1n, sse2n, varn, uncer, modflag, resplot, nmeas, 'cylinder', R, H)
%     close all;
% end
% 
% uncer = 0;

% %%%Robustness: delR scaling%%%
% N = 60;
% 
% for i=1:numel(scales)
%     scale = scales(i);
%     p1n = ['S',p1n0,num2str(i)];
%     p2n = ['S',p2n0,num2str(i)];
%     sse1n = ['S',sse1n0,num2str(i)];
%     sse2n = ['S',sse2n0,num2str(i)];
%     varn = ['S',varn0,num2str(i)];
%     move_func(f, fm, N, level, nc, fovt, fovp, scale, ...
%     p1n, p2n, sse1n, sse2n, varn, uncer, modflag, resplot, nmeas, 'cylinder', R, H)
%     close all;
% end
% 
% scale = 1;


%%%
% N = 60;
% 
% for i=1:numel(levelms)
%     levelm = levelms(i);
%     p1n = ['M2',p1n0,num2str(i)];
%     p2n = ['M2',p2n0,num2str(i)];
%     sse1n = ['M2',sse1n0,num2str(i)];
%     sse2n = ['M2',sse2n0,num2str(i)];
%     varn = ['M2',varn0,num2str(i)];
%     move_func(f, fm, N, level, nc, fovt, fovp, scale, ...
%     p1n, p2n, sse1n, sse2n, varn, uncer, levelm, modflag, resplot)
%     close all;
% end
% 
% levelm = 5;
% 
% for i=1:numel(ncs)
%     nc = ncs(i);
%     p1n = ['B',p1n0,num2str(i)];
%     p2n = ['B',p2n0,num2str(i)];
%     sse1n = ['B',sse1n0,num2str(i)];
%     sse2n = ['B',sse2n0,num2str(i)];
%     varn = ['B',varn0,num2str(i)];
%     move_func(f, fm, N, level, nc, fovt, fovp, scale, ...
%     p1n, p2n, sse1n, sse2n, varn, uncer, levelm, modflag, resplot)
%     close all;
% end
% 
% nc = 2^9;
% 
