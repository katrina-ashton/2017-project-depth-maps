function w = transform_weights(wo, n, rot)
w = wo;
for l = 0:n
    wo = w;
    for m = -l:l
        i = l^2+l+m+1;
        w(i) = find_coeff_rot(wo, l, m, rot);
    end

end
end