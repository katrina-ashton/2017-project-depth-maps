function plotUnitSphere( transparent, axis_on)
%
% plotUnitSphere( transparent, axis_on)
%
% Plot unit sphere
% @param  transparent {0,1}{default = 1} the sphere is plotted
%                     transparently, i.e. the faces are not filler
% @param  axis_on  {0,1}{default = 0} if 1, then the axes are drawn,
%                  otherwise not

  % preprocess input args
  t = 1;
  if( nargin > 0)
    t = transparent;
  end
  transparent = t;

  a = 0;
  if( nargin > 1)
    a = axis_on;
  end
  axis_on = a;
  
  % plot sphere

  [X,Y,Z] = sphere;
  
  if( transparent > 0)
    mesh( X, Y, Z, 'EdgeAlpha', 0.5, ...
                   'EdgeColor', [0.6 0.6 0.6], ...
                   'EdgeLighting', 'none', ...
                   'FaceColor', 'none');
  else
    mesh( X, Y, Z, 'EdgeAlpha', 0.5, ...
               'EdgeColor', [0.6 0.6 0.6], ...
               'EdgeLighting', 'none', ...
               'FaceColor', [1 1 1], ...
               'FaceAlpha', 0.6);
  end
  
  axis equal;  
  if( axis_on <= 0)
    %axis off;
  end
  
  hold on;
  
end