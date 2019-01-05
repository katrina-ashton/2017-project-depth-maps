function st = stri( varargin)
% Constructor for spherical triangle on unit sphere
% st.verts_ec :: vertices in euclidean coordinates (3 x 3 matrix where each
%                column defines one vertex
% st.area :: area of the spherical triangle
% st.childs :: children / sub-triangles (the center sub_domain has index 1,
%              the other sub-domains are indexed cw beginning in the lower 
%              right corner)
% st.level :: level in the wavelet tree on which the spherical triangle is
%             defined (the coarsest level is level 0)
% st.index_level :: index of the triangle within its level 
% st.s_coeff  :: scaling basis function coefficient
% st.w_coeffs  :: wavelet basis function coefficients (in each row the
%                 coefficients for one channel are stored
% st.data :: generic field to store data
% st.orientation :: vertices are orientated cw (1) or ccw (-1)

  % standard constructor    
  st.verts_ec = zeros(3,3);
  st.area = 0; 
  st.childs = [];
  st.level = 0;
  st.index_level = 0;
  st.s_coeff = 0.0;
  st.w_coeffs = zeros( 1, 3);
  st.data = [];
  st.orientation = 1;

  % select the appropriate constructor depending on the given args
  if( 0 == nargin) 
    
    % default constructor
    st = class( st, 'stri');
    
  elseif( isa( varargin{1}, 'stri'))
    
    % copy constructor
    st = varargin{1};
    
  else   
    
    % standard constructor, args are vertices of the spherical triangle in
    % either euclidean or spherical coordinates. The verts are given as
    % matrix where each column defines the coordinates of one vertex
    verts_in = varargin{1};
    if( 2 == size( verts_in, 1)) 
      
      error('Polar coordinates are currently not supported');
      
    elseif( 3 == size( verts_in, 1))
      
      st.verts_ec = verts_in;
      for i = 1 : 3        
        % normalize coordinates
        st.verts_ec( : , i) = st.verts_ec( : , i) / norm( st.verts_ec( : , i));
        % spherical coordinates
        st.verts(:,i) = r3_to_s2( st.verts_ec(:,i));
      end
      
    else
      error( 'No constructor interface for given argument.');
    end

    % compute area
    st.area = computeAreaSTri( st.verts_ec);
     
    % varargin(2) has to be the parent if provided
    if( nargin > 1)                             
      % data derived from parent
      st.level = varargin{2}.level + 1;
    end
      
    % varargin(3) has to be the child index w.r.t. the parent (\in {0,1,2,3})
    if( nargin > 2)                             
    
      parent = varargin{2};
      
      % set index within level
      st.index_level = (4 * parent.index_level) + varargin{3};
            
    end
                             
    st = class( st, 'stri');
    
  end % different constructors

end
