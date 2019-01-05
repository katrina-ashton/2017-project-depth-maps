load wmri

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
colormap(map)
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
colormap(map)
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