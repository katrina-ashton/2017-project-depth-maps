function w = sc2sbf_slr(Xn, tn, n, wo, lr, lam)
%X contains the theta and phi values, one set of values in each row
%t contains the corresponding r values
theta =transpose(Xn(:,1));
phi = transpose(Xn(:,2));
Phi = zeros(size(Xn,1), (n+1)^2);

for l=0:n
    for m=-l:l
        R = sbf(l, m, theta, phi);
        Phi(:,l^2+l+m+1) = R;
    end
end

Phi = Phi';

w = wo - lr*((wo'*Phi-tn)*Phi-lam*wo);


end
