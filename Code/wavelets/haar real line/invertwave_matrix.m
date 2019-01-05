function x = invertwave_matrix(sl,t,m)
    x = zeros(size(t,1),m);
    x(size(t,1),:) = sl;
    for j = (size(t,1)-1):-1:1
        H = getH(m/2^(j-1))';
        G = getG(m/2^(j-1))';
        x(j,1:m/2^(j-1)) = H*x(j+1,1:m/2^j)' + G*t(j+1,1:m/2^j)';
    end
end