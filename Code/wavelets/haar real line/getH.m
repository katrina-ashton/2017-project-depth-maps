function H = getH(L)
H = zeros(L/2, L);
for i=1:L/2
    H(i,(i-1)*2+1:(i-1)*2+2) = 1;
end
H = H/sqrt(2);
end