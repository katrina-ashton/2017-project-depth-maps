function plot_heatmap_w(X, r0, r1)
    c = r1-r0;
    theta = X(:,1);
    phi = X(:,2);
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
    scatter3(x,y,z, 2, cp, '*');
    
    
%     n = size(X, 1);
%     
%     if mod(n,2)==1
%         x = x(1:end-1);
%         y = y(1:end-1);
%         z = z(1:end-1);
%         cp = cp(1:end-1,:);
%         n = n-1;
%     end
%     
%     X = reshape(x, [n/2, 2]);
%     Y = reshape(y, [n/2, 2]);
%     Z = reshape(z, [n/2, 2]);
%     Cp = reshape(cp, [n/2,2,3]); 
%     
%     figure;
%     h = surf(X,Y,Z,Cp);
%     camlight left
%     camlight right
%     lighting phong
% 
%     alpha(h, 0.5)
%     
%     set(h, 'LineStyle','none')
% 	
%     grid off
    
end