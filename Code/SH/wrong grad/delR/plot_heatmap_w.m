function plot_heatmap_w(X, r0, r1)
    c = r1-r0;
    theta = X(:,1);
    phi = X(:,2);
    r = abs(r0);	
    x = r.*sin(theta).*cos(phi); 
    y = r.*sin(theta).*sin(phi);
    z = r.*cos(theta);
    
    h = surf([x,y,z],c);
    camlight left
    camlight right
    lighting phong

    alpha(h, 0.5)
end