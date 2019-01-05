function  biohCheckBiorthogonality( stris)
%
% checkBioBasis( stris, fh_filters_analysis, fh_filters_synthesis)
%
% Check biorthogonality of Bio-Haar basis (orthogonality across levels is
% guaranteed by vanishing integral of wavelet basis functions)
%
% @param stris  root nodes of forest of wavelet trees
% @note  If no Matlab error is generated then the basis is orthonormal

  % do for all input nodes
  for( t = 1 : numel( stris))
    
    childs = getChilds( stris(t));
    
    if( numel( childs) > 0)
      
      if( 0 == getIndexLevel( stris(t)))
        disp( sprintf( 'level = %i', getLevel( stris(t))));
        a = biohFiltersAnalysis( stris(t))
        s = biohFiltersSynthesis( stris(t))
      end
      
      % get filters
      a = biohFiltersAnalysis( stris(t));
      s = biohFiltersSynthesis( stris(t));

      epsilon = 10^-8;

      % scaling basis functions
      checkEpsilon( dot( a(1,:), s(:,1)) - 1.0, epsilon);

      % wavelet basis functions

      checkEpsilon( dot( a(2,:), s(:,2)) - 1.0, epsilon);
      checkEpsilon( dot( a(3,:), s(:,3)) - 1.0, epsilon);
      checkEpsilon( dot( a(4,:), s(:,4)) - 1.0, epsilon);

      checkEpsilon( dot( a(2,:), s(:,3)), epsilon);
      checkEpsilon( dot( a(2,:), s(:,4)), epsilon);
      checkEpsilon( dot( a(3,:), s(:,4)), epsilon);    

      % vanishing integral of wavelet basis functions

      areas = [ getArea( childs(1)), getArea( childs(2)), ...
                getArea( childs(3)), getArea( childs(4)) ];

      checkEpsilon( dot( s(:,2), areas), epsilon);
      checkEpsilon( dot( s(:,3), areas), epsilon);
      checkEpsilon( dot( s(:,3), areas), epsilon);    

      % just sum because normalization is 1/alpha_{j,k}
      checkEpsilon( sum( a(2,:)), epsilon);
      checkEpsilon( sum( a(3,:)), epsilon);
      checkEpsilon( sum( a(4,:)), epsilon);    
  
      % recursively traverse the tree
      for( i = 1 : numel( childs))
        biohCheckBiorthogonality( childs(i));
      end 
      
    end
      
  end  % end for all input triangles
  
end