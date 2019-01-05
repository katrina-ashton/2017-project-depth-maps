function w = transform_weights(wo, n, v)
w = zeros(size(wo, 1), 1);
%Get the average weight (abs) and invert
ae = (n+1)^2/sum(abs(wo)); %Mean equitorial radius
for l = 0:n
    for m = -l:l
        i = l^2+l+m+1;
        w(i) = find_coefficient(wo, l, m, v, ae);
    end
end
end