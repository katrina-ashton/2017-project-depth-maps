function R = angle2Rsph(l, theta, phi)
%angle2Rsph takes 
%   l= degree of spherical harmonic
%   theta = matrix of theta (polar angle) values
%   phi = matrix of corresponding phi (azimuthal angle) values
%and returns 
%   R= matrix of corresponding radial distance values for order m =-l:l
%   The orders vary along the rows, and theta and phi values vary along the
%   columns

len = size(theta, 1);
P = legendre(l,cos(theta));

E = zeros(l, len);

for m = 1:l
    E(m,:) = 1i*m*phi;
end

if l>0
R0 = P(2:end,:).*exp(-E);
R1 = P(1,:);
R2 = P(2:end,:).*exp(E);
R = [flipud(R0); R1; R2];
else
R = P;
end
end