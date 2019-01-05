function sjk = scale(j, k)
sjk = @(t) 0 + ((0<=t)&(t<1));
sjk = @(t)2^(-j/2)*sjk(2^(-j).*t-k);
end