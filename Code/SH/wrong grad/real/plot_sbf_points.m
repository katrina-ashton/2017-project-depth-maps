function plot_sbf_points(X, rx, w, n, res)
    delta = pi/res;
    theta = 0:delta:pi;
    phi = 0:2*delta:2*pi;
    [phi,theta] = meshgrid(phi,theta);
    N = numel(theta);
    M = size(theta, 1);
    theta = reshape(theta, [N, 1]);
    phi = reshape(phi, [N, 1]);
    R = zeros(N,1);
    
    for l = 0:n
        r = angle2Rsph(l, theta, phi); 
        R = R + (w(l^2+1:l^2+2*l+1)'*r)';
    end
    
    figure
    hold on
    %Plot points
    theta_p = X(:,1);
    phi_p = X(:,2);
    x = abs(rx).*sin(theta_p).*cos(phi_p); 
    y = abs(rx).*sin(theta_p).*sin(phi_p);
    z = abs(rx).*cos(theta_p);
    scatter3(x,y,z, '*', 'filled', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')

    
    r = abs(R);	
    x = r.*sin(theta).*cos(phi); 
    y = r.*sin(theta).*sin(phi);
    z = r.*cos(theta);
    
    x = reshape(x, [M,M]);
    y = reshape(y, [M,M]);
    z = reshape(z, [M,M]);
    r = reshape(r, [M,M]);
    
    h = surf(x,y,z,r);
    
    camlight left
    camlight right
    lighting phong

    alpha(h, 0.5)

	
    % map positive regions to red, negative regions to green
    colormap(redgreencmap([2]))
    set(h, 'LineStyle','none')
	
    grid off
    
end