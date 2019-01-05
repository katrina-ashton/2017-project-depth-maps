function basen = update_wavelet(base, stris, level, p, delR, is, child_arr, scale)
basen = stri(base);

for i = 1 : numel(stris)
    
    if( 1 == checkPointInsideSTri(stris(i), p))
    
      levelc = getLevel( stris);
      if(levelc  < level)
          scalel = (levelc)^2/level^3;
%           scalel = (levelc==level-1);
          
        % recursively traverse tree
        childs = getChilds(stris(i));
        
        %work out which subtriangle point is in
        %in t0 - center triangle: need to change all 3 wavelets
        if (1 == checkPointInsideSTri( childs(1), p))
            for j=1:3
                stris(i).w_coeffs(:,j) = stris(i).w_coeffs(:,j) + scale*delR*scalel/3;
            end
        end
        
        %in t1
        if (1 == checkPointInsideSTri( childs(2), p))
            stris(i).w_coeffs(:,1) = stris(i).w_coeffs(:,1) + scale*delR*scalel;
        end
        
        %in t2
        if (1 == checkPointInsideSTri( childs(3), p))
            stris(i).w_coeffs(:,2) = stris(i).w_coeffs(:,2) + scale*delR*scalel;
        end
        
        %in t3
        if (1 == checkPointInsideSTri( childs(4), p))
            stris(i).w_coeffs(:,3) = stris(i).w_coeffs(:,3) + scale*delR*scalel;
        end
        
        is = [is, i];
        child_arr{end +1} = stris;
        
        basen = update_wavelet(basen, childs, level, p, scale*delR, is, child_arr, scale);
      else

          basen = set_children_level(basen, level, is, child_arr);
          return;
      end

      
    end      
end  


end

function basen = set_children_level(base, level, is, child_arr)
basen = stri(base);
if level > 1
    c = base;
    for l = 1:level-2
        li = is(l);
        c = getChilds(c(li));
    end
    li = is(level-1);
    bc = child_arr{level-1};
    c(li).w_coeffs = bc.w_coeffs;
    c(li).childs = child_arr{level};
    child_arr{level-1} = c;
    basen = set_children_level(basen, level-1, is, child_arr);
end

li = is(1);
bc = child_arr{1};
basen(li).w_coeffs = bc(li).w_coeffs;
basen(li).childs = child_arr{2};
    
end