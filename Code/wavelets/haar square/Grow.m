function Grow = Grow(c)
    G = getG(size(c,1));
    Grow = zeros(size(c,2),size(c,1)/2);
    for i = 1:size(c,1)
        Grow(i,:) = G*c(i,:)';
    end
end