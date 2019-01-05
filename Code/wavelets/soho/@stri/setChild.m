function st = setChild( st, c, index)
%
% st = setChilds( st, c, index)
%
% Set child \a at \a index 
%
% @return  updated spherical triangle
% @param  st  spherical triangle to update
% @param  c   child
% @param  index  index of the child

  st.childs(index) = c;

end