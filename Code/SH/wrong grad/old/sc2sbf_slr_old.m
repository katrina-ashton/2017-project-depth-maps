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

%unregularised
%w = wo - lr*(tn - wo'*Phi')*Phi';

options = optimoptions('fminunc','Algorithm','quasi-newton','SpecifyObjectiveGradient',true);
x0 = wo;
fun = @(w)error_with_grad(Phi, tn, w, lam, lr);
w = fminunc(fun,x0,options);

end

function sig = sigmoid(a)
sig = 1/(1+exp(-a));
end

function reg = quadreg(w)
reg = 0.5*(w'*w);
end

function E = error(X, t, w, lam)
y = sigmoid(w'*X')';

logy = log(y);
logy(isinf(logy)) = 0;
log1y = log(1-y);
logy(isinf(log1y)) = 0;
    
err = t'*logy + (1-t)'*log1y;
E = -err + lam*quadreg(w);
end

function grad = gradE(X, t, w, lam)
y = sigmoid(w'*X')';
err = (y-t)'*X;
grad = err' + lam*w;
end

function [E, grad] = error_with_grad(X, t, w, lam, lr)
E = error(X, t, w, lam);
grad = lr*gradE(X, t, w, lam);
end