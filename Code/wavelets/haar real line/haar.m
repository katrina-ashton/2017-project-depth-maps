function Ht = haar(t, j, k)
x = 2^j*t-k;
if x >= 0 && x < 1/2
    Ht = 1;
elseif x>=1/2 && x<=1
    Ht = -1;
else
    Ht = 0;
end
Ht = 2^(j/2)*Ht;
end