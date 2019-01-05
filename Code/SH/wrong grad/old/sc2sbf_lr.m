function w = sc2sbf_lr(X, t, n, lam)
%X contains the theta and phi values, one set of values in each row
%t contains the corresponding r values
theta =transpose(X(:,1));
phi = transpose(X(:,2));
Phi = zeros(size(X,1), (n+1)^2);

for l=0:n
    for m=-l:l
        R = sbf(l, m, theta, phi);
        Phi(:,l^2+l+m+1) = R;
    end
end
w = (lam*eye((n+1)^2) + transpose(Phi)*Phi)\(transpose(Phi)*t);
end