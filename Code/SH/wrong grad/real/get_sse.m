function sse = get_sse(w, n, test)
theta = test(:,1);
phi = test(:,2);
r = test(:,3);
R = zeros(size(r,1), 1);
for l = 0:n
    rl = angle2Rsph(l, theta, phi); 
    R = R + (w(l^2+1:l^2+2*l+1)'*rl)';
end

sse = (r-R).^2;
sse = sum(sse);

end