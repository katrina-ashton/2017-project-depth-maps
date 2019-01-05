function Hrow = Hrow(c)
    H = getH(size(c,1));
    Hrow = zeros(size(c,2), size(c,1)/2);
    for i = 1:size(c,1)
        Hrow(i,:) = H*c(i,:)';
    end
end