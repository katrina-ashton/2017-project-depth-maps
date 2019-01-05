function r = get_r(st, sp, sr, O, theta, phi, ttol, ptol)
if sum(O)~=0
    [st, sp, sr] = new_scoord(st, sp, sr, O);
end
vt = find(abs(st-theta) <= ttol);
vp = find(abs(sp-phi) <= ptol);

r = [];
for i=1:size(vt,1)
   j = vt(i);
   if ismember(j, vp)
      r = [r, sr(j)]; 
   end
end

if size(r,2) > 1
    r = mean(r);
end

end