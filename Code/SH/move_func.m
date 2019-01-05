function move_func(typeb, typem, R0, h0, R, h, N, n, fovt, fovp, scale, ...
    p1n, p2n, sse1n, sse2n, varn, uncer, nmeas, modflag)
%Set parameters
%Number of points
ntest = 10000;
nbase = 10000;
npc = 10^5;
%n = 40;
lam = 0.1;
lr = 10^(-3);
resplot = 150;

%Generate data points
base = generate_points(typeb, [0,0,0], eye(3), nbase, pi, 2*pi, 0, R0, h0);
test = generate_points(typem, [0,0,0], eye(3), ntest, pi, 2*pi, 0, R, h);
pceb = generate_points(typem, [0,0,0], eye(3), npc, pi, 2*pi, 0, R, h);

%Find initial model using base data
wb = getweights_initial(base(:,1:2), base(:,3), n, lam);

w1o = wb;
w1 = wb;
w2 = wb;

err_ms = zeros(N+1,1);
err_mm = zeros(N+1,1);

sse = get_sse(wb, n, test);
sse = sse/size(test,1);

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
    
    pce = new_scoord(pceb(:,1), pceb(:,2), pceb(:,3), O, rot);
    pcm1 = generate_mp(w1, n, npc, uncer, O, rot);
    pcm2 = generate_mp(w2, n, npc, uncer, O, rot);
    [thetam, phim] = getuniformdir(nmeas, fovt, fovp, 'cylinder', O, rot, R, h);
    meas1 = generate_grads(pce, pcm1, thetam, phim, scale);
    meas2 = generate_grads(pce, pcm2, thetam, phim, scale);
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
    gn = gn+pi;

    roten = [an,bn,gn];
    
    %Get the transformed weights
    w1 = transform_weights(w1o, n, roten);
    

    %Input measurements to transformed model
    r1 = meas1(:,3) + angle2Rsphfull(w1, n, meas1(:,1), meas1(:,2));
    w1 = grad_descent(meas1(:,1:2), r1, n, w1, lr);
    w1o = w1;
        
    w1 = transform_weights(w1, n, invrote + [pi, 0, pi]);
    
    
    sse = get_sse(w1, n, test);
    sse = sse/size(test,1);
    err_ms(i+1+N+1) = sse;
    end
    
    times(i+N+1,2) = toc;
    
    
    %Input measurements to original model
    [X, r2] = mm(meas2, w2, n, invrot, -O);
    
%     ms = [X, r2];
%     plot_sbf(w2, n, resplot);
%     plot_points(ms);
    
    w2 = grad_descent(X, r2, n, w2, lr);
   

    sse = get_sse(w2, n, test);
    sse = sse/size(test,1);
    err_mm(i+1+N+1) = sse;
    
    times(i+N+1,3) = toc;
    
    roto = rot;
    Oo = O;
end

if modflag==1
plot_sbf(w1, n, resplot);
title('Updated model (transform model method)')
xlabel('x')
ylabel('y')
zlabel('z')
saveas(gcf, p1n);
end

plot_sbf(w2, n, resplot);
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


save(varn, 'times', 'w1', 'w2', 'err_ms', 'err_mm', 'base', 'test', 'N');
end