n = 40;
rote = [3.4,0.7297,1];
alpha = rote(1);
beta = rote(2);
gamma = rote(3);

cb = cos(beta); 
s2b2 = sin(beta/2)^2; 
r2sb = sin(beta)/sqrt(2); 
c2b2 = cos(beta/2)^2;
tb2 = tan(beta/2);

dlmkr = drec(n, cb, s2b2, r2sb, c2b2,tb2);

diffM = [];

for l = 0:n
    for k = -l:l
        for m = -l:l
            dlmk = d(l, m, k, beta);
            diff = abs(dlmk - dlmkr(l+1, n+1+m, n+1+k));
            if diff>1e-3
                diffM = [diffM; diff, l, m, k];
            end
        end
    end
end