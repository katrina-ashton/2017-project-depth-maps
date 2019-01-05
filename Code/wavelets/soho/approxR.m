function R = approxR(theta, phi, verts, radii)
vx = verts(1,:); vy=verts(2,:); vz=verts(3,:);
x = sin(theta).*cos(phi); 
y = sin(theta).*sin(phi);
z = cos(theta);

N = numel(theta);

R = zeros(numel(theta));
for i = 1:N
    dist = sqrt((vx-x(i)).^2+(vy-y(i)).^2+(vz-z(i)).^2);
    [~, mi] = min(dist);
    R(i) = radii(mi);    
end

end