function x = invertwavelast(s,t,j,m)
    x = zeros(1,m);
    while j > 0
    for k = 0:m-1
        if mod(k,2)==0
            x(1,k+1) = (s(k/2+1) + t(j,k/2+1))/sqrt(2);
        else
            x(1,k+1) = (s((k-1)/2+1) - t(j,(k-1)/2+1))/sqrt(2);
        end
        s = x;
    end
    end
end