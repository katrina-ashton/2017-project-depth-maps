function [coeff, scoeff] = dht_matrix(fs, jmax, m)

scoeff = zeros(jmax+1, m);
coeff = zeros(jmax+1, m);
scoeff(1,:) = fs;


for j = 1:jmax
    H = getH(m/2^(j-1));
    G = getG(m/2^(j-1));
    scoeff(j+1, 1:m/2^j)=H*scoeff(j, 1:m/2^(j-1))';
    coeff(j+1, 1:m/2^j) = G*scoeff(j, 1:m/2^(j-1))';
end
end