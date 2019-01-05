function icosahedron = create_icosahedron()
% faces of icosahedron as spherical triangles

  teta = (1 + sqrt(5)) / 2;

  verts = [ 0, 1, teta;     1 teta, 0;    teta, 0, 1; ...
            0, -1, teta;   -1 teta, 0;    teta, 0, -1; ...
            0, 1, -teta;    1 -teta, 0;  -teta, 0, 1; ...
            0, -1, -teta;  -1 -teta, 0;  -teta, 0, -1]';

  % project onto unit sphere / normalize vectors         
  for i = 1 : size( verts, 2)
    verts( :, i) = verts( :, i) / norm( verts( :, i));
  end

  % upper pyramid
  icosahedron(1) = stri( [ verts(:,1), verts(:,2),  verts(:,3)]);
  icosahedron(2) = stri( [ verts(:,1), verts(:,3),  verts(:,4)]);
  icosahedron(3) = stri( [ verts(:,1), verts(:,5),  verts(:,2)]);
  icosahedron(4) = stri( [ verts(:,1), verts(:,9),  verts(:,5)]);
  icosahedron(5) = stri( [ verts(:,1), verts(:,4),  verts(:,9)]);

  % central band
  icosahedron(6) = stri( [ verts(:,2), verts(:,6), verts(:,3)]);
  icosahedron(7) = stri( [ verts(:,3), verts(:,6), verts(:,8)]);
  icosahedron(8) = stri( [ verts(:,3), verts(:,8), verts(:,4)]);
  icosahedron(9) = stri( [ verts(:,4), verts(:,8), verts(:,11)]);
  icosahedron(10) = stri( [ verts(:,4), verts(:,11), verts(:,9)]);
  icosahedron(11) = stri( [ verts(:,9), verts(:,11), verts(:,12)]);
  icosahedron(12) = stri( [ verts(:,9), verts(:,12), verts(:,5)]);
  icosahedron(13) = stri( [ verts(:,5), verts(:,12), verts(:,7)]);
  icosahedron(14) = stri( [ verts(:,5), verts(:,7), verts(:,2)]);
  icosahedron(15) = stri( [ verts(:,2), verts(:,7), verts(:,6)]);

  % lower pyramid
  icosahedron(16) = stri( [ verts(:,6), verts(:,7), verts(:,10)]);
  icosahedron(17) = stri( [ verts(:,7), verts(:,12), verts(:,10)]);
  icosahedron(18) = stri( [ verts(:,12), verts(:,11), verts(:,10)]);
  icosahedron(19) = stri( [ verts(:,11), verts(:,8), verts(:,10)]);
  icosahedron(20) = stri( [ verts(:,8), verts(:,6), verts(:,10)]);

  % delete helper variables
  clear teta verts;
  
end