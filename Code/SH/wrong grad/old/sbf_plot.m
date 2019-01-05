function sbf_plot(w, X, t, n, res)
%Code from spharmPlot:
% Written by Mengliu Zhao, School of Computing Science, Simon Fraser University
% Update Date: 2014/Dec/03

delta = pi/res;
theta = 0:delta:pi; % altitude
phi = 0:2*delta:2*pi; % azimuth
[phi,theta] = meshgrid(phi,theta);
R = zeros(size(theta,1));

for L = 0:n
    for M = -L:L
	% Legendre polynomials
	P_LM = legendre(L,cos(theta(:,1)));
	P_LM = P_LM(abs(M)+1,:)';
	P_LM = repmat(P_LM, [1, size(theta, 1)]);

	% normalization constant
	N_LM1 = sqrt((2*L+1)/(4*pi));
    N_LM2 = sqrt(factorial(L-abs(M))/factorial(L+abs(M)));
		
	% base spherical harmonic function
	if M<0
		Y_LM = sqrt(2) * N_LM1 * N_LM2 * P_LM .* sin(abs(M)*phi);
    elseif M==0
        Y_LM = N_LM1*P_LM;
	else		
		Y_LM = sqrt(2) * N_LM1 * N_LM2 * P_LM .* cos(M*phi);
	end

	R = R + w(L^2+L+M+1)*(Y_LM);

    end
end

figure
hold on
%Plot points
theta_p = X(:,1);
phi_p = X(:,2);
r = t;
x = abs(r).*sin(theta_p).*cos(phi_p); 
y = abs(r).*sin(theta_p).*sin(phi_p);
z = abs(r).*cos(theta_p);
scatter3(x,y,z, '*', 'filled', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')

%Plot surface
r = R;	
x = abs(r).*sin(theta).*cos(phi); 
y = abs(r).*sin(theta).*sin(phi);
z = abs(r).*cos(theta);

% visualization
h = surf(x,y,z,double(r>=0));

% adjust camera view

camlight left
camlight right
lighting phong

alpha(h, 0.5)

	
% map positive regions to red, negative regions to green
colormap(redgreencmap([2]))
	
% hide edges
set(h, 'LineStyle','none')
	
grid off

end