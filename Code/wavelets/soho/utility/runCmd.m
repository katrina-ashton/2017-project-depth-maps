function runCmd( cmd, err_msg)
%
% runCmd( cmd, err_msg)
%
% Execute command on the command line
%
% @param  cmd  command to execute as string
% @param  err_msg  custom error message which is displayed when executing
%                  the command failed (optional)

  % pre-process optional input arguments
  em = '';
  if( nargin > 1)
    em = err_msg;
  end
  err_msg = em;
  
  [status, result] = unix( cmd);
  if( ( status < 0) || ( 0 ~= numel(strfind( result, 'Error'))) )
    error( '%s : %s', err_msg, result);
  end
end