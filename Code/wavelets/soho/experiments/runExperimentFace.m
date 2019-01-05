file_name = '../face/models/fig1/fig1_1_small.obj';
[pathstr, save_name, ext, versn] = fileparts( file_name);
save_name = [save_name '_2'];
addpath utility/ cubemap/ haar2D/ dswt/ rotation/ experiments/ 

% basis defined over a partition derived from an octahedron
platonic_solid = 'octahedron';

% other bases are 'bioh', 'pwh' (pseudo Haar), ...
basis = 'osh';

% get function handles for basis
fhs = getFunctionHandlesBasis( basis); 

% level -1 on which the input signal is sampled / number of levels over which the wavelet transform is performed
level = 4;

% construct forest of partition trees
forest = getForestPlatonicSolid( platonic_solid, level, fhs.enforce_equal_area);

% read the mesh
msh = loadObj( file_name);

% compute normals and spherical triangles
msh = projectMeshToSphere( msh);
msh = precomputeInsideTestNO( msh);

% sample forest
forest_sampled = sampleMeshFaces( forest, msh, 5, level);

% % save result
% % save( save_name);
