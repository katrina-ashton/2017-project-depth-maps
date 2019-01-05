f = @(x,y) x.^2 + y.^2;
a = 0;
b = 1;
m = 2^7;
n = m;
[t1,t2] = meshgrid(a: (b-a)/m: b- (b-a)/m);
fs = f(t1, t2);

jmax = 8;

[coeff1, coeff2, coeff3, scoeff] = dht_square(fs, jmax, m, n);

%Get rid of useless coefficients:
thresh = 1e-1;
scoeff(abs(scoeff)<thresh) =0;
coeff1(abs(coeff1)<thresh) =0;
coeff2(abs(coeff2)<thresh) =0;
coeff3(abs(coeff3)<thresh) =0;

x = invertwave_square(scoeff(:,:,jmax),coeff1,coeff2,coeff3,m,n);
% %test error in reconstruction:
% for i = jmax:-1:1
%     sum(sum(abs(x(:,:,i)-scoeff(:,:,i))))
% end

x = x(:,:,1);

%Plot the approximation
surf(t1, t2, fs); figure
surf(t1, t2, x);