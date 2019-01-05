function move_func(fb, N, level, nc, fovt, fovp, scale, ...
    p1n, p2n, sse1n, sse2n, varn, uncer, modflag, resplot, nmeas, type,ss, varargin)

nvar = numel(varargin);
if nvar < 1
    Rc = 1;
    hc = 2;
elseif nvar < 2
    Rc = varargin{1};
    hc = 2;
else
    Rc = varargin{1};
    hc = varargin{2};
end

%Set parameters
platonic_solid = 'octahedron';
basis = 'osh';
fhs = getFunctionHandlesBasis( basis); 


%Generate data points
forest = getForestPlatonicSolid( platonic_solid, level, fhs.enforce_equal_area);
base = sampleSphericalMapF( forest, fb, 1, level, 0);

if nvar < 1
    test = generate_points(type, [0,0,0], eye(3), 10000, pi, 2*pi, 0);
elseif nvar < 2
    test = generate_points(type, [0,0,0], eye(3), 10000, pi, 2*pi, 0, Rc);
else
    test = generate_points(type, [0,0,0], eye(3), 10000, pi, 2*pi, 0, Rc, hc);
end

%Find initial model using base data
ab = dswtAnalyseFull(base, level, fhs.filters_analysis, fhs.normalize);
thresholds = getThresholdLargestK( ab, level, nc, fhs.approx );
ab = approxSWT( ab, level, thresholds, fhs.approx );
ab = dswtSynthesiseFull(ab, level, fhs.filters_synthesis, fhs.denormalize, 0, 1); 

a1o = ab;
a1 = ab;
a2 = ab;

err_ms = zeros(N+1,1);
err_mm = zeros(N+1,1);

sse = get_sse(ab, test, level);

err_ms(1) = sse;
err_mm(1) = sse;

times = zeros(N, 3);
tic


roto = eye(3);
Oo = [0, 0, 0];
for i = -N:N  
    %step size for update_wavelet
    lr = ss/(nmeas);
    
    %Rotate according to Fibonacci Spiral
    invrat = (1+sqrt(5))/2 -1;
    lat = asin(2*i/(2*N+1));
    lon = 2*pi*i*invrat;
    lon = mod(lon+pi, 2*pi);
    lat = abs(lat-pi/2);
    %opposite rotation 
    invrote = [lon, lat, 0];

    rote = [-invrote(3), -invrote(2), -invrote(1)];
    invrot = eul2rotm(invrote);
    rot = invrot';
    
    %Translate in a loop
%     r = 0.01;
%     ang = 2*pi*i/8;
%     O = [r*cos(ang), r*sin(ang), 0];
    O = [0,0,0];
    
    %get measurements
    a1r = rotateForest(a1o, rot);
    a2r = rotateForest(a2, rot);

    if nvar < 1
        meas = generate_points(type, O, rot, nmeas, fovt, fovp, uncer);
    elseif nvar < 2
        meas = generate_points(type, O, rot, nmeas, fovt, fovp, uncer, Rc);
    else
        meas = generate_points(type, O, rot, nmeas, fovt, fovp, uncer, Rc, hc);
    end
    thetam = meas(:,1)';
    phim = meas(:,2)';
    R_m = meas(:,3)';
   
    %Find the gradients
    
    R_b1 = getRfromT(thetam,phim,a1r, level);    
    delR1 = scale*(R_m-R_b1);
    
    R_b2 = getRfromT(thetam,phim,a2r,level);    
    delR2 = scale*(R_m-R_b2);
    
    times(i+N+1,1) = toc;

    %% moved model method
    if modflag==1
    rotn = rot*roto';
    bn = atan2(sqrt(rotn(3,1)^2+rotn(3,2)^2), rotn(3,3));
    
    if bn == 0
        an = 0;
        gn = atan2(-rotn(1,2), rotn(1,1));
    elseif bn==pi
        an = 0;
        gn = atan2(rotn(1,2), -rotn(1,1));        
    else
        an = atan2(rotn(2,3)/sin(bn), rotn(1,3)/sin(bn));
        gn = atan2(rotn(3,2)/sin(bn), -rotn(3,1)/sin(bn));
    end

    an = an + pi;
    gn = gn + pi;

    roten = [an,bn,gn];
    rotn = eul2rotm(roten);
    
    %Get the transformed forest
    a1 = rotateForest(a1o, rotn);

    x1 = sin(thetam).*cos(phim); 
    y1 = sin(thetam).*sin(phim);
    z1 = cos(thetam);

    for j = 1:numel(thetam)
        a1 = update_wavelet(a1, stri(a1), level, [x1(j);y1(j);z1(j)], delR1(j), [], {}, lr);
    end
    

    %zeroing all except nc coefficients
    thresholds = getThresholdLargestK(a1, level, nc, fhs.approx );
    a1 = approxSWT(a1, level, thresholds, fhs.approx );

    % reconstruct the approximated signal
    a1o = dswtSynthesiseFull( a1, level, ...
                                     fhs.filters_synthesis, fhs.denormalize, 0, 1);

    invrote1 = invrote + [pi, 0, pi];
    invrot1 = eul2rotm(invrote1);
    a1 = rotateForest(a1o, invrot1);
        
    sse = get_sse(a1, test, level);
    err_ms(i+1+N+1) = sse;
    end
    
    times(i+N+1,2) = toc;
    
    
    %% moved measurements method

    sgn = sign(delR2);
    p = new_scoord(thetam', phim', abs(delR2)', O, rot);
    p(:,3) = sgn'.*p(:,3);

    theta = p(:,1)';
    phi = p(:,2)';
    
    x2 = sin(theta).*cos(phi); 
    y2 = sin(theta).*sin(phi);
    z2 = cos(theta);

    for j = 1:numel(theta)
        a2 = update_wavelet(a2, stri(a2), level, [x2(j);y2(j);z2(j)], p(j,3), [], {}, lr);
    end

    %zeroing all except nc coefficients
    thresholds = getThresholdLargestK( a2, level, nc, fhs.approx );
    a2 = approxSWT( a2, level, thresholds, fhs.approx );

    % reconstruct the approximated signal
    a2 = dswtSynthesiseFull( a2, level, ...
                                     fhs.filters_synthesis, fhs.denormalize, 0, 1);
   

    sse = get_sse(a2, test, level);
    err_mm(i+1+N+1) = sse;
    
    times(i+N+1,3) = toc;
    
    roto = rot;
    Oo = O;
end

if modflag==1
    figure;
plotDataFastFull( a1, level, resplot) 
title('Updated model (transform model method)')
xlabel('x')
ylabel('y')
zlabel('z')
saveas(gcf, p1n);
end

figure;
plotDataFastFull( a2, level, resplot) 
title('Updated model (transform measurements method)')
xlabel('x')
ylabel('y')
zlabel('z')
saveas(gcf, p2n);

if modflag==1
figure;
plot(err_ms)
title('Sum-squared Error (transform model method)')
xlabel('Number of camera movements')
ylabel('Sum-squared error of model compared to testing data')
saveas(gcf, sse1n);
end

figure;
plot(err_mm)
title('Sum-squared Error (transform measurements method)')
xlabel('Number of camera movements')
ylabel('Sum-squared error of model compared to testing data')
saveas(gcf, sse2n);


save(varn, 'times', 'a1', 'a2', 'err_ms', 'err_mm', 'base', 'test', 'N');
end