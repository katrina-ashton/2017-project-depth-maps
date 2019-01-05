function st = setIndex( varargin)
% Set the (global) index of the spherical triangle

  st = varargin{1};

  if( 2 == nargin)
    
    % varargin{2} is the (global) index
    st.index = index;
    
  elseif( 3 == nargin) 

    % varargin{2} is the level    
    st.level = varargin{2};
    st.index_level = varargin{3};
    
    offset = 0;
    for( j = 0 : st.level - 1)
      offset = offset + 4^j;
    end

    st.index = offset + st.index_level;
    
  else
    error( ['Invalid arguments. Ever global index or ' ...
            'level and local index within the level'])
  end
    
end