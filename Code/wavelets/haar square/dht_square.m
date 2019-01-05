function [coeff1, coeff2, coeff3, scoeff] = dht_square(fs, jmax, m, n)

scoeff = zeros(m, n, jmax);
coeff1 = zeros(m, n, jmax);
coeff2 = zeros(m, n, jmax);
coeff3 = zeros(m, n, jmax);
scoeff(:,:,1) = fs;

for j = 2:jmax
    scoeff(1:m/2^(j-1), 1:n/2^(j-1), j) = Hcol(Hrow(scoeff(1:m/2^(j-2), 1:n/2^(j-2), j-1)));
    coeff1(1:m/2^(j-1), 1:n/2^(j-1), j) = Gcol(Hrow(scoeff(1:m/2^(j-2), 1:n/2^(j-2), j-1)));
    coeff2(1:m/2^(j-1), 1:n/2^(j-1), j) = Hcol(Grow(scoeff(1:m/2^(j-2), 1:n/2^(j-2), j-1)));
    coeff3(1:m/2^(j-1), 1:n/2^(j-1), j) = Gcol(Grow(scoeff(1:m/2^(j-2), 1:n/2^(j-2), j-1)));
end
end