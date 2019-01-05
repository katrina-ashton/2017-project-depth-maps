function delR = r2delR(X, r, w, n, scale)
theta =X(:,1);
phi = X(:,2);
Rmod = zeros(size(X,1), 1);

for l = 0:n
    rl = angle2Rsph(l, theta, phi); 
    Rmod = Rmod + (w(l^2+1:l^2+2*l+1)'*rl)';
end

delR = scale*(Rmod-r);
end