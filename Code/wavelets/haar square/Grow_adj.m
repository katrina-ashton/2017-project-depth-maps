function Grow = Grow_adj(c)
    G = getG(size(c,2)*2)';
    Grow = zeros(size(c,1),size(c,2)*2);
    for i = 1:size(c,1)
        Grow(i,:) = G*c(i,:)';
    end
end