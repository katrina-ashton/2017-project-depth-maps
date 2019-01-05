function [base, measurements, test] = generate_points(type, O, rot, nenv, nbase, nmeas, varargin)
if strcmp(type,'cylinder')
    nvar = numel(varargin);
    if nvar < 1
        R = 1;
        h = 1;
    elseif nvar < 2
        R = varargin{1};
        h = 1;
    else
        R = varargin{1};
        h = varargin{2};
    end
    
    Ac = 2*pi*R^2;
    Ar = 2*pi*R*h;

    nr = int32(nenv/((Ac/Ar)+1));
    nc = int32((nenv - nr)/2);
    rrt = rand(nc,1);
    rrt = R*rrt;
    art = rand(nc,1);
    art = 2*pi*art;
    xt = sqrt(rrt).*cos(art);
    yt = sqrt(rrt).*sin(art);
    zt = h/2;
    
    rt = sqrt(xt.^2+yt.^2+zt.^2);
    thetat = acos(zt./rt);
    phit = atan2(xt,yt);
    
    xrr = rand(nr,1);
    xrr = 2*pi*xrr;
    yrr = rand(nr,1);
    yrr = h*yrr - h/2;
    thetar = pi/2 - atan(yrr/R);
    phir = zeros(nr,1);
    for i = 1:nr
        x = xrr(i);
        q = pi*R/2;
        if x<q
            phir(i) = acos((2*R^2-x^2)/(2*R^2));
        elseif x<2*q
            x = x-q;
            phir(i) = acos((2*R^2-x^2)/(2*R^2)) + pi/2;
        elseif x<3*q
            x = x-2*q;
            phir(i) = acos((2*R^2-x^2)/(2*R^2)) + pi;
        else
            x = x-3*q;
            phir(i) = acos((2*R^2-x^2)/(2*R^2)) + 3*pi/2;
        end
    end
    
    st = sin(thetar);
    rr = R./st;
    
    rrb = rand(nc,1);
    rrb = R*rrb;
    arb = rand(nc,1);
    arb = 2*pi*arb;
    xb = sqrt(rrb).*cos(arb);
    yb = sqrt(rrb).*sin(arb);
    zb = -h/2;
    
    rb = sqrt(xb.^2+yb.^2+zb.^2);
    thetab = acos(zb./rb);
    phib = atan2(xb,yb);
    
    theta = [thetat; thetar; thetab];
    phi = [phit; phir; phib];
    r = [rt; rr; rb];
    
    n = nr+2*nc;
    basei = 1:round(double(n)/double(nbase)):n;
    measi = randi([1,n], 1, nmeas);
        
    fulli = 1:n;
    testi = setdiff(fulli, basei);
    testi = setdiff(testi, measi);
    
    base = [theta(basei), phi(basei), r(basei)];
    measurements = [theta(measi), phi(measi), r(measi)];
    measurements = new_scoord(measurements(:,1), measurements(:,2), measurements(:,3), O, rot);
    test = [theta(testi), phi(testi), r(testi)];
    
else
    error('Invalid type. Valid types are: cylinder')
end
end