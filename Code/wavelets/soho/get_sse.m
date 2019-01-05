function sse = get_sse(a, test, level)

% [verts_t,~] = getT(test, level);
% 
% x = verts_t(1,:); y=verts_t(2,:); z=verts_t(3,:);
% [phi, theta, ~] = cart2sph(x,y,z);
% 
% theta = abs(theta-pi/2);
% phi = pi + phi;
% 
% % [verts_a,radii_a] = getT(a, level);

% R_t = getRfromT(theta,phi,test,level);   

theta = test(:,1);
phi = test(:,2);
R_t = test(:,3);

R_a = getRfromT(theta,phi,a,level); 

sse = (R_t-R_a).^2;
sse = mean(sse);

end