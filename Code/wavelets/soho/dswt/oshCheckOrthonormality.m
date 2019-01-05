function oshCheckOrthonormality( stris)
%
% oshCheckOrthonormality( stris)
%
% Check orthonormality of osh basis (orthogonality across levels is
% guaranteed by vanishing integral of wavelet basis functions)
%
% @param  stri  root nodes of forest of wavelet trees
% @note  If no Matlab error is generated then the basis is orthonormal

  % do for all input nodes
  for( t = 1 : numel( stris))
    
    childs = getChilds( stris(t));
    
    if( numel( childs) > 0)

      area_0 = getArea( childs(1));
      area_1 = (getArea(childs(2)) + getArea(childs(3)) + getArea(childs(4)))/3;
      % area_1 = getArea(childs(2));

      % get filter tabs
      ftabs = oshFiltersAnalysis( stris( t));
      
      epsilon = 10^-15;

      % scaling basis function and wavelet basis functions
      checkEpsilon( dot( ftabs(1,:), ftabs(2,:)), epsilon);
      checkEpsilon( dot( ftabs(1,:), ftabs(3,:)), epsilon);
      checkEpsilon( dot( ftabs(1,:), ftabs(4,:)), epsilon);    

      % wavelet basis functions
      checkEpsilon( dot( ftabs(2,:), ftabs(3,:)), epsilon);  
      checkEpsilon( dot( ftabs(3,:), ftabs(4,:)), epsilon);    
      checkEpsilon( dot( ftabs(3,:), ftabs(4,:)), epsilon);    

      % check normalization
      epsilon2 = 10^-10;
      checkEpsilon( dot( ftabs(1,:), ftabs(1,:)) - 1.0, epsilon2); 
      checkEpsilon( dot( ftabs(2,:), ftabs(2,:)) - 1.0, epsilon2);
      checkEpsilon( dot( ftabs(3,:), ftabs(3,:)) - 1.0, epsilon2);
      checkEpsilon( dot( ftabs(4,:), ftabs(4,:)) - 1.0, epsilon2);      
      
      % vanishing integral of wavelet basis functions

      areas_sqrt = [ sqrt(area_0), sqrt(getArea(childs(2))), ...
                     sqrt(getArea(childs(3))), sqrt(getArea(childs(4))) ];

      % check vanishing integral of wavelet basis functions
      checkEpsilon( dot( ftabs(2,:), areas_sqrt), epsilon2);
      checkEpsilon( dot( ftabs(3,:), areas_sqrt), epsilon2);
      checkEpsilon( dot( ftabs(4,:), areas_sqrt), epsilon2);
      
      % check inverse == transpose
      s1 = ftabs';
      s2 = inv( ftabs);
      diff = abs( s1 - s2);
      err = sum( diff(:)) / numel( s1);
      checkEpsilon( err, epsilon2);
      
      
      % recursively traverse tree      
      for( i = 1 : numel( childs))
        oshCheckOrthonormality( childs(i));
      end 
      
    end

  end % end for all input triangles
  
      
end

