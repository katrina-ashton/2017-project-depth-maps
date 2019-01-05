% add necessary paths to the environment
addpath utility rotation experiments dswt

% basis defined over a partition derived from an octahedron
platonic_solid = 'octahedron';

% other bases are 'bioh', 'pwh' (pseudo Haar), 'bonneau1', ...
basis = 'osh';

% get function handles for basis
fhs = getFunctionHandlesBasis( basis); 

% level -1 on which the input signal is sampled / number of levels over which
% the wavelet transform is performed
level = 4;
nc = 2^10;
% level = 3;
% nc = 64;       

tic;

% construct forest of partition trees
forest = getForestPlatonicSolid( platonic_solid, level, fhs.enforce_equal_area);

% function
%sphere
% f = @(t,p) 1;

%cylinder.
R = 1.5;
H = 3;
f = @(t,p) abs((t<=atan(2*R/H)||t>=pi-atan(2*R/H))*(H/2)/cos(t) ...
    + (t>atan(2*R/H)&&t<=pi/2)*R/cos(pi/2-t) ...
    + (t>pi/2&&t<pi-atan(2*R/H))*R/cos(t-pi/2));

% f = @(t,p) ((abs(t-pi/2)< 0.1) && (abs(p-pi/3)< 0.1)) + 1;

% trans = [0,0,0];
% rote = [pi/4,pi/4,pi/4];
% rot = eul2rotm(rote);
% invrote = [-rote(3), -rote(2), -rote(1)];
% invrot = rot';

%but this also gives you a different t and p...
% fm = @(t,p) new_scoordr(t, p, f(t,p), trans, rot);


% sample signal onto the domains on the finest level of the partition trees
forest_sampled_b = sampleSphericalMapF( forest, f, 1, level, 0);

% perform forward transform
forest_analysed_b = dswtAnalyseFull( forest_sampled_b, level, ...
                                   fhs.filters_analysis, fhs.normalize);

% find thresholds so that 512 coefficients are non-zero after approximation
thresholds = getThresholdLargestK( forest_analysed_b, level, nc, fhs.approx );

% set all coefficients smaller than 'thresholds' to zero
forest_approx_b = approxSWT( forest_analysed_b, level, thresholds, fhs.approx );

% reconstruct the approximated signal
forest_synth_b = dswtSynthesiseFull( forest_approx_b, level, ...
                                 fhs.filters_synthesis, fhs.denormalize, 0, 1);
                             
% forest_synth_b = dswtSynthesiseFull( forest_analysed_b, level, ...
%                                  fhs.filters_synthesis, fhs.denormalize, 0, 1);
                             
plotDataFastFull(forest_synth_b, level, 200); 
xlabel('x');
ylabel('y');
zlabel('z');
grid off;
                             
%add a point
% theta = pi/4;
% phi = pi/6;
% x = sin(theta).*cos(phi); 
% y = sin(theta).*sin(phi);
% z = cos(theta);
% p = [x;y;z];
% delR = 10;
% 
% forest_new = update_wavelet(forest_synth_b, stri(forest_synth_b), level, p, delR, [], {},1);
                             
