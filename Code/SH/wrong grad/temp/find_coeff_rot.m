function c = find_coeff_rot(co, L, M, rot)
%zyz convention used instead of zxz
% alpha = mod(rot(1)-pi/2, 2*pi);
% beta = rot(2);
% gamma = mod(rot(3)-3*pi/2, 2*pi);
alpha = rot(1);
beta = rot(2);
gamma = rot(3);

c = 0;
for m = -L:L
   c = c+ D(L, m, M, alpha, beta, gamma)*co(L^2+L+m+1); 
end

end

function Dlmk = D(l,m,k, alpha, beta, gamma)
dlmk = d(l, m, k, beta);
Dlmk = exp(-1i*k*alpha)*dlmk*exp(-1i*m*gamma);
end

function dlmk = d(l, m, k, beta)
sum = 0;
for s = 0:l
   if (l+m-s)<0 || (k-m+s)<0 || (l-k-s)<0
       break
   end
   denom = factorial(l+m-s)*factorial(s)*factorial(k-m+s)*factorial(l-k-s);
   sum = sum + (-1)^(k-m+s)*cos(beta/2)^(2*(l-s)+m-k)*sin(beta/2)^(2*s-m+k)/denom;
end

dlmk = sqrt(factorial(l+k)*factorial(l-k)*factorial(l+m)*factorial(l-m))*sum;
end