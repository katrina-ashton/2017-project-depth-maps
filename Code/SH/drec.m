function dlmk = drec(n, cb, s2b2, r2sb, c2b2,tb2)
mid = n+1;
dlmk = nan(n+1, 2*n+1, 2*n+1);
dlmk(1,:,:) = 0;
dlmk(1,mid,mid) = 1;
dlmk(2, mid, mid) = cb;
dlmk(2,mid+1,mid-1) = s2b2;
dlmk(2,mid+1,mid) = -r2sb;
dlmk(2,mid+1,mid+1) = c2b2;

dlmk(2, mid, mid-1) = -r2sb;
dlmk(2, mid, mid+1) = r2sb;

for l = 2:n
    for m = 0:l-2
        for k = -m:m
            p1 = (l*(2*l-1))/sqrt((l^2-m^2)*(l^2-k^2));
            p2 = (cb-(m*k)/(l*(l-1)))*dlmk(l,mid+m,mid+k)...
                -sqrt(((l-1)^2-m^2)*((l-1)^2-k^2))/((l-1)*(2*l-1))...
                *dlmk(l-1,mid+m,mid+k);
            dlmk(l+1, mid+m, mid+k) = p1*p2;
        end
    end
    dlmk(l+1,mid+l,mid+l) = cb*dlmk(l,mid+l-1,mid+l-1);
    dlmk(l+1,mid+l-1,mid+l-1) = (l*cb-l+1)*dlmk(l,mid+l-1,mid+l-1);
    
    
    for i=1:2*l
        m = l-i+1;
        dlmk(l+1,mid+l,mid+m-1) = -sqrt((l+m)/(l-m+1))...
            *tb2*dlmk(l+1,mid+l,mid+m);
    end
    for i=2:2*l-1
        m = l-i+1;
        dlmk(l+1,mid+l-1,mid+m-1) = -(l*cb-m-i+2)/(l*cb-m-i+1)...
            *sqrt((l+m)/(l-m+1))*tb2*dlmk(l+1,mid+l-1,mid+m);
    end
    
    dlmk(l+1,mid+l-1,mid+l) = -dlmk(l+1,mid+l,mid+l-1);
    dlmk(l+1,mid+l-1,mid-l) = dlmk(l+1,mid+l,mid+1-l);
    
    for x=-l:l
        t=1;
        if x>0
            t=(-1)^x;
        end
       dlmk(l+1,mid,mid+x) = t*dlmk(l+1,mid+abs(x),mid);
    end
    
    
    for x=0:l-2
        for y = -l:l
            if y<0
                dlmk(l+1,mid+x,mid+y) = dlmk(l+1,mid+abs(y),mid-x);
            else
                dlmk(l+1,mid+x,mid+y) = (-1)^(x+y)*dlmk(l+1,mid+y,mid+x);
            end
        end
    end
    
end

end