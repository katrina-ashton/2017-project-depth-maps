function samples = shGenerateSamples( sqrt_num_samples, num_bands)
%
% function samples = shGenerateSamples( num_samples, num_bands)
%
% Generate (sqrt_num_samples)^2 uniformly distributed samples on the sphere
% \mathbb{S}^2

  samples = {};

  inv_n = 1.0 / sqrt_num_samples;
  i = 1;
  
  for( a = 0 : (sqrt_num_samples-1))
    for( b = 0 : (sqrt_num_samples-1))    
      
      x = (a + rand) * inv_n;
      y = (b + rand) * inv_n;
      
      theta = 2 * acos( sqrt( 1 - x));
      phi = 2 * pi * y;
      
      sample.sph = [theta, phi, 1.0];
      sample.vec = [sin(theta) * cos(phi), sin(theta) * sin(phi), cos( theta)];
      
      coeffs = [];
      
      % for all bands (from 0 to num_bands-1)
      for( l = 0 : (num_bands - 1))
        % for all basis functions within the band
        for( m = -l : l)
          
          index = l * (l+1) + m + 1;
          coeffs(index) = shEval( l, m, theta, phi);
          % stable is buggy
          % coeffs(index) = shEvalStable( l, m, theta, phi);
          
        end  % end for all basis functions within a band
      end  % end for all bands

      sample.coeffs = coeffs;
      samples{i} = sample;
      i = i + 1;
      
    end  % end a    
  end  % end b

end