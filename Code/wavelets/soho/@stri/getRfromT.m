function R = getRfromT(theta,phi,stris,level)
% rad = abs(radii);	
% vx = verts(1,:); vy=verts(2,:); vz=verts(3,:);

x = sin(theta).*cos(phi-pi); 
y = sin(theta).*sin(phi-pi);
z = cos(theta);

N = numel(theta);

%Interpolation. 

%%From coeffs
R = zeros(size(theta));
for i = 1:N
    [scaleRi, waveRi] = rscale( stris, level, [x(i);y(i);z(i)], 0, 0);

    R(i) = (scaleRi+waveRi)/4;
       
end


%% For now just do closest vertex...
% for i = 1:N
%     dist = sqrt((vx-x(i)).^2+(vy-y(i)).^2+(vz-z(i)).^2);
%     [~, mi] = min(dist);
%     r = rad(mi);
%     x(i) = r*x(i);
%     y(i) = r*y(i);
%     z(i) = r*z(i);
       
% end

%% Too slow
% F = scatteredInterpolant(vx',vy',vz',radii');
% R = F(x,y,z);

%% Use their function - slightly faster
% R = zeros(size(theta));
% for i = 1:N
%     r = getPartitionDataForPoint( stris, level, [x(i),y(i),z(i)]);
%     R(i) = mean(r);
%        
% end


end

%%
function [scaler, waver] = rscale( stris, level, p, scaler, waver)
%
% data = getPartitionDataPoint( partition, level, p)
%
% Get the value of the partition on level \a level in which \a p lies.

  for( i = 1 : numel( stris))
    
    if( 1 == checkPointInsideSTri( stris(i), p))
    
      if( getLevel( stris) < level)

        % recursively traverse tree
        childs = getChilds( stris(i));
        c = mean(stris(i).s_coeff);
        scaler = scaler + c/sqrt(getArea(stris(i)));
        
        cs = stris(i).w_coeffs;
        A1 = (sqrt(getArea(childs(2)))+sqrt(getArea(childs(3)))+sqrt(getArea(childs(4))))/3;
        %work out which subtriangle point is in
        %in t0
        if (1 == checkPointInsideSTri( childs(1), p))
            A0 = sqrt(getArea(childs(1)));
            waver = waver + cs(1,1)*A1/A0;
            waver = waver + cs(1,2)*A1/A0;
            waver = waver + cs(1,3)*A1/A0;
        end
        
        %in t1
        if (1 == checkPointInsideSTri( childs(2), p))
            a0 = getArea(childs(1));
            a1 = getArea(childs(2));
            a = (a0 - sqrt(a0^2+3*a0*a1))/(3*a0);
            waver = waver + cs(1,1)*(-2*a+1)/A1;
            waver = waver + cs(1,2)*a/A1;
            waver = waver + cs(1,3)*a/A1;
        end
        
        %in t2
        if (1 == checkPointInsideSTri( childs(3), p))
            a0 = getArea(childs(1));
            a1 = getArea(childs(2));
            a = (a0 - sqrt(a0^2+3*a0*a1))/(3*a0);
            waver = waver + cs(1,1)*a/A1;
            waver = waver + cs(1,2)*(-2*a+1)/A1;
            waver = waver + cs(1,3)*a/A1;
        end
        
        %in t3
        if (1 == checkPointInsideSTri( childs(4), p))
            a0 = getArea(childs(1));
            a1 = getArea(childs(2));
            a = (a0 - sqrt(a0^2+3*a0*a1))/(3*a0);
            waver = waver + cs(1,1)*a/A1;
            waver = waver + cs(1,2)*a/A1;
            waver = waver + cs(1,3)*(-2*a+1)/A1;
        end
        
        [scaler, waver] = rscale( childs, level, p, scaler, waver);
        

        
      end
      
      return;
      
    end  % end point is inside current stri    
  end  % end for all elements in partition

end