function BTM = computeBTM(  stris_target, stris_source, levels, BTM)
% Compute the basis transformation matrix 
% stris_source  source wavelet basis
% stris_target  target wavelet basis
% BTM  basis transformation matrix to compute

  if( levels > 0)

    for i = 1 : numel( stris_target)

      % compute coupling coefficients 
      % do for all basis functions in stris_source
      % store data in row according to index (global index of the basis
      % function)
      pc = [];
      pc = getProjection( stris_target(i), stris_source, pc);
      BTM(stris_target(i).index , : , :) = pc;

      % recurse to compute projection coefficients for basis functions
      BTM = computeBTM( stris_target(i).childs, stris_source, levels - 1, BTM);    
    end
    
  end % if level > 1
  
end