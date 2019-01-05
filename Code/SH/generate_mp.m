function points = generate_mp(w, nm, n, uncer, t, rot)
    
    delta = pi/sqrt(n);
    theta = 0:delta:pi;
    phi = 0:2*delta:2*pi;
    
    [phi,theta] = meshgrid(phi,theta);
    N = numel(theta);
    theta = reshape(theta, [N, 1]);
    phi = reshape(phi, [N, 1]);
    
    %radius is point on the model
    r = angle2Rsphfull(w,nm, theta, phi);
       
    %uncertainty
    r = r + (uncer*rand(numel(r),1)-uncer/2);
    
    points = new_scoord(theta,phi,r,t,rot);

end