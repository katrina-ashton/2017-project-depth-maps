function M = eul2rotm(eul)
a = eul(1);
b = eul(2);
g = eul(3);

%XZX
s1 = sin(a);
s2 = sin(b);
s3 = sin(g);
c1 = cos(a);
c2 = cos(b);
c3 = cos(g);
M = [c1*c3-s1*s3*c2, s1*c3+c1*s3*c2, s3*s2; ...
    -c1*s3-s1*c3*c2, -s1*s3+c1*c3*c2, c3*s2; ...
    s1*s2, -c1*s2, c2];

end