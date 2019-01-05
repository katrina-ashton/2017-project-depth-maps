function c = find_coeff_rot(co, L, M, rot)
%zyz convention used instead of zxz
alpha = rot(1)-pi/2;
beta = rot(2);
gamma = rot(3)-3*pi/2;

c = 0;
for m = -L:L
   c = c+ D(L, m, M, alpha, beta, gamma)*co(L^2+L+m+1); 
end

end

function Dlmk = D(l,m,k, alpha, beta, gamma)
    Flmk = F(l,m,k,beta);
    d = sqrt(factorial(l+k)*factorial(l-k)*factorial(l+m)*factorial(l-m))*Flmk;
    Dlmk = exp(-1i*k*alpha)*d*exp(-1i*m*gamma);
end

function Flmk = F(l, m, k, beta)
    Flmk = 0;
    for s = 0:l
       if (l+m-s)<0 || (k-m+s)<0 || (l-k-s)<0
           break
       end
       denom = factorial(l+m-s)*factorial(s)*factorial(k-m+s)*factorial(l-k-s);
       Flmk = Flmk + (-1)^(k-m+s)*cos(beta/2)^(2*(l-s)+m-k)*sin(beta/2)^(2*s-m+k)/denom;
    end
end