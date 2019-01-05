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
    Flmk = F(l,m,k,beta);
    Dlmk = 1i^(k-m)*(factorial(l-k)/factorial(l-m))*exp(m*alpha+k*gamma)*Flmk;
end

function Flmk = F(l, m, k, beta)
    p1 = max(0,k-m);
    p2 = min(l+k, l-m);
    c= cos(beta/2);
    s = sin(beta/2);
    Flmk = 0;
    for p = p1:p2
       Flmk = Flmk + [l-m, p]*[l+m; m-k+p]*(-1)^p*c^(2*l+k-m-2*p)*s^(-k+m+2*p); 
    end
end