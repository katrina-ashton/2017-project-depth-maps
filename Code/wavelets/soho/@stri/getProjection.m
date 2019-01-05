function pc = getProjection( st_target, stris_source, pc)
% Compute the projection / coupling coefficients for the projection of the basis 
% functions of stris_source onto the (single) basis function st_target
% st_target  target wavelet basis
% stris_source  tree of source wavelet basis
% pc  projection coefficients (to be computed)

  % do for all basis functions in the source basis
  for i = 1 : numel( stris_source)
    if( numel( stris_source(i).childs) > 0) 
      
      % compute projection of scaling functions at the given domain
      proj_scale = getOverlap( st_target, stris_source(i));


      % all possible projections of basis functions
      % index 1 is scaling function, 2 .. 4 are the wavelet basis functions as
      % defined in [Ma 2006] (but normalized)
      % each row gives the coupling / projection coefficients for a fixed
      % source basis function
      proj_basis_fcts = zeros( 4, 4); 

      % if the scaling functions are 0, then the domains do not overlap and
      % therefore the projection of all wavelets is 0 as well
      if( 0 ~= proj_scale)
        
        % compute the pair-wise overlap of the 4 sub-domains (which yields a
        % symmetric 4x4 matrix)
        % rows represent the target basis, columns the source basis
        % e.g. the 2nd column represents the projection of the second sub-domain
        % in the source basis onto all sub-domains in the target basis
        proj_subd = [];
        for m = 1 : 4
          for n = 1 : 4
            proj_subd(m,n) = getOverlap( st_target.childs(m), ...
                                         stris_source(i).childs(n));
          end
        end       
        
        % safety check
        proj_basis_fcts(1,1) = sum( proj_subd(:));
        diff = abs(proj_scale - proj_basis_fcts(1,1)) < 0.00001;
        assert( diff);
        
        % iterate over all possible combinations
        
        % basis functions in filter tap notation
        basis_fcts = [1 1 1 1; 1 1 -1 -1; 1 -1 1 -1; 1 -1 -1 1];
        
        for m = 1 : size( basis_fcts, 1)
          for n = 1 : size( basis_fcts, 1)
        
            % compute matrices to incorporate the signs of the different
            % sub-regions in the basis functions
            
            signs_target = repmat( basis_fcts( m, :), 4, 1);
            % each columns represent a target basis -> transpose so that the
            % values in each row are modified
            signs_source = repmat( basis_fcts( n, :), 4, 1)';
            
            % compute the correct projection including the signs
            proj = signs_target .* signs_source .* proj_subd;

            proj_basis_fcts(n,m) = sum( proj(:));
          
          end
        end
        
      end
                                        
      % store the different coefficients
      pc( getIndex( stris_source(i)), : ) = proj_basis_fcts(:);
                                        
      % recurse to compute the projection for the child tree
      pc = getProjection( st_target, stris_source(i).childs, pc);
      
    end
  end
  
end