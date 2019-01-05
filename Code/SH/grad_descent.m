function [w, R] = grad_descent(X, t, n, w, lr)
%X contains the theta and phi values, one set of values in each row
%t contains the corresponding r values
theta = X(:,1);
phi = X(:,2);
R = zeros(size(X,1), (n+1)^2);

for l=0:n
    R(:,l^2+1:l^2+2*l+1) = angle2Rsph(l, theta, phi)';
end

w = w - lr*(R'*(R*w-t));

end