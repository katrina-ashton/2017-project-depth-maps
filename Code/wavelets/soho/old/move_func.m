function move_func(fb, fm, N, level, nc, fovt, fovp, scale, ...
    p1n, p2n, sse1n, sse2n, varn, uncer, levelm, modflag, resplot)
%n = number of coefficients kept

%Set parameters
platonic_solid = 'octahedron';
basis = 'osh';
fhs = getFunctionHandlesBasis( basis); 


%Generate data points
forest = getForestPlatonicSolid( platonic_solid, level, fhs.enforce_equal_area);
base = sampleSphericalMapF( forest, fb, 3, level, 0);
test = sampleSphericalMapF( forest, fm, 3, level, 0);

forestm = getForestPlatonicSolid( platonic_solid, levelm, fhs.enforce_equal_area);

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
%     [verts_b1,radii_b1] = getT(a1r, level);

    a2r = rotateForest(a2, rot);
%     [verts_b2,radii_b2] = getT(a2r, level);
    
    forest_sampled_m = sampleSphericalMapF( forestm, fm, 3, levelm, 0);
    am = dswtAnalyseFull(forest_sampled_m, levelm, fhs.filters_analysis, fhs.normalize);
    am = dswtSynthesiseFull(am, levelm, fhs.filters_synthesis, fhs.denormalize, 0, 1); 
    forest_sampled_m = rotateForest(am, rot);
    [verts_m,~] = getT(forest_sampled_m, levelm);
%     radii_m = radii_m + uncer*(rand(1,numel(radii_m))-0.5);

    % r = radii_m; %abs?
    x = verts_m(1,:); y=verts_m(2,:); z=verts_m(3,:);
    [phi, theta, ~] = cart2sph(x,y,z);

    thetam = abs(theta-pi/2);
    phim = pi + phi;

    %use getR to find the radii. 
    R_m = getRfromT(thetam,phim,forest_sampled_m, levelm) + ...
        uncer*(rand(1,numel(thetam))-0.5);
    
    R_b1 = getRfromT(thetam,phim,a1r, level);    
    delR1 = scale*(R_m-R_b1);
    
    R_b2 = getRfromT(thetam,phim,a2r,level);    
    delR2 = scale*(R_m-R_b2);
    
%     xp = R_m.*sin(thetam).*cos(phim); 
%     yp = R_m.*sin(thetam).*sin(phim);
%     zp = R_m.*cos(thetam);
%     figure
%     scatter3(xp,yp,zp,'*')
%     xp = R_b1.*sin(thetam).*cos(phim); 
%     yp = R_b1.*sin(thetam).*sin(phim);
%     zp = R_b1.*cos(thetam);
%     figure
%     scatter3(xp,yp,zp,'*')
%     xp = R_b2.*sin(thetam).*cos(phim); 
%     yp = R_b2.*sin(thetam).*sin(phim);
%     zp = R_b2.*cos(thetam);
%     figure
%     scatter3(xp,yp,zp,'*')
%     break
    
    
    times(i+N+1,1) = toc;

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
%     [verts_b1,radii_b1] = getT(a1, level);

    rb1 = getRfromT(thetam, phim, a1, level);    

%     xb1 = rb1.*sin(thetam).*cos(phim); 
%     yb1 = rb1.*sin(thetam).*sin(phim);
%     zb1 = rb1.*cos(thetam);
%     
% 
%     [phi, theta, r] = cart2sph(xb1,yb1,zb1);
% 
%     r1 = r + delR1;
% 
%     [x1, y1, z1] = sph2cart(phi, theta, ones(1,numel(theta)));

    x1 = sin(thetam).*cos(phim); 
    y1 = sin(thetam).*sin(phim);
    z1 = cos(thetam);
    r1 = rb1 + delR1;
    
%     figure
%     scatter3(xb1,yb1,zb1);
%     xp = r1.*x1; yp = r1.*y1; zp = r1.*z1;
%     figure
%     scatter3(xp,yp,zp);
%     invrotep = invrote + [pi, 0, pi];
%     invrotp = eul2rotm(invrotep);
%     p = invrotp*[xp;yp;zp];
%     figure
%     scatter3(p(1,:),p(2,:),p(3,:));
%     break
    
    

    verts1 = [x1; y1; z1];
    radii1 = r1;

    f1 = @(t,p) approxR(t,p,verts1,radii1);

    forest_sampled_1 = sampleSphericalMapF( forest, f1, 3, level, 0);
    
    %find new model
    
    forest_analysed_1 = dswtAnalyseFull( forest_sampled_1, level, ...
                                   fhs.filters_analysis, fhs.normalize);

    % find thresholds so that 512 coefficients are non-zero after approximation
    thresholds = getThresholdLargestK( forest_analysed_1, level, nc, fhs.approx );

    % set all coefficients smaller than 'thresholds' to zero
    forest_approx_1 = approxSWT( forest_analysed_1, level, thresholds, fhs.approx );

    % reconstruct the approximated signal
    a1o = dswtSynthesiseFull( forest_approx_1, level, ...
                                     fhs.filters_synthesis, fhs.denormalize, 0, 1);

    invrote1 = invrote + [pi, 0, pi];
    invrot1 = eul2rotm(invrote1);
    a1 = rotateForest(a1o, invrot1);
        
    sse = get_sse(a1, test, level);
    err_ms(i+1+N+1) = sse;
    end
    
    times(i+N+1,2) = toc;
    
    
    %Input measurements to original model
%     [verts_b2,radii_b2] = getT(a2, level);
    sign2 = sign(delR2);

    xm2 = delR2.*sin(thetam).*cos(phim); 
    ym2 = delR2.*sin(thetam).*sin(phim);
    zm2 = delR2.*cos(thetam);

    meas_align = invrot*[xm2;ym2;zm2];
    xm2 = meas_align(1,:); ym2 = meas_align(2,:); zm2 = meas_align(3,:);

    [phi, theta, rm] = cart2sph(xm2,ym2,zm2);

    theta = abs(theta-pi/2);
    phi = pi + phi;

    rb2 = getRfromT(theta, phi, a2, level);
    r2 = rb2 + sign2.*rm;

%     xm2 = r2.*sin(theta).*cos(phi); 
%     ym2 = r2.*sin(theta).*sin(phi);
%     zm2 = r2.*cos(theta);

%     [phi, theta, ~] = cart2sph(xm2,ym2,zm2);
%     [x2, y2, z2] = sph2cart(phi, theta, ones(1,numel(theta)));

    x2 = sin(theta).*cos(phi); 
    y2 = sin(theta).*sin(phi);
    z2 = cos(theta);

    verts2 = [x2; y2; z2];
    radii2 = r2;

    f2 = @(t,p) approxR(t,p,verts2,radii2);

    forest_sampled_2 = sampleSphericalMapF( forest, f2, 3, level, 0);
    
    forest_analysed_2 = dswtAnalyseFull( forest_sampled_2, level, ...
                                   fhs.filters_analysis, fhs.normalize);

    thresholds = getThresholdLargestK( forest_analysed_2, level, nc, fhs.approx );

    % set all coefficients smaller than 'thresholds' to zero
    forest_approx_2 = approxSWT( forest_analysed_2, level, thresholds, fhs.approx );

    % reconstruct the approximated signal
    a2 = dswtSynthesiseFull( forest_approx_2, level, ...
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