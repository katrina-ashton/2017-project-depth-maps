function x = invertwave(sl,t,m)
    x = zeros(size(t,1),m);
    x(size(t,1),:) = sl;
    for j = (size(t,1)-2):-1:0
        for k = 0:m-1
            if mod(k,2)==0
                x(j+1,k+1) = (x(j+2,k/2+1) + t(j+2,k/2+1))/sqrt(2);
            else
                x(j+1,k+1) = (x(j+2,(k-1)/2+1) - t(j+2,(k-1)/2+1))/sqrt(2);
            end
        end
    end
end