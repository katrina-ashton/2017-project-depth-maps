function dlmk = d(l, m, k, beta)
sum = 0;
for s = 0:(l+abs(m))
   if (l-m-s)<0 || (l+k-s)<0 || (m-k+s)<0
       continue
   end
   denom = factorial(s)*factorial(l-m-s)*factorial(l+k-s)*factorial(m-k+s);
   sum = sum + (-1)^(s)*cos(beta/2)^(2*(l-s)-m+k)*sin(beta/2)^(2*s+m-k)/denom;
end

dlmk = (-1)^(m-k)*sqrt(factorial(l+k)*factorial(l-k)*factorial(l+m)*factorial(l-m))*sum;
end