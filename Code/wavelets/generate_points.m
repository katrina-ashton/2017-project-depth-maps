function points = generate_points(type, O, rot, n, fovt, fovp, uncer, varargin)
if strcmp(type,'cylinder')
    nvar = numel(varargin);
    if nvar < 1
        R = 1;
        h = 2;
    elseif nvar < 2
        R = varargin{1};
        h = 2;
    else
        R = varargin{1};
        h = varargin{2};
    end
    
    Ac = 2*pi*R^2;   %Area of circles (top and bottom)
    Ar = 2*pi*R*h;   %Area of rectangle (side)

    nr = int32(n/((Ac/Ar)+1)); %Number of points in rectangle
    nc = int32((n - nr)/2);    %Number of points in each circle
    rrt = rand(nc,1);             %radius (random)
    rrt = R^2*rrt;                %Scale up 
    art = rand(nc,1);
    art = 2*pi*art;
    xt = sqrt(rrt).*cos(art);
    yt = sqrt(rrt).*sin(art);
    zt = h/2;
    
    rt = sqrt(xt.^2+yt.^2+zt.^2);
    thetat = acos(zt./rt);
    phit = atan2(xt,yt);
    
    xrr = rand(nr,1);
    xrr = 2*pi*R*xrr;
    yrr = rand(nr,1);
    yrr = h*yrr - h/2;
    thetar = pi/2 - atan(yrr/R);
    phir = xrr/R;
    
    st = sin(thetar);
    rr = R./st;
    
    rrb = rand(nc,1);
    rrb = R^2*rrb;
    arb = rand(nc,1);
    arb = 2*pi*arb;
    xb = sqrt(rrb).*cos(arb);
    yb = sqrt(rrb).*sin(arb);
    zb = -h/2;
    
    rb = sqrt(xb.^2+yb.^2+zb.^2);
    thetab = acos(zb./rb);
    phib = atan2(xb,yb);
    
    %Make pit and phib go from 0 to 2pi instead of -pi to pi
    phit = pi + phit;
    phib = pi+phib;
    
    theta = [thetat; thetar; thetab];
    phi = [phit; phir; phib];
    r = [rt; rr; rb];
    
elseif strcmp(type,'sphere')
    nvar = numel(varargin);
    if nvar < 1
        R = 1;
    else
        R = varargin{1};
    end
    
    delta = pi/sqrt(n);
    theta = 0:delta:pi;
    phi = 0:2*delta:2*pi;
    
    [phi,theta] = meshgrid(phi,theta);
    N = numel(theta);
    theta = reshape(theta, [N, 1]);
    phi = reshape(phi, [N, 1]);
    
    r = R*ones(N, 1);
    

elseif strcmp(type,'spherep')
    nvar = numel(varargin);
    if nvar < 1
        R = 1;
    else
        R = varargin{1};
    end
    
    delta = pi/sqrt(n);
    theta = 0:delta:pi;
    phi = 0:2*delta:2*pi;
    
    [phi,theta] = meshgrid(phi,theta);
    N = numel(theta);
    theta = reshape(theta, [N, 1]);
    phi = reshape(phi, [N, 1]);
    
    r = R*ones(N,1) + rand(N, 1)/100;
    
else
    error('Invalid type. Valid types are: cylinder, sphere')
end
    
    %Combine into points array and match rotation, translation and fov
      
    points = [theta, phi, r];  
    
    points = new_scoord(points(:,1), points(:,2), points(:,3), O, rot);
    
    theta = points(:,1);
    phi = points(:,2);
    r = points(:,3);
    
    %theta = pi/2 is center of camera
    fovti = find(abs(theta-pi/2)<= fovt/2);
    %phi = pi is center of the camera to make it easier to find (instead of
    %0)
    fovpi = find(abs(phi-pi)<= fovp/2);

    fovi = intersect(fovti, fovpi);
    theta = theta(fovi);
    phi = phi(fovi);
    r = r(fovi);
    r = r + (uncer*rand(numel(r),1)-uncer/2);
    
    points = [theta, phi, r];  
    

end