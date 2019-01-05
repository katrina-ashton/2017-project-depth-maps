function c = find_coeff_trans(co, L, M, v, ae)
sum = 0;
for l = 0:L
    for m = -l:l
        if (L-l) >= abs(m-M)
            theta = v(1);
            phi = v(2);
            R = v(3);
            ly = L-l;
            my = m-M;

            P_LM = legendre(ly,cos(theta));
            P_LM = P_LM(abs(my)+1,:);
		
            if my<0
                Y_LM = sqrt(2) * P_LM .* sin(abs(my)*phi);
            elseif my==0
                Y_LM = P_LM;
            else		
                Y_LM = sqrt(2) * P_LM .* cos(my*phi);
            end

            sum = sum + ((-1)^(l+m)/(factorial(L-l-M+m)*factorial(l-m)))...
            *co(l^2+l+m+1)*(ae/R)^(l-L)*Y_LM;
        end
    end
end

c = (-1)^(L+M)*factorial(L-M)*sum;
end