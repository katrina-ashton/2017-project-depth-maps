function stris = sampleSphericalMapF( stris, f, num_samples, level, ...
                                     visualize )
% 
% stris = sampleSphericalMap( stris, map, num_samples, level, visualize ) 
%
% Resample texture onto spherical triangles on level \a level of the wavelet
% tree
% @return forest of wavelet trees where the nodes on level \a level contain
%         a resampled version of \a map
% @param  stris  root nodes of forest of wavelet trees
% @param  map    source map  for resampling
% @param  num_samples  number of samples per domain on level \a level
% @param  level   level of the wavelet trees on which to resample the data
% @param  visualize   {0,1}{default = 0} visualize the samples 


%   % visualize samples 
%   do_visualize = 0;
%   if( nargin > 4)
%     do_visualize = visualize;
%   end
%     
%   % draw map as background for samples
%   if( nargin == 5)
%     if( visualize > 0)
%       figure;
%       image( map);
%       hold on;  
%     end
%   end
  
  stris = sampleSphericalMapPrivate( stris, f, num_samples, level, visualize);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stris = sampleSphericalMapPrivate( stris, f, num_samples, level, ...
                                            visualize )                                   
    
  % do for all triangles
  for( t = 1 : numel( stris))
  
    if( getLevel(stris(t)) == level)

      verts = getVertsEC( stris(t));

      samples = [];

      % generate three random samples which become the barycentric weights
      w = rand( 3, num_samples);

      % Use vectorized version (roughly two orders of magnitude faster)
      % [data, samples] = sampleTriangleSerial( w, map, verts);
      [data, samples] = sampleTriangleVectorizedF( w, f, verts, num_samples);    
      %CONDITION( data == data2);

      stris(t) = setData( stris(t), data / num_samples);
      % stris(t) = setData( stris(t), logical( round( data / num_samples)));

      % visualize samples 
%       if( visualize > 0)
%          plot( samples(1,:), samples(2,:) , 'xr');
%       end

    elseif( getLevel(stris(t)) < level)

      childs = getChilds( stris(t));

      % recursively traverse wavelet tree
      for( i = 1 : numel( childs))
        childs(i) = sampleSphericalMapPrivate( childs(i), f, ...
                                               num_samples, level, ...
                                               visualize );
      end

      stris(t) = setChilds( stris(t), childs);

    else  
      warning( 'Invalid input level.');
    end

  end % end for all input triangles
  
end
