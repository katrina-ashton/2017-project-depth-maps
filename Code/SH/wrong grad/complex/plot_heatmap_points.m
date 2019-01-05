function plot_heatmap_points(X, w0, w1, n, Xrp)
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
    
    c = r1-r0;
    r = abs(r1);	
    x = r.*sin(theta).*cos(phi); 
    y = r.*sin(theta).*sin(phi);
    z = r.*cos(theta);

    
    cm = jet(50);
    c = c-min(c);
    if max(c) > 0
        c = c*49/max(c);
    end
    c = c+1;
    c = int32(c);

    cp = cm(c,:);
       
    figure;
    scatter3(x,y,z, 2, cp, '*'); hold on

    thetap = Xrp(:,1);
    phip = Xrp(:,2);
    rp = Xrp(:,3);
    x = abs(rp).*sin(thetap).*cos(phip); 
    y = abs(rp).*sin(thetap).*sin(phip);
    z = abs(rp).*cos(thetap);
    scatter3(x,y,z, 1, 'k', '*')
end