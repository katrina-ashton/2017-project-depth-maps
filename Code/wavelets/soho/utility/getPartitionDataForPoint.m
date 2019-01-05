function data = getPartitionDataForPoint( partition, level, p)
%
% data = getPartitionDataPoint( partition, level, p)
%
% Get the value of the partition on level \a level in which \a p lies.

  for( i = 1 : numel( partition))
    
    if( 1 == checkPointInsideSTri( partition(i), p))
    
      if( getLevel( partition) < level)

        % recursively traverse tree
        childs = getChilds( partition(i));
        data = getPartitionDataForPoint( childs, level, p);
        
      else 
        
        data = getData( partition(i));
        
      end
      
      return;
      
    end  % end point is inside current stri    
  end  % end for all elements in partition

end