function R = angle2Rsphfull(w,n, theta, phi)
    N = numel(theta);
    R = zeros(N,1);
    
    for l = 0:n
        r = angle2Rsph(l, theta, phi); 
        R = R + (w(l^2+1:l^2+2*l+1)'*r)';
    end

end