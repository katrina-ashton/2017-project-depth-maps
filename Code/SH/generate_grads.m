function grads = generate_grads(pce, pcm, theta, phi, scale)
    %radius_e and radius_m are given by closest point in each cloud
    %r is the difference (delR)
    r = zeros(numel(phi), 1);
    
    for i = 1:numel(theta)
        [~,ie] = min((pce(:,1)-theta(i)).^2+(pce(:,2)-phi(i)).^2);
        re = pce(ie, 3);
        [~,im] = min((pcm(:,1)-theta(i)).^2+(pcm(:,2)-phi(i)).^2);
        rm = pcm(im, 3);
        r(i) = re-rm;
    end
    
    
    %uncertainty
    r = scale*r;
    
    grads = [theta, phi, r];      

end