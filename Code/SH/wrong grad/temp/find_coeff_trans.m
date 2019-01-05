function c = find_coeff_trans(co, L, M, v, ae)
sum = 0;
theta = v(1);
phi = v(2);
R = v(3);
for l = 0:L
    for m = -l:l
        if (l-L-m-M) >= 0 && (l-m)>=0
            
            ly = l-L;
            my = -M-m;
            if ly>=0 && ly>= abs(my)

            P_LM = legendre(ly,cos(theta));
            P_LM = P_LM(abs(my)+1,:);
%             N_LM = sqrt((2*ly+1)/(4*pi)*factorial(ly-my)/factorial(ly+my));
%             N_LM = 1./N_LM;
            N_LM = 1;
		
%             if my<0
%                 Y_LM = sqrt(2) * N_LM * P_LM .* sin(abs(my)*phi);
%             elseif my==0
%                 Y_LM = N_LM * P_LM;
%             else		
%                 Y_LM = sqrt(2) * N_LM * P_LM .* cos(my*phi);
%             end

            Y_LM = P_LM*exp(1i*m*phi);

            sum = sum + ((-1)^(l)*factorial(l-m)/(factorial(l-L-m-M)))...
            *co(l^2+l-m+1)*(ae/(ae-R))^l*(R/(ae-R))^(l+1)*Y_LM;
        
            end
        end
    end
end

%c = (-1)^(L+M)*factorial(L-M)*sum;
c = (-1)^(L)/factorial(L+M)*(ae-R)^L*(ae/R)^(L+1)*sum;
end