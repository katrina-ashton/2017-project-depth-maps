function octahedron = create_octahedron()
  % faces of octahedron as spherical triangles

  x = [1 0 0]';
  y = [0 1 0]';
  z = [0 0 1]';

  % upper hemisphere
  octahedron(1) = stri( [ y,  x,  z]);
  octahedron(2) = stri( [-x,  y,  z]);
  octahedron(3) = stri( [-y, -x,  z]);
  octahedron(4) = stri( [ x, -y,  z]);
  % lower hemispher
  octahedron(5) = stri( [ x,  y, -z]);
  octahedron(6) = stri( [ y, -x, -z]);
  octahedron(7) = stri( [-x, -y, -z]);
  octahedron(8) = stri( [-y,  x, -z]);
  
  % delete helper variables
  clear x y z;
  
end