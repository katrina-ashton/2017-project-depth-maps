function [X, r] = mm(meas, w, n, rot, t)
sgn = sign(meas(:,3));
p = new_scoord(meas(:,1), meas(:,2), abs(meas(:,3)), t, rot);
p(:,3) = sgn.*p(:,3);

r = p(:,3) + angle2Rsphfull(w, n, p(:,1), p(:,2));
X = p(:,1:2);

end