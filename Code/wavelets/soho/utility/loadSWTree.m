function stris = loadSWTree( psolid, enforce_equal_area, level_load, ...
                              path_prefix )
%
% swtree = loadSWTree( psolid, level_load)
%
% Load file containing precomputed speherical wavelet forest
%
% @return  root nodes of forest of spherical wavelet trees
% @param  psolid  string name of the spherical solid
% @param  enforce_equal_area  {0,1} if 1, then the spherical wavelet tree
%                            has been precomputed with a constraint on the
%                            area of the child triangles, otherwise not
% @param  level_load  maximum level of the wavelet tree
% @param  path_prefix  Optional path where the precomputed forests are located

  p = '';
  if( nargin > 3)
    p = path_prefix;
  end
  path_prefix = p;

  varname = ['swt_' psolid];
  
  if( 1 == enforce_equal_area)
    varname = [varname '_eq'];
  else
    varname = [varname '_ne'];  
  end
  varname = [varname '_l' num2str(level_load)];
  fname = [path_prefix filesep varname '.mat'];
  
  % load file
  load( fname);

  % assign output
  stris = eval( varname);
  
end