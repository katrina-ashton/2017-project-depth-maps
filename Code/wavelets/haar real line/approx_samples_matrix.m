f = @(x) exp(x);
a = 0;
b = 1;
m = 2^15; 
t = a: (b-a)/m: b- (b-a)/m;
fs = f(t);

jmax = 10;

[coeff, scoeff] = dht_matrix(fs, jmax, m);

%Get rid of useless coefficients:
% thresh = 1e-1;
% scoeff(abs(scoeff)<thresh) =0;
% coeff(abs(coeff)<thresh) =0;

x = invertwave_matrix(scoeff(jmax+1,:), coeff, m);
x = x(1,:);

%Plot the approximation
plot(t, fs, t, x)