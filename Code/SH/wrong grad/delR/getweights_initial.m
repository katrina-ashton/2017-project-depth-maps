function [w,R] = getweights_initial(X, r, n, lam)
%getweights_initial takes
%   X= [theta, phi] measurement directions
%   r= coressponding radii
%   n = maximum order of basis functions
%   lam = regularisation constant
theta =X(:,1);
phi = X(:,2);
R = zeros(size(X,1), (n+1)^2);

for l=0:n
    R(:,l^2+1:l^2+2*l+1) = angle2Rsph(l, theta, phi)';
end
w = (lam*eye((n+1)^2) + R'*R)\(R'*r);
end