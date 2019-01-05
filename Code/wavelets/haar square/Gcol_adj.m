function Gcol = Gcol_adj(c)
    G = getG(size(c,1)*2)';
    Gcol = zeros(size(c,1)*2, size(c,2));
    for i = 1:size(c,2)
        Gcol(:,i) = G*c(:,i);
    end
end