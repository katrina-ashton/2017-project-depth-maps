function obj = set( obj, varargin)
% Set data members of a spherical triangle

  args_remaining = varargin;

  % do until all given (member,val) pairs are processed
  while length( args_remaining) >= 2,
    
    % extract (member,val) pair
    prop = args_remaining{1};
    val = args_remaining{2};
    
    args_remaining = args_remaining(3:end);
    
    % perform assignment
    switch prop
       
      otherwise
        error([member 'is not a member of class stri']);
        
    end
  end
  
end
    
      
%       case 'verts'
%         st.verts = args;
%         st.verts_ec(:,1) = s2_to_r3( st.verts(:,1));
%         st.verts_ec(:,2) = s2_to_r3( st.verts(:,2));
%         st.verts_ec(:,3) = s2_to_r3( st.verts(:,3));
%         
%       case 'verts_ec'
%       	st.verts_ec = args;
%         st.verts(:,1) = r3_to_s2( st.verts_ec(:,1));
%         st.verts(:,2) = r3_to_s2( st.verts_ec(:,2));
%         st.verts(:,3) = r3_to_s2( st.verts_ec(:,3));   
%  