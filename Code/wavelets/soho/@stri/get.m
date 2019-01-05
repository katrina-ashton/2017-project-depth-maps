function val = get( st, member)
% Access data members of a spherical triangle

  switch( member)
    
    case 'verts'
      val = st.verts;
      
    case 'verts_ec'
      val = st.verts_ec;
      
    case 'area'
      val = st.area;
      
    case 'childs'
      val = st.childs;
    
    otherwise
      error( [member 'is not a member of class stri']);
    
  end

end