function heatmap_sbf(X, w0, w1, n)
    theta = X(:,1);
    phi = X(:,2);

    r0 = zeros(size(X,1), 1);

    for l = 0:n
        rl = angle2Rsph(l, theta, phi); 
        r0 = r0 + (w0(l^2+1:l^2+2*l+1)'*rl)';
    end
    
    r1 = zeros(size(X,1), 1);

    for l = 0:n
        rl = angle2Rsph(l, theta, phi); 
        r1 = r1 + (w1(l^2+1:l^2+2*l+1)'*rl)';
    end
    
    plot_heatmap_w(X, r0, r1)
    
end