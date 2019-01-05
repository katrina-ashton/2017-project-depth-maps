function Hjk = Hjk(j, k)
%Hjk = @(t)piecewise(0<=t<0.5, 1, 0.5<=t<=1, -1, 0);
Hjk = @(t) 0 + ((0<=t)&(t<0.5))*1 + ((0.5<t)&(t<=1))*(-1);
Hjk = @(t)2^(j/2)*Hjk(2^(j).*t-k);
end