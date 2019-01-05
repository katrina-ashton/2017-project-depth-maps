function Hcol = Hcol_adj(c)
    H = getH(size(c,1)*2)';
    Hcol = zeros(size(c,1)*2, size(c,2));
    for i = 1:size(c,2)
        Hcol(:,i) = H*c(:,i);
    end
end