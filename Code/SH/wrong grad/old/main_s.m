%X gives (theta, phi) pairs: one per row
%theta is in [0,pi], phi is in [0, 2pi)
%t gives corresponding r values
X = [pi/2,0;    pi/2, pi/2;     pi/2, pi;   pi/2, 3*pi/2;   0,0;    pi,0; ...
    atan(0.5), 0;  atan(0.5), pi/2; atan(0.5), pi;    atan(0.5), 3*pi/2; ...
    pi-atan(0.5), 0;  pi-atan(0.5), pi/2; pi-atan(0.5), pi;    pi-atan(0.5), 3*pi/2; ...
    atan(0.5), pi/4;  atan(0.5), 3*pi/4; atan(0.5), 5*pi/4;    atan(0.5), 7*pi/4; ...
    pi-atan(0.5), pi/4;  pi-atan(0.5), 3*pi/4; pi-atan(0.5), 5*pi/4;    pi-atan(0.5), 7*pi/4; ...
    atan(1), 0;  atan(1), pi/2; atan(1), pi;    atan(1), 3*pi/2; ...
    pi-atan(1), 0;  pi-atan(1), pi/2; pi-atan(1), pi;    pi-atan(1), 3*pi/2; ...
    atan(1), pi/4;  atan(1), 3*pi/4; atan(1), 5*pi/4;    atan(1), 7*pi/4; ...
    pi-atan(1), pi/4;  pi-atan(1), 3*pi/4; pi-atan(1), 5*pi/4;    pi-atan(1), 7*pi/4];

t = [1;1;1;1;2;2;sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5); ...
    sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5); ...
    sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2); ...
    sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2);sqrt(2)];

%Ot gives the translation of the origin (x,y,z) coordinates from the
%original starting point
%new_scoord is then used to transform X and t so that they are referenced
%from original origin
% Ot = [0,0,0; 1,1,0; 2,2,0; 3,3,0; 4,4,0; 5,5,0; 6,6,0; ...
%     -1,-1,0; -2,-2,0; -3,-3,0; -4,-4,0; -5,-5,0; -6,-6,0; -7,-7,0];
% 
% [tn, Xnt, Xnp] = new_scoord(t, X(:,1), X(:,2), Ot);
% Xn = [Xnt, Xnp];

n = 10; %Highest l used for spherical harmonics (ones from 0 to n will be used)
lr = 2; %Learning rate
lam = 0;
res = 500; %Resolution for plotting shape

%Get the weights
w = 2*rand((n+1)^2, 1)-1;

% for i=1:size(X,1)
%     lr = lr/1.29;
%     w = sc2sbf_slr(X(i,:), t(i), n, w, lr, lam);
% end

m = size(X,1);
for i=1:100*m
    j = mod(i,m);
    if j == 0
        j = m;
    end
    
    if i<20
    lr = lr/1.29;
    end
    
    w = sc2sbf_slr(X(j,:), t(j), n, w, lr, lam);
end

%Plot the model of the shape and mark the training points
sbf_plot(w, X, t, n, res);