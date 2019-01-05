function plotTriCurved( tri, radius, subdivision_level, col)
%
% plotTriCurved( tri, radius, subdivision_level, col)
%
% Visualize spherical triangle 
%
% @param  tri     spherical triangle to visualize
% @param  radius  radius at which the triangle is drawn
% @param  subdivision_level  subdivision level for face (controls quality,
%         non-positive values prevent the face from being drawn)
% @param  col  color of the triangle in the visualization (if no color is
%              specified than it is determined base on the radius (reddish
%              colors for positive and bleuish for negative (< 1.0) values

  % pre-process input arguments

  r = 1.0;
  if( nargin > 1)
    r = radius;
  end
  radius = r;
  
  sl = 3;
  if( nargin > 2)
    sl = subdivision_level;
  end
  subdivision_level = sl;
  
  c = [1 0 0];
  if( nargin > 3)
    c = col;
  else
    % get the color
    colormap( 'jet');  
    cmap = colormap;
    % use quadratic scaling to better discriminate regions
    ci = int16( round( (radius^2) * ( size(cmap,1) / 2)));
    % clamp
    ci = min( size( cmap, 1), ci);
    c = cmap( ci, :);
  end
  col = c;
  
  % default offset to avoid aliasing due to piece-wise constant approximation 
  % of curves  
  offset_surface = 1.001;

  % edges
  plotEdgesCurved( tri, offset_surface, radius, col);

  if( subdivision_level > 0)
    % surface
    swt = create_swtree( tri, subdivision_level);
    plotFaceCurved( swt, subdivision_level, radius, col);
  end
  
end