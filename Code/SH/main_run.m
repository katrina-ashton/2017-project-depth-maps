scales = [5, 3, 2, 1.5, 0.5, 0.1, 0.05, 0.01];
factors = [100, 50, 10, 0.01, 1/50, 0.001];
uncertainties = [1, 0.7, 0.4, 0.1, 0.05, 0.01, 0.001];
% nmeas_arr = [1000, 3000, 4000];
nmeas_arr = [1500, 2500, 3500, 4500, 5000];
fovts = [pi/4, pi/4, pi/3, pi/3, pi/2];
fovps = [pi/4, pi/3, pi/3, pi/2, pi/2];
ns = [10, 15, 20, 25, 30, 35];

n = 40;

typem = 'cylinder';
R = 1.5;
h = 3;
modflag = 1;

N = 20;

fovt = pi;
fovp = 2*pi;

typeb = 'cylinder';
R0 = 1;
h0 = 2;

p1n0 = 'transmod';
p2n0 = 'transmeas';
sse1n0 = 'transmodsse';
sse2n0 = 'transmeassse';
varn0 = 'var';

% move_func(typeb, typem, R0, h0, R, h, N, n, fovt, fovp, 1, p1n0, p2n0, sse1n0, sse2n0, varn0, 0, 5000, modflag)
% close all;
% 
% %%%Robustness: delR scaling%%%
% typem = 'cylinder';
% R = 1.5;
% h = 3;
% modflag = 1;
% 
% N = 30;
% 
% fovt = pi;
% fovp = 2*pi;
% 
% typeb = 'cylinder';
% R0 = 1;
% h0 = 2;
% 
% p1n0 = 'transmod';
% p2n0 = 'transmeas';
% sse1n0 = 'transmodsse';
% sse2n0 = 'transmeassse';
% varn0 = 'var';
% 
% % move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n0, p2n0, sse1n0, sse2n0, varn0, 0, 5000, modflag)
% close all;
% 
% for i=1:numel(scales)
%     scale = scales(i);
%     p1n = ['S',p1n0,num2str(i)];
%     p2n = ['S',p2n0,num2str(i)];
%     sse1n = ['S',sse1n0,num2str(i)];
%     sse2n = ['S',sse2n0,num2str(i)];
%     varn = ['S',varn0,num2str(i)];
%     move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, scale, p1n, p2n, sse1n, sse2n, varn, 0, 5000, modflag)
%     close all;
% end
% 
% %%Robustness: initial model%%%
% typem = 'cylinder';
% R = 1.5;
% h = 3;
% modflag = 1;
% 
% N = 30;
% 
% fovt = pi;
% fovp = 2*pi;
% 
% typeb = 'cylinder';
% 
% 
% p1n0 = 'transmod';
% p2n0 = 'transmeas';
% sse1n0 = 'transmodsse';
% sse2n0 = 'transmeassse';
% varn0 = 'var';
% 
% for i=1:numel(factors)
%     scale = factors(i);
%     R0 = R*scale;
%     h0 = h*scale;
%     p1n = ['R',p1n0,num2str(i)];
%     p2n = ['R',p2n0,num2str(i)];
%     sse1n = ['R',sse1n0,num2str(i)];
%     sse2n = ['R',sse2n0,num2str(i)];
%     varn = ['R',varn0,num2str(i)];
%     move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, 0, 5000, modflag)
%     close all;
% end
% 
% typeb = 'sphere';
% R0 = 1;
% h0 = 2;
% 
% p1n = ['C',p1n0,num2str(R0)];
% p2n = ['C',p2n0,num2str(R0)];
% sse1n = ['C',sse1n0,num2str(R0)];
% sse2n = ['C',sse2n0,num2str(R0)];
% varn = ['C',varn0,num2str(R0)];
% move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, 0, 5000, modflag)
% close all;
% 
% R0 = 3;
% 
% p1n = ['C',p1n0,num2str(R0)];
% p2n = ['C',p2n0,num2str(R0)];
% sse1n = ['C',sse1n0,num2str(R0)];
% sse2n = ['C',sse2n0,num2str(R0)];
% varn = ['C',varn0,num2str(R0)];
% move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, 0, 5000, modflag)
% close all;
% % 
% % %%%Robustness: uncertainties%%%
% typem = 'cylinder';
% R = 1.5;
% h = 3;
% modflag = 1;
% 
% N = 30;
% 
% fovt = pi;
% fovp = 2*pi;
% 
% typeb = 'cylinder';
% R0 = 1;
% h0 = 2;
% 
% p1n0 = 'transmod';
% p2n0 = 'transmeas';
% sse1n0 = 'transmodsse';
% sse2n0 = 'transmeassse';
% varn0 = 'var';
% 
% for i=1:numel(uncertainties)
%     uncer = uncertainties(i);
%     p1n = ['U',p1n0,num2str(i)];
%     p2n = ['U',p2n0,num2str(i)];
%     sse1n = ['U',sse1n0,num2str(i)];
%     sse2n = ['U',sse2n0,num2str(i)];
%     varn = ['U',varn0,num2str(i)];
%     move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, uncer, 5000, modflag)
%     close all;
% end
% 
% %%%
% typem = 'cylinder';
% R = 1.5;
% h = 3;
% modflag = 1;
% 
% N = 50;
% 
% fovt = pi;
% fovp = 2*pi;
% 
% typeb = 'cylinder';
% 
% 
% p1n0 = 'transmod';
% p2n0 = 'transmeas';
% sse1n0 = 'transmodsse';
% sse2n0 = 'transmeassse';
% varn0 = 'var';
% 
% for i=2:4
%     scale = factors(i);
%     R0 = R*scale;
%     h0 = h*scale;
%     p1n = ['R',p1n0,num2str(i)];
%     p2n = ['R',p2n0,num2str(i)];
%     sse1n = ['R',sse1n0,num2str(i)];
%     sse2n = ['R',sse2n0,num2str(i)];
%     varn = ['R',varn0,num2str(i)];
%     move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, 0, 5000, modflag)
%     close all;
% end
% % 
% % %%%
% % typem = 'cylinder';
% % R = 1.5;
% % h = 3;
% % R0 = 1;
% % h0 = 2;
% % modflag = 1;
% % 
% % N = 20;
% % 
% % fovt = pi;
% % fovp = 2*pi;
% % 
% % typeb = 'cylinder';
% % 
% % 
% % p1n0 = 'transmod';
% % p2n0 = 'transmeas';
% % sse1n0 = 'transmodsse';
% % sse2n0 = 'transmeassse';
% % varn0 = 'var';
% % 
% % p1n = ['S',p1n0,num2str(10)];
% % p2n = ['S',p2n0,num2str(10)];
% % sse1n = ['S',sse1n0,num2str(10)];
% % sse2n = ['S',sse2n0,num2str(10)];
% % varn = ['S',varn0,num2str(10)];
% % move_func(typeb, typem, R0, h0, R, h, N, fovt, fovp, 10, p1n, p2n, sse1n, sse2n, varn, 0, 2000, modflag)
% % 
% 
% %%%
% typem = 'cylinder';
% R = 1.5;
% h = 3;
% R0 = 1;
% h0 = 2;
% modflag = 1;
% 
% N = 20;
% 
% fovt = pi;
% fovp = 2*pi;
% 
% typeb = 'cylinder';
% 
% 
% p1n0 = 'transmod';
% p2n0 = 'transmeas';
% sse1n0 = 'transmodsse';
% sse2n0 = 'transmeassse';
% varn0 = 'var';
% 
% 
% for i=1:numel(nmeas_arr)
%     nmeas = nmeas_arr(i);
%     p1n = ['M2',p1n0,num2str(i)];
%     p2n = ['M2',p2n0,num2str(i)];
%     sse1n = ['M2',sse1n0,num2str(i)];
%     sse2n = ['M2',sse2n0,num2str(i)];
%     varn = ['M2',varn0,num2str(i)];
%     move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, 0, 5000, modflag)
%     close all;
% end
% 
% for i=1:numel(ns)
%     n = ns(i);
%     p1n = ['B',p1n0,num2str(i)];
%     p2n = ['B',p2n0,num2str(i)];
%     sse1n = ['B',sse1n0,num2str(i)];
%     sse2n = ['B',sse2n0,num2str(i)];
%     varn = ['B',varn0,num2str(i)];
%     move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, 0, 5000, modflag)
%     close all;
% end
% % 
% % %%%FOV%%%
% typem = 'cylinder';
% R = 1.5;
% h = 3;
% R0 = 1;
% h0 = 2;
% modflag = 1;
% 
% N = 70;
% 
% fovt = pi;
% fovp = 2*pi;
% 
% typeb = 'cylinder';
% 
% 
% p1n0 = 'transmod';
% p2n0 = 'transmeas';
% sse1n0 = 'transmodsse';
% sse2n0 = 'transmeassse';
% varn0 = 'var';
% 
% for i=5:numel(nmeas_arr)
%     fovt = fovts(i);
%     fovp = fovps(i);
%     p1n = ['F',p1n0,num2str(i)];
%     p2n = ['F',p2n0,num2str(i)];
%     sse1n = ['F',sse1n0,num2str(i)];
%     sse2n = ['F',sse2n0,num2str(i)];
%     varn = ['F',varn0,num2str(i)];
%     move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, 0, 5000, modflag)
%     close all;
% end
% 
% %%%
% typem = 'cylinder';
% R = 1.5;
% h = 3;
% R0 = 1;
% h0 = 2;
% modflag = 1;
% 
% N = 20;
% 
% fovt = pi;
% fovp = 2*pi;
% 
% typeb = 'cylinder';
% 
% 
% p1n0 = 'transmod';
% p2n0 = 'transmeas';
% sse1n0 = 'transmodsse';
% sse2n0 = 'transmeassse';
% varn0 = 'var';
% 
% p1n = ['T',p1n0];
% p2n = ['T',p2n0];
% sse1n = ['T',sse1n0];
% sse2n = ['T',sse2n0];
% varn = ['T',varn0];
% move_func(typeb, typem, R0, h0, R, h, N, 20, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, 0, 5000, 0)

%%%
typem = 'cylinderside';
R = 1.5;
h = 3;
R0 = 1;
h0 = 2;
modflag = 1;

N = 500;

typeb = 'cylinder';


p1n0 = 'transmod';
p2n0 = 'transmeas';
sse1n0 = 'transmodsse';
sse2n0 = 'transmeassse';
varn0 = 'var';

for i=1:4
    fovt = fovts(i);
    fovp = fovps(i);
    p1n = ['Fl',p1n0,num2str(i)];
    p2n = ['Fl',p2n0,num2str(i)];
    sse1n = ['Fl',sse1n0,num2str(i)];
    sse2n = ['Fl',sse2n0,num2str(i)];
    varn = ['Fl',varn0,num2str(i)];
    move_func(typeb, typem, R0, h0, R, h, N, 40, fovt, fovp, 1, p1n, p2n, sse1n, sse2n, varn, 0, 5000, 0)
    close all;
end