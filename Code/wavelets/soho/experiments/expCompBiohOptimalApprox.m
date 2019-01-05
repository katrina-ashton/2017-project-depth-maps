function  [bioh_largest , bioh_optimal , osh_optimal , pwh_optimal ] = ...
          expCompBiohOptimalApprox( platonic_solid, level, signal, save_path)
%
%
%
% Perform batch experiment comparing the optimal with the k-largest 
% approximation for the Bio-Haar basis and also computing the approximation for 
% the SOHO and PWH basis as reference

  % pre-process optional input arguments
  sp = '';
  if( nargin > 3)
    sp = save_path;
  end
  save_path = sp;


  % first compute k-largest approximation for Bio-Haar
  bioh_largest = expCompressionBasis( platonic_solid, 'bioh', signal, ...
                                      level, '', 0);

  % compute reference results

  bioh_optimal = expCompressionBasis( platonic_solid, 'bioh', signal, level);
  osh_optimal = expCompressionBasis( platonic_solid, 'osh', signal, level);
  pwh_optimal = expCompressionBasis( platonic_solid, 'pwh', signal, level);

  if( numel( save_path) > 0)
    % generate file name for result
    [pathstr, signal_name, ext] = fileparts(signal);
    fname = [save_path filesep 'comp_bioh_optimal_' platonic_solid '_' ...
              signal_name '_l' num2str(level) ];
    % save result
    save( fname, 'bioh_largest', 'bioh_optimal', 'osh_optimal', 'pwh_optimal');
  end

end


