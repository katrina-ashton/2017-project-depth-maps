function [lam, gam] = lift_split(split_method, data)
if split_method == 'lazy'
   lam = data(1:2:end);
   gam = data(2:2:end);
elseif split_method == 'haar'
    
end
end