% %get triangles
% forest_synth_br = rotateForest(forest_synth_b, rot);
% [verts_b,radii_b] = getT(forest_synth_br, level);
% 
% %get measurements
% forest_sampled_m = sampleSphericalMapF( forest, f, 3, level, 0);
% forest_sampled_m = rotateForest(forest_sampled_m, rot);
% [verts_m,radii_m] = getT(forest_sampled_m, level);
% 
% 
% % r = radii_m; %abs?
% x = verts_m(1,:); y=verts_m(2,:); z=verts_m(3,:);
% [phi, theta, ~] = cart2sph(x,y,z);
% 
% thetam = abs(theta-pi/2);
% phim = pi + phi;
% 
% %use getR to find the radii. Once I actually have measurements...
% R_b = getRfromT(thetam,phim,verts_b,radii_b);
% R_m = getRfromT(thetam,phim,verts_m,radii_m);
% delR = R_m-R_b;
% 
% %update moved model method
% forest_synth_br = rotateForest(forest_synth_b, rot);
% [verts_b1,radii_b1] = getT(forest_synth_br, level);
% 
% rb1 = getRfromT(thetam, phim, verts_b1, radii_b1);
% 
% xb1 = rb1.*sin(thetam).*cos(phim); 
% yb1 = rb1.*sin(thetam).*sin(phim);
% zb1 = rb1.*cos(thetam);
% 
% [phi, theta, r] = cart2sph(xb1,yb1,zb1);
% 
% r1 = r + delR;
% 
% [x1, y1, z1] = sph2cart(phi, theta, ones(1,numel(theta)));
% 
% verts1 = [x1; y1; z1];
% radii1 = r1;
% 
% f1 = @(t,p) getRfromT(t,p,verts1,radii1);
% 
% forest_sampled_1 = sampleSphericalMapF( forest, f1, 3, level, 0);
% 
% % plotDataFastF( forest_sampled_1, level) 
% 
% forest_analysed_1 = dswtAnalyseFull( forest_sampled_1, level, ...
%                                    fhs.filters_analysis, fhs.normalize);
% 
% % find thresholds so that 512 coefficients are non-zero after approximation
% thresholds = getThresholdLargestK( forest_analysed_1, level, nc, fhs.approx );
% 
% % set all coefficients smaller than 'thresholds' to zero
% forest_approx_1 = approxSWT( forest_analysed_1, level, thresholds, fhs.approx );
% 
% % reconstruct the approximated signal
% forest_synth_1 = dswtSynthesiseFull( forest_approx_1, level, ...
%                                  fhs.filters_synthesis, fhs.denormalize, 0, 1);
%                              
% forest_synth_1r = rotateForest(forest_synth_1, invrot);
% 
% 
% %update moved measurements method
% [verts_b2,radii_b2] = getT(forest_synth_b, level);
% 
% xm2 = delR.*sin(thetam).*cos(phim); 
% ym2 = delR.*sin(thetam).*sin(phim);
% zm2 = delR.*cos(thetam);
% 
% meas_align = invrot*[xm2;ym2;zm2];
% xm2 = meas_align(1,:); ym2 = meas_align(2,:); zm2 = meas_align(3,:);
% 
% [phi, theta, rm] = cart2sph(xm2,ym2,zm2);
% 
% theta = abs(theta-pi/2);
% phi = pi + phi;
% 
% rb2 = getRfromT(theta, phi, verts_b2, radii_b2);
% r2 = rb2 + rm;
% 
% xm2 = r2.*sin(theta).*cos(phi); 
% ym2 = r2.*sin(theta).*sin(phi);
% zm2 = r2.*cos(theta);
% 
% [phi, theta, ~] = cart2sph(xm2,ym2,zm2);
% [x2, y2, z2] = sph2cart(phi, theta, ones(1,numel(theta)));
% 
% verts2 = [x2; y2; z2];
% radii2 = r2;
% 
% f2 = @(t,p) getRfromT(t,p,verts2,radii2);
% 
% forest_sampled_2 = sampleSphericalMapF( forest, f2, 3, level, 0);
% % figure
% % plotDataFastF( forest_sampled_2, level) 
% 
% forest_analysed_2 = dswtAnalyseFull( forest_sampled_2, level, ...
%                                    fhs.filters_analysis, fhs.normalize);
% 
% thresholds = getThresholdLargestK( forest_analysed_2, level, nc, fhs.approx );
% 
% % set all coefficients smaller than 'thresholds' to zero
% forest_approx_2 = approxSWT( forest_analysed_2, level, thresholds, fhs.approx );
% 
% % reconstruct the approximated signal
% forest_synth_2 = dswtSynthesiseFull( forest_approx_2, level, ...
%                                  fhs.filters_synthesis, fhs.denormalize, 0, 1);


toc;                               
      
% compute error
% [err_l1, err_l2, diff] = getError( forest_synth, forest_sampled, level);
% disp( sprintf( 'L1 error: %f / %f / %f', err_l1(1), err_l1(2), err_l1(3)));
% disp( sprintf( 'L2 error: %f / %f / %f', err_l2(1), err_l2(2), err_l2(3)));

% [~, err_l2, ~] = getError( forest_synth_2, forest_sampled_b, level);
% sum(err_l2)

% display approximated signal
%points/triangles
% plotDataFastF( forest_sampled_b, level) 
% figure
% plotDataFastF(forest_new, level)

%surf (interpolated)
% plotDataFastFull( forest_sampled_b, level, 200) 
% figure
% plotDataFastFull(forest_new, level, 200)
% toc;