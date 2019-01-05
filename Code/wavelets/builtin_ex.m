p = generate_points('cylinder', [0,0,0], [1,0,0;0,1,0;0,0,1], 50000, pi, 2*pi, 0);
theta = p(:,1);
phi = p(:,2);
r = p(:,3);
[x,y,z] = sph2cart(phi, pi/2-theta, r);
p = [x,y,z];

%Now need to convert to indexed image format
minx = -1.1;
maxx = 1.1;
miny = minx;
maxy = maxx;
minz = minx;
maxz = maxx;

thresh = 0.01;

X = zeros(128,128,27);
for xi = 1:128
    x = minx + (xi-1)*(maxx-minx)/127;
    for yi = 1:128
        y = miny + (yi-1)*(maxy-miny)/127;
        for zi = 1:27
            z = minz + (zi-1)*(maxz-minz)/26;
            diff = min(sqrt((p(:,1)-x).^2 + (p(:,2)-y).^2 + (p(:,3)-z).^2));

            if diff < thresh
                X(xi,yi,zi) = 1;
            end
        end
    end
end


%MATLAB example code:
n = 3;                   % Decomposition Level
w = 'sym4';              % Near symmetric wavelet
WT = wavedec3(X,n,w);    % Multilevel 3D wavelet decomposition.

A = cell(1,n);
D = cell(1,n);
for k = 1:n
    A{k} = waverec3(WT,'a',k);   % Approximations (low-pass components)
    D{k} = waverec3(WT,'d',k);   % Details (high-pass components)
end

err = zeros(1,n);
for k = 1:n
    E = double(X)-A{k}-D{k};
    err(k) = max(abs(E(:)));
end
disp(err)

figure('DefaultAxesXTick',[],'DefaultAxesYTick',[],...
        'DefaultAxesFontSize',8,'Color','w')
XR = X;
Ds = smooth3(XR);
hiso = patch(isosurface(Ds,5),'FaceColor',[1,.75,.65],'EdgeColor','none');
hcap = patch(isocaps(XR,5),'FaceColor','interp','EdgeColor','none');
daspect(gca,[1,1,.4])
lightangle(305,30);
fig = gcf;
fig.Renderer = 'zbuffer';
lighting phong
isonormals(Ds,hiso)
hcap.AmbientStrength = .6;
hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 50;
ax = gca;
ax.View = [215,30];
ax.Box = 'On';
axis tight
title('Original Data');

figure('DefaultAxesXTick',[],'DefaultAxesYTick',[],...
        'DefaultAxesFontSize',8,'Color','w')
XR = A{2};
Ds = smooth3(XR);
hiso = patch(isosurface(Ds,5),'FaceColor',[1,.75,.65],'EdgeColor','none');
hcap = patch(isocaps(XR,5),'FaceColor','interp','EdgeColor','none');
daspect(gca,[1,1,.4])
lightangle(305,30);
fig = gcf;
fig.Renderer = 'zbuffer';
lighting phong
isonormals(Ds,hiso)
hcap.AmbientStrength = .6;
hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 50;
ax = gca;
ax.View = [215,30];
ax.Box = 'On';
axis tight
title('Approximation at level 2');