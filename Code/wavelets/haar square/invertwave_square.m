function x = invertwave_square(sl,t1,t2,t3,m,n)
    x = zeros(m, n, size(t1,3));
    x(:,:,size(t1,3)) = sl;
    for j = (size(t1,3)-1):-1:1
        x(1:m/2^(j-1), 1:n/2^(j-1),j) = Hrow_adj(Hcol_adj(x(1:m/2^j, 1:n/2^j,j+1))) + ...
            Hrow_adj(Gcol_adj(t1(1:m/2^j, 1:n/2^j,j+1))) + ...
            Grow_adj(Hcol_adj(t2(1:m/2^j, 1:n/2^j,j+1))) + ...
            Grow_adj(Gcol_adj(t3(1:m/2^j, 1:n/2^j,j+1)));
    end
end