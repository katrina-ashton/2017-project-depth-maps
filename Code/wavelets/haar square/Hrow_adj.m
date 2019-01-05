function Hrow = Hrow_adj(c)
    H = getH(size(c,2)*2)';
    Hrow = zeros(size(c,1), size(c,2)*2);
    for i = 1:size(c,1)
        Hrow(i,:) = H*c(i,:)';
    end
end