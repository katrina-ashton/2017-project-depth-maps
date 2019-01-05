function c = find_coeff_trans(co, L, M, v, ae,n)
sum = 0;
theta = v(1);
phi = v(2);
R = v(3);
for l = 0:n
    for m = -l:l
        if (l-L-M+m) >= 0 && (l-m)>=0
            
            ly = L-l;
            my = m-M;
            if ly>=0 && ly>= abs(my)

            P_LM = legendre(ly,sin(theta));
            P_LM = P_LM(abs(my)+1,:);
%             N_LM = sqrt((2*ly+1)/(4*pi)*factorial(ly-my)/factorial(ly+my));
%             N_LM = 1./N_LM;
            N_LM = 1;
		
            if my<0
                Y_LM = sqrt(2) * N_LM * P_LM .* sin(abs(my)*phi);
            elseif my==0
                Y_LM = N_LM * P_LM;
            else		
                Y_LM = sqrt(2) * N_LM * P_LM .* cos(my*phi);
            end

            sum = sum + ((-1)^(l+m)/(factorial(l-L-M+m)*factorial(l-m)))...
            *co(l^2+l+m+1)*(ae/R)^(l-L)*Y_LM;
        
            end
        end
    end
end

c = (-1)^(L+M)*factorial(L-M)*sum;
end