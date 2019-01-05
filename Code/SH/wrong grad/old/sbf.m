function Y_LM = sbf(L, M, theta, phi)
% Uses code from spharmPlot:
% Written by Mengliu Zhao, School of Computing Science, Simon Fraser University
% Update Date: 2014/Dec/03

% Legendre polynomials
P_LM = legendre(L,cos(theta));
P_LM = P_LM(abs(M)+1,:);

% normalization constant
N_LM1 = sqrt((2*L+1)/(4*pi));
N_LM2 = sqrt(factorial(L-abs(M))/factorial(L+abs(M)));

% base spherical harmonic function
if M<0
    Y_LM = sqrt(2) * N_LM1 * N_LM2 * P_LM .* sin(abs(M)*phi);
elseif M==0
    Y_LM = N_LM1*P_LM;
else		
    Y_LM = sqrt(2) * N_LM1 * N_LM2 * P_LM .* cos(M*phi);
end


end