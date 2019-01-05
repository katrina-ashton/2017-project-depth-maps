function c = find_coeff_trans(co, L, M, v, ae)
%implement check that abs(M)<=L, etc.
sum = 0;
theta = v(1);
phi = v(2);
R = v(3);
for l = 0:L
    for m = -l:l
        if (L-l-M+m)>=0 && factorial(l-m)>= 0
            ly = L-l;
            my = m-M;
            
            if ly>=0 && abs(my)<=ly

                P_LM = legendre(ly,sin(theta));
                P_LM = P_LM(abs(my)+1,:);

                Y_LM = P_LM * exp(1i*(my)*phi);

                sum = sum + (((-1)^(l+m))/(factorial(L-l-M+m)*factorial(l-m)))...
                *co(l^2+l+m+1)*((ae/R)^(L-l))*Y_LM;

%                 sum = sum + ((-1)^(l+m)/(factorial(L-l-M+m)*factorial(l-m)))...
%                 *co(l^2+l+m+1)*(1/R)^(l-L)*Y_LM;
        
            end
        end
    end
end

c = (-1)^(L+M)*factorial(L-M)*sum;
end