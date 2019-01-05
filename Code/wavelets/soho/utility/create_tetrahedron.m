function tetrahedron = create_tetrahedron()
%
% tetrahedron = create_tetrahedron()
%
% Create a set of spherical triangles corresponding to the proejection of a
% tetraheron onto the sphere
  
  v0 = [1   1  1]';  v0 = v0 / norm( v0);
  v1 = [-1 -1  1]';  v1 = v1 / norm( v1);
  v2 = [-1  1 -1]';  v2 = v2 / norm( v2);  
  v3 = [ 1 -1 -1]';  v3 = v3 / norm( v3);   

  tetrahedron(1) = stri( [ v0,  v3,  v1]);
  tetrahedron(2) = stri( [ v1,  v3,  v2]);
  tetrahedron(3) = stri( [ v3,  v0,  v2]);
  tetrahedron(4) = stri( [ v0,  v1,  v2]);
  
end
