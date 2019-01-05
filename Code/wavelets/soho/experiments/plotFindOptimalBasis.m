function plotFindOptimalBasis( platonic_solid, signal, level, ...
                               base_path_load, base_path_save )
%
%
%
%
%
  
  % pre-process optional input arguments
  bpl = '';
  if( nargin > 3)
    bpl = base_path_load;
  end
  base_path_load = bpl;

  bps = '';
  if( nargin > 4)
    bps = base_path_save;
  end
  base_path_save = bps;                             
                               
  % assemble base file name
  fname_base = [base_path_load filesep platonic_solid '_' signal ...
                '_l' num2str(level)];
  
  % load the files and rename variables to canonical names
  
  fname = [fname_base '_aplus.mat'];
  load( fname);
  var_name = ['res_' platonic_solid '_' signal '_l' num2str(level) '_aplus'];
  eval( sprintf( 'res_plus = %s;', var_name));

  fname = [fname_base '_aminus.mat'];
  load( fname);   
  var_name = ['res_' platonic_solid '_' signal '_l' num2str(level) '_aminus'];
  eval( sprintf( 'res_minus = %s;', var_name));
  
  res_plus = squeeze( mean( res_plus, 1));
  res_minus = squeeze( mean( res_minus, 1));  
  
  
  if( 7 == level)
    x = [512 1024 2056 4096 8192 16384 32768];
  else( 5 == level)
    x = [32 64 128 256 512 1024 2056];
  end

  % switch to more common notation
  if( 1 == strcmp( signal, 'brdf'))
    signal = 'lambertian';
  end
  
  % set up strings for plot annotation
  
  title_str = sprintf('Platonic Solid = %s, Signal = %s, Level = %i', ...
                       platonic_solid, signal, level);
  x_label_str = 'Coefficients retained';
  legend_str = {'a : plus' , 'a : minus'};
  
  % do for both L1 and L2 norm
  for( l_norm = 1 : 2)

    figure;
    plot( x, res_plus( : , l_norm), '-bx',  x, res_minus( : , l_norm), '-rs' );

    % str for error
    y_label_str = ['L' num2str( l_norm) ' Error'];
    
    % annotate plot
    title( title_str);
    h = legend( legend_str, 1);
    legend('boxoff')
    set( h,'FontName','helvetica', 'FontSize',14);
    xlabel( x_label_str);
    ylabel( y_label_str);
    
  end
  
  if( 0 ~= numel( base_path_save))
    error( 'TBI');
  end
  
end