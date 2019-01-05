function Hjk = wavefunh(j, k, a0, b0)
%Hjk = @(t)piecewise(0<=t<0.5, 1, 0.5<=t<=1, -1, 0);
Hjk = @(t) 0 + ((0<=t)&(t<0.5))*1 - ((0.5<t)&(t<=1));
Hjk = @(t)Hjk((t-k*b0*a0^j)/a0^j)/sqrt(a0^j);
end