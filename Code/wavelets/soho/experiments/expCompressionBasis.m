function  res = expCompressionBasis( platonic_solid, basis, ...
                                     signal_file, level, save_path, ...
                                     bioh_optimal )
%
% res = expCompressionBasis( platonic_solid, basis, signal, level, save_path)
%
% Run a batch test for basis \a basis testing the compression performance.
%
% @return  res  [n x 2] L1 and L2 error rates for different nonlinear
%               approximation ratios which are determined by level
% @param  platonic_solid   {'octahedron','icosahedron','tetrahedron'}
%                          platonic solid from which the partition is derived 
%                          over which the basis is defined
% @param  basis  {'osh', 'bioh', 'pwh'} basis which is employed for the
%                experiments
% @param  signal_file  file name + path of image containing the signal as
%                      spherical map which has to be used for the experiment 
% @param  level   level on which the data is to be defined
% @param  save_result  (optional) if not specified then the result is not
%                      saved, otherwise the given path will be used as
%                      target directory for saving the result, the file
%                      name is assembled from the parameters of the
%                      experiment
% @param  bioh_optimal (optional) {0,1} perform optimal (1) or k-largest 
%                       approximation for Bio-Haar basis (if applicable), 
%                       default is 1
  
  % optional input arguments

  base_path = '';
  save_result = 0;
  if( nargin > 4)
    if( numel( save_path) > 0)
      save_result = 1;
      base_path = save_path;
    end
  end

  bho = 1;
  if( nargin > 5)
    bho = bioh_optimal;
  end
  bioh_optimal = bho;

  % derive parameters from input
  coeffs_retained = getCoeffsRetained( level);
  
  % read signal
  signal = imread( signal_file);
  
  fhs = getFunctionHandlesBasis( basis);
  forest = getForestPlatonicSolid( platonic_solid, level, ...
                                   fhs.enforce_equal_area);
  
  % more parameter
  test_perfect_reconstruction = 0;
  
  
  visualize = 0;
  file_name_approx = '';   
  file_name_error = '';
  file_name_sampled = '';
  if( 1 == save_result)
    
    visualize = 1;
    
    [pathstr, signal_name, ext] = fileparts(signal_file);
    file_name_base = [base_path filesep basis '_' platonic_solid '_' ...
                      signal_name '_' 'l' num2str(level)];

    file_name_approx = file_name_base;
    file_name_error = [file_name_base '_' 'error'];
    file_name_sampled = [file_name_base '_' 'sampled'];    
    
  end
  
  res = expBatchTestCompression( forest, basis, signal, level, ...
                                 coeffs_retained, ... 
                                 test_perfect_reconstruction, ...
                                 visualize, ...
                                 file_name_approx, ...
                                 file_name_error, ...
                                 file_name_sampled, ...
                                 bioh_optimal );
                               
  if( 1 == save_result)
    
    [pathstr, signal_name, ext] = fileparts(signal_file);
    v = genvarname( [basis '_' platonic_solid '_' signal_name '_' 'l7']);
    eval( [v '= res';]);
    
    save( file_name_base, v);
  end
                                 
end
