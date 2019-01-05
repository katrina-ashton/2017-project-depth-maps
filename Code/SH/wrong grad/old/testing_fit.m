for i=1:size(t,1)
    sum = 0;
    for l=0:n
        for m=-l:l
            sum = sum + w(l^2+l+m+1)*sbf(l, m, X(i,1), X(i,2));
        end
    end
    disp(sum)
end
