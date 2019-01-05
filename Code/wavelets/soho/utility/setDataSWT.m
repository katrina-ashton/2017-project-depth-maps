function tri = setDataSWT( tri, data)
%
% tri = setDataSWT( tri, zero_data)
%
% Set data field of all nodes of a wavelet tree
% 
% @param  tri   root node of wavelet tree
% @param  data  data to set

  tri = setData( tri, data);

  childs = getChilds( tri);
  for( i = 1 : numel( childs))
    childs(i) = setDataSWT( childs(i), data);
  end
  
  tri = setChilds( tri, childs);
  
end