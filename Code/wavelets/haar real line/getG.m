function G = getG(L)
G = zeros(L/2, L);
for i=1:L/2
    G(i,(i-1)*2+1) = 1;
    G(i,(i-1)*2+2) = -1;
end
G = G/sqrt(2);
end