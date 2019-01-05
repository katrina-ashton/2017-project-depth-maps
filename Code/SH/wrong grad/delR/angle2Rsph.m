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
N = zeros(l, len);
S = zeros(l, len);
C = zeros(l, len);
N0 = sqrt((2*l+1)/(4*pi));
for m = 1:l
    N(m,:) = repmat(sqrt((2*l+1)/(4*pi)*factorial(l-m)/factorial(l+m)), [1,len]);
    S(m,:) = sin(m*phi);
    C(m,:) = cos(m*phi);
end

if l>0
R0 = sqrt(2)*N.*P(2:end,:).*S;
R1 = N0.*P(1,:);
R2 = sqrt(2)*N.*P(2:end,:).*C;
R = [flipud(R0); R1; R2];
else
R = N0.*P;
end
end