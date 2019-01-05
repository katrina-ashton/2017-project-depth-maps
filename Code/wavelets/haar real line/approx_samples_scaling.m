f = @(x) exp(x);
a = 0;
b = 1;
m = 10000;
t = a: (b-a)/m: b- (b-a)/m;
fs = f(t);

jmax = 10;

%Check with example from book: gives same results...
% t = [0,0.25,0.5,0.75];
% fs = [1,2,3,4];
% m = 4;
% jmax = 2;

[coeff, scoeff] = dht(fs, jmax, m);

%Get rid of useless coefficients:
% thresh = 1e-1;
% scoeff(abs(scoeff)<thresh) =0;
% coeff(abs(coeff)<thresh) =0;

x = invertwave(scoeff(jmax+1,:), coeff, m);
x = x(1,:);

%Plot the approximation
plot(t, fs, t, x)