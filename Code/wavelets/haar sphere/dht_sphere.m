function [coeff1, coeff2, coeff3, scoeff] = dht_sphere(fs, jmax, n)
scoeff = zeros(m, n, jmax);
coeff1 = zeros(m, n, jmax);
coeff2 = zeros(m, n, jmax);
coeff3 = zeros(m, n, jmax);
scoeff(:,:,1) = fs;

%this isn't right... Need to do each triangle one at a time.
for j = 2:jmax
    [a0,a1,ap] = getArea(scoeff(1:m/2^(j-2), 1:n/2^(j-2), j-1));
    S = getS(a0,a1,ap);
    nv = (S')*(scoeff(1:m/2^(j-2), 1:n/2^(j-2), j-1)');
    scoeff(1:m/2^(j-1), 1:n/2^(j-1), j) = nv(1);
    coeff1(1:m/2^(j-1), 1:n/2^(j-1), j) = nv(2);
    coeff2(1:m/2^(j-1), 1:n/2^(j-1), j) = nv(3);
    coeff3(1:m/2^(j-1), 1:n/2^(j-1), j) = nv(4);
end
end