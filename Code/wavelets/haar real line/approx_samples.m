f = @(x) exp(x);
a = 0;
b = 1;
m = 10000;
t = a: (b-a)/m: b;
fs = f(t);

jmax = 10;
kmax = 10;

% funs = cell(jmax*2+1, kmax*2+1);
% coeff = zeros(jmax*2+1, kmax*2+1);
% for j = -jmax:jmax
%     for k = -kmax:kmax
%         hjk = Hjk(j,k);
%         c = innerprod(f, hjk, a, b);
%         funs{jmax+j+1, kmax+k+1} = hjk;
%         coeff(jmax+j+1, kmax+k+1) = c;
%     end
% end


%Get rid of useless coefficients:
thresh = 1e-3;

funs = cell(0);
coeff = [];
i = 0;
for j = -jmax:jmax
    for k = -kmax:kmax
        hjk = Hjk(j,k);
        hjks = hjk(t);
        c = dot(fs, hjks)/m;
        if abs(c) >thresh
            i = i+1;
            funs{i} = hjk;
            coeff(i) = c;
        end
    end
end
%Right now has issues if want to re-expand. Store j and k with the
%coefficient?

%Probably a better way of doing this...
ap = @(x) coeff(1).*funs{1}(x);
for i =2:numel(coeff)
    ap = @(x) ap(x) + coeff(i).*funs{i}(x);
end

%Plot the approximation
plot(t, f(t), t, ap(t))