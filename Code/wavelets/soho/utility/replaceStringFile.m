function replaceStringFile( fname_in, fname_out, token_in, token_out)
%
% replaceStringFile( fname_in, fname_out, token_in, token_out)
%
% Create a copy \a fname_out of the file \a fname_in where all occurences
% of \a token_in are replaced by \a token_out
%
% @param  fname_in  name of the input file
% @param  fname_out  name of the output / written file
% @param  token_in  token to replace
% @param  token_out  replacement for \a token_in

  % open the files
  f_read = openFile( fname_in, 'r');
  f_write = openFile( fname_out, 'w+');
  
  % read the lines until the camera position is found
  l = fgetl( f_read);
  while( ischar(l))
    
    % replace the tokens if it exists in the file
    l_out = l;
    for( k = 1 : numel( token_in))
      l_out = strrep( l_out, token_in{k}, token_out{k});
    end
    
    % write the line to the new file
    count = fprintf( f_write, '%s\n', l_out);
    if( count ~= (numel(l_out) + 1))
      error( sprintf( 'Writing failed for "%s"', l_out));
    end

    l = fgetl( f_read);
    
  end
  
  fclose( f_read);
  fclose( f_write);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fh = openFile( name, mode)
  
  fh = fopen( name, mode);

  if( -1 == fh)
    error( sprintf( 'Opening file failed. Check path and filename: %s', name));
  end
  
end
