function ds = dots( as, bs)
% 
% ds = dots( as, bs)
%
% Compute dot product of vectors

  ds = as(1,:) .* bs(1,:) + as(2,:) .* bs(2,:) + as(3,:) .* bs(3,:);

end