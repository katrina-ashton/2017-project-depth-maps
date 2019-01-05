function [coeff, scoeff] = dht(fs, jmax, m)

scoeff = zeros(jmax+1, m);
coeff = zeros(jmax+1, m);
scoeff(1,:) = fs;

for j = 1:jmax
    for n = 0:m/(2*j)-1
        sn = (scoeff(j, 2*n+1) + scoeff(j, 2*n+2))/sqrt(2);
        tn = (scoeff(j, 2*n+1) - scoeff(j, 2*n+2))/sqrt(2);
        scoeff(j+1,n+1)=sn;
        coeff(j+1, n+1) = tn;
    end
end
end