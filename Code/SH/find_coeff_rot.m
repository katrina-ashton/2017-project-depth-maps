function c = find_coeff_rot(co, L, M, rot)
%zyz convention 
alpha = rot(1);
beta = rot(2);
gamma = rot(3);

c = 0;
for m = -L:L
   c = c+ D(L, m, M, alpha, beta, gamma)*co(L^2+L+m+1); 
end

end

function Dlmk = D(l,m,k, alpha, beta, gamma)
dlmk1 = d(l, abs(k), abs(m), beta) + (-1)^m*d(l, abs(m), -abs(k), beta);
dlmk2 = d(l, abs(k), abs(m), beta) - (-1)^m*d(l, abs(m), -abs(k), beta);
Dlmk = sig(k)*az_op(k, alpha)*az_op(m, gamma)*dlmk1/2 ...
    -sig(m)*az_op(-k, alpha)*az_op(-m, gamma)*dlmk2/2;
end

function dlmk = d(l, m, k, beta)
sum = 0;
for s = 0:(l+abs(m))
   if (l-m-s)<0 || (l+k-s)<0 || (m-k+s)<0
       continue
   end
   denom = factorial(s)*factorial(l-m-s)*factorial(l+k-s)*factorial(m-k+s);
   sum = sum + (-1)^(s)*cos(beta/2)^(2*(l-s)-m+k)*sin(beta/2)^(2*s+m-k)/denom;
end

dlmk = (-1)^(m-k)*sqrt(factorial(l+k)*factorial(l-k)*factorial(l+m)*factorial(l-m))*sum;
end

function Phi = az_op(m, ang)
if m>0
    Phi = sqrt(2)*cos(m*ang);
elseif m==0
    Phi = 1;
else
    Phi = -sqrt(2)*sin(abs(m)*ang);
end
end

function sign = sig(x)
if x < 0
    sign = -1;
else
    sign = 1;
end
end