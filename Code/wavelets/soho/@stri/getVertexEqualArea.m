function [new_2, new_3] = getVertexEqualArea( st, childs, v_new)
% The area of childs(2) and childs(4) have to be identical so that the wavelets
% are orthogonal
% This can be achieved by fixing the area of childs(2) and moving v_new( :, 1)
% so that the areas line up. Note that this also changes the areas of childs(1)
% and childs(3)
% @param  st  parent  spherical triangle
% @param  childs  four potential child triangles of st
% @param  v_new   mid points of the edges / arcs of st / new vertices which have
%                 been generated to generate childs
  
  % compute normals of known planes
  nu1 = cross( st.verts_ec(:,3), st.verts_ec(:,1));
  nu2 = cross( st.verts_ec(:,2), st.verts_ec(:,3));
  nu3 = cross( st.verts_ec(:,2), st.verts_ec(:,1));

  % normalize the normals
  n1 = nu1 / norm( nu1);           
  n2 = nu2 / norm( nu2);
  n3 = nu3 / norm( nu3);
  
  % [b1, b2] = getBeta( st);
  [beta_1, beta_2] = getBeta3( st);
   b1 = beta_1;
   b2 = beta_2;
  
  % compute new vertex
  % up vector to coordinate system whose x axis is v3
  upu = cross( st.verts_ec(:,3), n1);
  up = upu / norm( upu);

  % compute corrected vertex 
  new_2 = cos( b1) * st.verts_ec(:,3) - sin( b1) * up;

  upu = cross( n3, st.verts_ec(:,2));
  up = upu / norm( upu);

  new_3 = cos( b2) * st.verts_ec(:,2) + sin( b2) * up;
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotGraph( A_s, B_s, C_s, A_c, B_c, C_c, b, c, gamma, ...
                    beta_1_r, beta_2_r, st )

  x = [-10 : 0.001 : 10];
  
  val_range = [0.001 : 0.001 : 2 * acot( c)];
  % val_range = [-3 : 0.001 : 3];
  beta_2 = cot( 1/2 * val_range);
  
  % beta_1_2 (II == III)

  beta_1_1 = [(-1).*(gamma.*A_s.*(c+(-1).*beta_2).*beta_2+B_s.*(b+A_s.*B_c.*(c+(-1).*beta_2)+b.*c.*beta_2+A_c.*A_s.*((-1).*c+beta_2))).^(-1).*(b.*gamma.*A_s.*beta_2.*((-1).*c+beta_2)+B_s.*(1+b.*A_c.*A_s.*(c+(-1).*beta_2)+c.*beta_2+b.*A_s.*B_c.*((-1).*c+beta_2)))];
  
  
  % beta_1_2 (I == II)
  
  beta_1_2 = (C_s * B_c) / gamma - (C_c / gamma) + (beta_2 * C_s / B_s);
  
  temp = (C_s * B_c) / gamma - (C_c / gamma) + (c * C_s / B_s);
% %   
% %   if( temp < 2)
%     disp( sprintf( 'temp = %f :: b = %f', temp, b));
% %     disp( 'BREAK');
% %   end
  
  figure;
  hold on;
  
  plot( val_range, 2 * acot( beta_1_1), '-r');
  plot( val_range, 2 * acot( beta_1_2), '-b');
 
%   % plot real solutions
%   x = 0 : 0.001 : (2 * acot(c));
%   y = beta_1_r * ones(1,numel(x));
%   plot( x, y, '--g');
%   
%   y = 0 : 0.001 : 2 * acot(b);
%   x = beta_2_r * ones(1,numel(y));
%   plot( x, y, '--g');

  x = 0 : 0.001 : 2 * acot(b);
  y = 2 * acot(b) * ones(1,numel(x));
  plot( x, y, '--m');
  
  y = -(1/b) * ones(1,numel(x));
  plot( x, y, '--g');
  
  % x axis
  x = 0 : 0.001 : (2 * acot(c));
  y = zeros(1,numel(x));
  plot( x, y, '--k');
  
  % y axis
  y = 0 : 0.001 : 2 * acot(b);
  x = zeros( 1, numel( y));
  plot( x, y, '--k');
  
  y = -10 : 0.001 : 10;
  x = 2 * acot(c)  * ones(1,numel(y));
  plot( x, y, '--c');
  
  set(gca,'FontName','helvetica', 'FontSize',14);
  set(get(gca,'XLabel'),'FontName','helvetica', 'FontSize',14);
  set(get(gca,'YLabel'),'FontName','helvetica', 'FontSize',14);
  set(get(gca,'Title'),'FontName','helvetica', 'FontSize',14);
 
  xlabel( '\beta_2');
  ylabel( '\beta_1');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  figure;
  hold on;

  plot( beta_2, beta_1_1, '-r');
  plot( beta_2, beta_1_2, '-b');

  x = beta_2;
  y = b * ones(1,numel(x));
  plot( x, y, '--m');
  
  y = -(1/b) * ones(1,numel(x));
  plot( x, y, '--g');
  
  y = -10 : 0.001 : 10;
  x = c * ones(1,numel(y));
  plot( x, y, '--c');
  
  x = cot( 1/2 * acot(c)) * ones(1,numel(y));
  plot( x, y, '--c');

  
  set(gca,'FontName','helvetica', 'FontSize',14);
  set(get(gca,'XLabel'),'FontName','helvetica', 'FontSize',14);
  set(get(gca,'YLabel'),'FontName','helvetica', 'FontSize',14);
  set(get(gca,'Title'),'FontName','helvetica', 'FontSize',14);
  
   
  xlabel( 'acot(0.5 \beta_2)');
  ylabel( 'acot(0.5 \beta_1)');
  
% 
%   
%   % x axis
%   x = beta_2;
%   y = zeros(1,numel(x));
%   plot( x, y, '--k');
  
  pause;
  close;
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [beta_1, beta_2] = getBeta( st)
% Compute beta's for three equal area subdivision

  % Compute triangle props

  % side length
  a = acos( dot( st.verts_ec(:,2), st.verts_ec(:,3)));
  b = acos( dot( st.verts_ec(:,3), st.verts_ec(:,1)));
  c = acos( dot( st.verts_ec(:,1), st.verts_ec(:,2)));

  % Compute angles of the spherical triangle
  
  % setup planes (normal form)
  nu1 = cross( st.verts_ec(:,1), st.verts_ec(:,2));
  nu2 = cross( st.verts_ec(:,2), st.verts_ec(:,3));
  nu3 = cross( st.verts_ec(:,3), st.verts_ec(:,1));
  
  n1 = nu1 / norm( nu1);           
  n2 = nu2 / norm( nu2);
  n3 = nu3 / norm( nu3);

  % compute angles  
  A = acos( dot( n1, n3));
  B = acos( dot( n1, n2));
  C = acos( dot( n2, n3));

  A_s = sin( A);
  A_c = -cot( A);
  B_s = sin( B);
  B_c = -cot( B);
  C_s = sin( C);
  C_c = -cot( C);
  
  gamma = cot( a / 4);
  
  b = cot( b/2);
  c = cot( c/2);  
    
  % plotGraph( A_s, B_s, C_s, b, c, gamma );
  
  % compute beta_2
  beta_2 = (1/6).*gamma.^(-2).*A_s.^(-1).*C_s.^(-1).*(2.*gamma.*(b.*c.*B_s.*C_s+A_s.*(c.*gamma.*C_s+B_s.*(b.*gamma+A_c.*C_s+(-2).*B_c.*C_s+C_c.*C_s)))+2.*2.^(1/3).*gamma.^2.*(b.^2.*c.^2.*B_s.^2.*C_s.^2+A_s.*B_s.*C_s.*(b.*(3+2.*c.^2).*gamma.*C_s+c.*B_s.*(3.*gamma+2.*b.^2.*gamma+2.*b.*A_c.*C_s+(-1).*b.*B_c.*C_s+(-1).*b.*C_c.*C_s))+A_s.^2.*(c.^2.*gamma.^2.*C_s.^2+(-1).*c.*gamma.*B_s.*C_s.*(b.*gamma+A_c.*C_s+(-2).*B_c.*C_s+C_c.*C_s)+B_s.^2.*(A_c.^2.*C_s.^2+B_c.^2.*C_s.^2+(-1).*B_c.*C_s.*(b.*gamma+C_c.*C_s)+(b.*gamma+C_c.*C_s).^2+(-1).*A_c.*C_s.*(b.*gamma+B_c.*C_s+C_c.*C_s)))).*(2.*b.^3.*gamma.^6.*A_s.^3.*B_s.^3+(-3).*b.^2.*c.*gamma.^6.*A_s.^3.*B_s.^2.*C_s+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+6.*b.^3.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.^3.*C_s+6.*b.^2.*gamma.^5.*A_s.^3.*B_s.^3.*C_c.*C_s+(-3).*b.*c.^2.*gamma.^6.*A_s.^3.*B_s.*C_s.^2+27.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*b.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+3.*b.^2.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+12.*b.*c.*gamma.^5.*A_c.*A_s.^3.*B_s.^2.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_c.*B_s.^2.*C_s.^2+9.*b.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+6.*b.^3.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+9.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^3.*C_s.^2+(-18).*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+(-6).*b.^2.*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+12.*b.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_s.^2.*C_c.*C_s.^2+9.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_c.*A_s.^3.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^2+6.*b.*gamma.^4.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^2+2.*c.^3.*gamma.^6.*A_s.^3.*C_s.^3+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+6.*b.*c.^3.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.*C_s.^3+6.*c.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.*C_s.^3+9.*b.^2.*c.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+6.*b.^2.*c.^3.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+(-3).*c.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+(-6).*c.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^2.*C_s.^3+6.*c.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^2.*C_s.^3+2.*b.^3.*c.^3.*gamma.^3.*B_s.^3.*C_s.^3+6.*b.^2.*c.^2.*gamma.^3.*A_c.*A_s.*B_s.^3.*C_s.^3+6.*b.*c.*gamma.^3.*A_c.^2.*A_s.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_c.^3.*A_s.^3.*B_s.^3.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_c.*B_s.^3.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_c.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_c.*B_s.^3.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_c.^2.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_c.^3.*B_s.^3.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_s.^3.*B_s.*C_c.*C_s.^3+(-18).*b.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+(-6).*b.*c.^2.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+12.*c.*gamma.^4.*A_c.*A_s.^3.*B_s.^2.*C_c.*C_s.^3+(-6).*c.*gamma.^4.*A_s.^3.*B_c.*B_s.^2.*C_c.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_s.^3.*C_c.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_s.^3.*C_c.*C_s.^3+12.*b.*c.*gamma.^3.*A_s.^2.*B_c.*B_s.^3.*C_c.*C_s.^3+12.*gamma.^3.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*c.*gamma.^4.*A_s.^3.*B_s.^2.*C_c.^2.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.*B_s.^3.*C_c.^2.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_s.^3.*C_c.^3.*C_s.^3+sqrt(gamma.^6.*((2.*b.^3.*c.^3.*B_s.^3.*C_s.^3+3.*b.*c.*A_s.*B_s.^2.*C_s.^2.*(b.*(3+2.*c.^2).*gamma.*C_s+c.*B_s.*(3.*gamma+2.*b.^2.*gamma+2.*b.*A_c.*C_s+(-1).*b.*B_c.*C_s+(-1).*b.*C_c.*C_s))+3.*A_s.^2.*B_s.*C_s.*(b.*c.*(3+2.*c.^2).*gamma.^2.*C_s.^2+(3+c.^2).*gamma.*B_s.*C_s.*(3.*gamma+b.^2.*gamma+b.*A_c.*C_s+b.*B_c.*C_s+(-2).*b.*C_c.*C_s)+c.*B_s.^2.*(3.*b.*gamma.^2+2.*b.^3.*gamma.^2+3.*gamma.*C_c.*C_s+b.^2.*gamma.*C_c.*C_s+2.*b.*A_c.^2.*C_s.^2+(-1).*b.*B_c.^2.*C_s.^2+(-1).*b.*C_c.^2.*C_s.^2+(-2).*B_c.*C_s.*((3+b.^2).*gamma+(-2).*b.*C_c.*C_s)+A_c.*C_s.*((3+b.^2).*gamma+(-2).*b.*B_c.*C_s+(-2).*b.*C_c.*C_s)))+A_s.^3.*(2.*c.^3.*gamma.^3.*C_s.^3+(-3).*c.^2.*gamma.^2.*B_s.*C_s.^2.*(b.*gamma+A_c.*C_s+(-2).*B_c.*C_s+C_c.*C_s)+(-3).*c.*gamma.*B_s.^2.*C_s.*(A_c.^2.*C_s.^2+(-2).*B_c.^2.*C_s.^2+2.*B_c.*C_s.*(b.*gamma+C_c.*C_s)+(b.*gamma+C_c.*C_s).^2+2.*A_c.*C_s.*(B_c.*C_s+(-2).*(b.*gamma+C_c.*C_s)))+B_s.^3.*(2.*A_c.^3.*C_s.^3+2.*B_c.^3.*C_s.^3+(-3).*B_c.^2.*C_s.^2.*(b.*gamma+C_c.*C_s)+(-3).*B_c.*C_s.*(b.*gamma+C_c.*C_s).^2+2.*(b.*gamma+C_c.*C_s).^3+(-3).*A_c.^2.*C_s.^2.*(b.*gamma+B_c.*C_s+C_c.*C_s)+(-3).*A_c.*C_s.*(B_c.^2.*C_s.^2+(-4).*B_c.*C_s.*(b.*gamma+C_c.*C_s)+(b.*gamma+C_c.*C_s).^2)))).^2+4.*((-1).*(b.*c.*B_s.*C_s+A_s.*(c.*gamma.*C_s+B_s.*(b.*gamma+A_c.*C_s+(-2).*B_c.*C_s+C_c.*C_s))).^2+3.*A_s.*B_s.*C_s.*((-1).*b.*gamma.*C_s+(-1).*c.*B_s.*(gamma+b.*B_c.*C_s+(-1).*b.*C_c.*C_s)+A_s.*(B_c.^2.*B_s.*C_s+c.*gamma.*(b.*gamma+C_c.*C_s)+(-1).*B_c.*(2.*c.*gamma.*C_s+B_s.*(b.*gamma+C_c.*C_s))+A_c.*(c.*gamma.*C_s+B_s.*(b.*gamma+(-1).*B_c.*C_s+C_c.*C_s))))).^3))).^(-1/3)+2.^(2/3).*(2.*b.^3.*gamma.^6.*A_s.^3.*B_s.^3+(-3).*b.^2.*c.*gamma.^6.*A_s.^3.*B_s.^2.*C_s+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+6.*b.^3.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.^3.*C_s+6.*b.^2.*gamma.^5.*A_s.^3.*B_s.^3.*C_c.*C_s+(-3).*b.*c.^2.*gamma.^6.*A_s.^3.*B_s.*C_s.^2+27.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*b.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+3.*b.^2.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+12.*b.*c.*gamma.^5.*A_c.*A_s.^3.*B_s.^2.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_c.*B_s.^2.*C_s.^2+9.*b.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+6.*b.^3.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+9.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^3.*C_s.^2+(-18).*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+(-6).*b.^2.*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+12.*b.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_s.^2.*C_c.*C_s.^2+9.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_c.*A_s.^3.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^2+6.*b.*gamma.^4.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^2+2.*c.^3.*gamma.^6.*A_s.^3.*C_s.^3+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+6.*b.*c.^3.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.*C_s.^3+6.*c.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.*C_s.^3+9.*b.^2.*c.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+6.*b.^2.*c.^3.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+(-3).*c.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+(-6).*c.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^2.*C_s.^3+6.*c.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^2.*C_s.^3+2.*b.^3.*c.^3.*gamma.^3.*B_s.^3.*C_s.^3+6.*b.^2.*c.^2.*gamma.^3.*A_c.*A_s.*B_s.^3.*C_s.^3+6.*b.*c.*gamma.^3.*A_c.^2.*A_s.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_c.^3.*A_s.^3.*B_s.^3.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_c.*B_s.^3.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_c.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_c.*B_s.^3.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_c.^2.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_c.^3.*B_s.^3.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_s.^3.*B_s.*C_c.*C_s.^3+(-18).*b.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+(-6).*b.*c.^2.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+12.*c.*gamma.^4.*A_c.*A_s.^3.*B_s.^2.*C_c.*C_s.^3+(-6).*c.*gamma.^4.*A_s.^3.*B_c.*B_s.^2.*C_c.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_s.^3.*C_c.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_s.^3.*C_c.*C_s.^3+12.*b.*c.*gamma.^3.*A_s.^2.*B_c.*B_s.^3.*C_c.*C_s.^3+12.*gamma.^3.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*c.*gamma.^4.*A_s.^3.*B_s.^2.*C_c.^2.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.*B_s.^3.*C_c.^2.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_s.^3.*C_c.^3.*C_s.^3+sqrt(gamma.^6.*((2.*b.^3.*c.^3.*B_s.^3.*C_s.^3+3.*b.*c.*A_s.*B_s.^2.*C_s.^2.*(b.*(3+2.*c.^2).*gamma.*C_s+c.*B_s.*(3.*gamma+2.*b.^2.*gamma+2.*b.*A_c.*C_s+(-1).*b.*B_c.*C_s+(-1).*b.*C_c.*C_s))+3.*A_s.^2.*B_s.*C_s.*(b.*c.*(3+2.*c.^2).*gamma.^2.*C_s.^2+(3+c.^2).*gamma.*B_s.*C_s.*(3.*gamma+b.^2.*gamma+b.*A_c.*C_s+b.*B_c.*C_s+(-2).*b.*C_c.*C_s)+c.*B_s.^2.*(3.*b.*gamma.^2+2.*b.^3.*gamma.^2+3.*gamma.*C_c.*C_s+b.^2.*gamma.*C_c.*C_s+2.*b.*A_c.^2.*C_s.^2+(-1).*b.*B_c.^2.*C_s.^2+(-1).*b.*C_c.^2.*C_s.^2+(-2).*B_c.*C_s.*((3+b.^2).*gamma+(-2).*b.*C_c.*C_s)+A_c.*C_s.*((3+b.^2).*gamma+(-2).*b.*B_c.*C_s+(-2).*b.*C_c.*C_s)))+A_s.^3.*(2.*c.^3.*gamma.^3.*C_s.^3+(-3).*c.^2.*gamma.^2.*B_s.*C_s.^2.*(b.*gamma+A_c.*C_s+(-2).*B_c.*C_s+C_c.*C_s)+(-3).*c.*gamma.*B_s.^2.*C_s.*(A_c.^2.*C_s.^2+(-2).*B_c.^2.*C_s.^2+2.*B_c.*C_s.*(b.*gamma+C_c.*C_s)+(b.*gamma+C_c.*C_s).^2+2.*A_c.*C_s.*(B_c.*C_s+(-2).*(b.*gamma+C_c.*C_s)))+B_s.^3.*(2.*A_c.^3.*C_s.^3+2.*B_c.^3.*C_s.^3+(-3).*B_c.^2.*C_s.^2.*(b.*gamma+C_c.*C_s)+(-3).*B_c.*C_s.*(b.*gamma+C_c.*C_s).^2+2.*(b.*gamma+C_c.*C_s).^3+(-3).*A_c.^2.*C_s.^2.*(b.*gamma+B_c.*C_s+C_c.*C_s)+(-3).*A_c.*C_s.*(B_c.^2.*C_s.^2+(-4).*B_c.*C_s.*(b.*gamma+C_c.*C_s)+(b.*gamma+C_c.*C_s).^2)))).^2+4.*((-1).*(b.*c.*B_s.*C_s+A_s.*(c.*gamma.*C_s+B_s.*(b.*gamma+A_c.*C_s+(-2).*B_c.*C_s+C_c.*C_s))).^2+3.*A_s.*B_s.*C_s.*((-1).*b.*gamma.*C_s+(-1).*c.*B_s.*(gamma+b.*B_c.*C_s+(-1).*b.*C_c.*C_s)+A_s.*(B_c.^2.*B_s.*C_s+c.*gamma.*(b.*gamma+C_c.*C_s)+(-1).*B_c.*(2.*c.*gamma.*C_s+B_s.*(b.*gamma+C_c.*C_s))+A_c.*(c.*gamma.*C_s+B_s.*(b.*gamma+(-1).*B_c.*C_s+C_c.*C_s))))).^3))).^(1/3));
  %if( imag( beta_2) > 10^-10)
  %  disp( sprintf( 'IMAG warning :: %20.20f', imag( beta_2)));
  %end

  % compute beta_1
  beta_1 = (C_s * (B_c * B_s - B_s * C_c + gamma * beta_2)) / (gamma * B_s);

%  disp( sprintf( 'OO :: %f10.10 / %f10.10\n',  beta_1, beta_2));
  
  % values are actually double inverse cot 
  beta_2 = 2 * acot( real(beta_2));
  beta_1 = 2 * acot( real(beta_1));
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [beta_1, beta_2] = getBeta3( st)
% Compute beta's for three equal area subdivision

  % Compute triangle props

  % side length
  a = acos( dot( st.verts_ec(:,2), st.verts_ec(:,3)));
  b = acos( dot( st.verts_ec(:,3), st.verts_ec(:,1)));
  c = acos( dot( st.verts_ec(:,1), st.verts_ec(:,2)));

  % Compute angles of the spherical triangle
  
  % setup planes (normal form)
  nu1 = cross( st.verts_ec(:,1), st.verts_ec(:,2));
  nu2 = cross( st.verts_ec(:,2), st.verts_ec(:,3));
  nu3 = cross( st.verts_ec(:,3), st.verts_ec(:,1));
  
  n1 = nu1 / norm( nu1);           
  n2 = nu2 / norm( nu2);
  n3 = nu3 / norm( nu3);

  % compute angles  
  A = acos( dot( n1, n3));
  B = acos( dot( n1, n2));
  C = acos( dot( n2, n3));

  A_s = sin( A);
  A_c = -cot( A);
  B_s = sin( B);
  B_c = -cot( B);
  C_s = sin( C);
  C_c = -cot( C);
  
  gamma =  cot( a / 4);
  
  b = cot( b/2);
  c = cot( c/2);  
    
  
  t_beta_1 = ( (B_s / gamma) * (C_s * (B_c - C_c) + (C_c - B_c) )) / (1 - B_s / C_s);
   
  
val1 = (2.*b.^3.*gamma.^6.*A_s.^3.*B_s.^3+(-3).*b.^2.*c.*gamma.^6.*A_s.^3.*B_s.^2.*C_s+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+6.*b.^3.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.^3.*C_s+6.*b.^2.*gamma.^5.*A_s.^3.*B_s.^3.*C_c.*C_s+(-3).*b.*c.^2.*gamma.^6.*A_s.^3.*B_s.*C_s.^2+27.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*b.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+3.*b.^2.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+12.*b.*c.*gamma.^5.*A_c.*A_s.^3.*B_s.^2.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_c.*B_s.^2.*C_s.^2+9.*b.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+6.*b.^3.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+9.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^3.*C_s.^2+(-18).*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+(-6).*b.^2.*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+12.*b.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_s.^2.*C_c.*C_s.^2+9.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_c.*A_s.^3.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^2+6.*b.*gamma.^4.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^2+2.*c.^3.*gamma.^6.*A_s.^3.*C_s.^3+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+6.*b.*c.^3.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.*C_s.^3+6.*c.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.*C_s.^3+9.*b.^2.*c.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+6.*b.^2.*c.^3.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+(-3).*c.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+(-6).*c.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^2.*C_s.^3+6.*c.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^2.*C_s.^3+2.*b.^3.*c.^3.*gamma.^3.*B_s.^3.*C_s.^3+6.*b.^2.*c.^2.*gamma.^3.*A_c.*A_s.*B_s.^3.*C_s.^3+6.*b.*c.*gamma.^3.*A_c.^2.*A_s.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_c.^3.*A_s.^3.*B_s.^3.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_c.*B_s.^3.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_c.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_c.*B_s.^3.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_c.^2.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_c.^3.*B_s.^3.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_s.^3.*B_s.*C_c.*C_s.^3+(-18).*b.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+(-6).*b.*c.^2.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+12.*c.*gamma.^4.*A_c.*A_s.^3.*B_s.^2.*C_c.*C_s.^3+(-6).*c.*gamma.^4.*A_s.^3.*B_c.*B_s.^2.*C_c.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_s.^3.*C_c.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_s.^3.*C_c.*C_s.^3+12.*b.*c.*gamma.^3.*A_s.^2.*B_c.*B_s.^3.*C_c.*C_s.^3+12.*gamma.^3.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*c.*gamma.^4.*A_s.^3.*B_s.^2.*C_c.^2.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.*B_s.^3.*C_c.^2.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_s.^3.*C_c.^3.*C_s.^3).^2 ;
val2 = 4.*((-1).*((-1).*b.*gamma.^2.*A_s.*B_s+(-1).*c.*gamma.^2.*A_s.*C_s+(-1).*b.*c.*gamma.*B_s.*C_s+(-1).*gamma.*A_c.*A_s.*B_s.*C_s+(-1).*gamma.*A_s.*B_c.*B_s.*C_s+2.*gamma.*A_s.*B_s.*C_c.*C_s).^2+3.*gamma.^2.*A_s.*B_s.*(b.*c.*gamma.^2.*A_s.*C_s+(-1).*c.*gamma.*B_s.*C_s+b.*gamma.*A_c.*A_s.*B_s.*C_s+b.*gamma.*A_s.*B_c.*B_s.*C_s+(-2).*b.*gamma.*A_s.*B_s.*C_c.*C_s+(-1).*b.*gamma.*C_s.^2+c.*gamma.*A_c.*A_s.*C_s.^2+b.*c.*B_c.*B_s.*C_s.^2+A_c.*A_s.*B_c.*B_s.*C_s.^2+(-1).*c.*gamma.*A_s.*C_c.*C_s.^2+(-1).*b.*c.*B_s.*C_c.*C_s.^2+(-1).*A_c.*A_s.*B_s.*C_c.*C_s.^2+(-1).*A_s.*B_c.*B_s.*C_c.*C_s.^2+A_s.*B_s.*C_c.^2.*C_s.^2)).^3;
val = val1 + val2;

temp_1 = 0;
temp_2 = 0;
if( val < 0) 

  k = 2.*b.^3.*gamma.^6.*A_s.^3.*B_s.^3+(-3).*b.^2.*c.*gamma.^6.*A_s.^3.*B_s.^2.*C_s+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+6.*b.^3.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.^3.*C_s+6.*b.^2.*gamma.^5.*A_s.^3.*B_s.^3.*C_c.*C_s+(-3).*b.*c.^2.*gamma.^6.*A_s.^3.*B_s.*C_s.^2+27.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*b.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+3.*b.^2.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+12.*b.*c.*gamma.^5.*A_c.*A_s.^3.*B_s.^2.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_c.*B_s.^2.*C_s.^2+9.*b.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+6.*b.^3.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+9.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^3.*C_s.^2+(-18).*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+(-6).*b.^2.*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+12.*b.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_s.^2.*C_c.*C_s.^2+9.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_c.*A_s.^3.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^2+6.*b.*gamma.^4.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^2+2.*c.^3.*gamma.^6.*A_s.^3.*C_s.^3+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+6.*b.*c.^3.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.*C_s.^3+6.*c.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.*C_s.^3+9.*b.^2.*c.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+6.*b.^2.*c.^3.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+(-3).*c.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+(-6).*c.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^2.*C_s.^3+6.*c.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^2.*C_s.^3+2.*b.^3.*c.^3.*gamma.^3.*B_s.^3.*C_s.^3+6.*b.^2.*c.^2.*gamma.^3.*A_c.*A_s.*B_s.^3.*C_s.^3+6.*b.*c.*gamma.^3.*A_c.^2.*A_s.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_c.^3.*A_s.^3.*B_s.^3.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_c.*B_s.^3.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_c.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_c.*B_s.^3.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_c.^2.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_c.^3.*B_s.^3.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_s.^3.*B_s.*C_c.*C_s.^3+(-18).*b.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+(-6).*b.*c.^2.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+12.*c.*gamma.^4.*A_c.*A_s.^3.*B_s.^2.*C_c.*C_s.^3+(-6).*c.*gamma.^4.*A_s.^3.*B_c.*B_s.^2.*C_c.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_s.^3.*C_c.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_s.^3.*C_c.*C_s.^3+12.*b.*c.*gamma.^3.*A_s.^2.*B_c.*B_s.^3.*C_c.*C_s.^3+12.*gamma.^3.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*c.*gamma.^4.*A_s.^3.*B_s.^2.*C_c.^2.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.*B_s.^3.*C_c.^2.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_s.^3.*C_c.^3.*C_s.^3;
  r = sqrt( k^2 + abs(val));
  a = acos( k / r);
  temp_1 = r^(1/3) * cos( 1/3 * a);
  temp_2 = r^(-1/3) * cos( -1/3 * a);
else 
  
  sqrt_val = sqrt( val);
  temp_1 = (2.*b.^3.*gamma.^6.*A_s.^3.*B_s.^3+(-3).*b.^2.*c.*gamma.^6.*A_s.^3.*B_s.^2.*C_s+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+6.*b.^3.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.^3.*C_s+6.*b.^2.*gamma.^5.*A_s.^3.*B_s.^3.*C_c.*C_s+(-3).*b.*c.^2.*gamma.^6.*A_s.^3.*B_s.*C_s.^2+27.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*b.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+3.*b.^2.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+12.*b.*c.*gamma.^5.*A_c.*A_s.^3.*B_s.^2.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_c.*B_s.^2.*C_s.^2+9.*b.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+6.*b.^3.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+9.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^3.*C_s.^2+(-18).*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+(-6).*b.^2.*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+12.*b.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_s.^2.*C_c.*C_s.^2+9.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_c.*A_s.^3.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^2+6.*b.*gamma.^4.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^2+2.*c.^3.*gamma.^6.*A_s.^3.*C_s.^3+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+6.*b.*c.^3.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.*C_s.^3+6.*c.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.*C_s.^3+9.*b.^2.*c.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+6.*b.^2.*c.^3.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+(-3).*c.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+(-6).*c.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^2.*C_s.^3+6.*c.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^2.*C_s.^3+2.*b.^3.*c.^3.*gamma.^3.*B_s.^3.*C_s.^3+6.*b.^2.*c.^2.*gamma.^3.*A_c.*A_s.*B_s.^3.*C_s.^3+6.*b.*c.*gamma.^3.*A_c.^2.*A_s.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_c.^3.*A_s.^3.*B_s.^3.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_c.*B_s.^3.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_c.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_c.*B_s.^3.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_c.^2.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_c.^3.*B_s.^3.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_s.^3.*B_s.*C_c.*C_s.^3+(-18).*b.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+(-6).*b.*c.^2.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+12.*c.*gamma.^4.*A_c.*A_s.^3.*B_s.^2.*C_c.*C_s.^3+(-6).*c.*gamma.^4.*A_s.^3.*B_c.*B_s.^2.*C_c.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_s.^3.*C_c.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_s.^3.*C_c.*C_s.^3+12.*b.*c.*gamma.^3.*A_s.^2.*B_c.*B_s.^3.*C_c.*C_s.^3+12.*gamma.^3.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*c.*gamma.^4.*A_s.^3.*B_s.^2.*C_c.^2.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.*B_s.^3.*C_c.^2.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_s.^3.*C_c.^3.*C_s.^3 + sqrt_val).^(1/3);
  temp_2 = temp_1^(-1);
  % k =     2.*b.^3.*gamma.^6.*A_s.^3.*B_s.^3+(-3).*b.^2.*c.*gamma.^6.*A_s.^3.*B_s.^2.*C_s+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+6.*b.^3.*c.*gamma.^5.*A_s.^2.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.^3.*C_s+(-3).*b.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.^3.*C_s+6.*b.^2.*gamma.^5.*A_s.^3.*B_s.^3.*C_c.*C_s+(-3).*b.*c.^2.*gamma.^6.*A_s.^3.*B_s.*C_s.^2+27.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*b.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+9.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+3.*b.^2.*c.^2.*gamma.^5.*A_s.^2.*B_s.^2.*C_s.^2+12.*b.*c.*gamma.^5.*A_c.*A_s.^3.*B_s.^2.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_c.*B_s.^2.*C_s.^2+9.*b.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+6.*b.^3.*c.^2.*gamma.^4.*A_s.*B_s.^3.*C_s.^2+9.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_c.*A_s.^2.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^3.*C_s.^2+(-18).*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+(-6).*b.^2.*c.*gamma.^4.*A_s.^2.*B_c.*B_s.^3.*C_s.^2+12.*b.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_s.^2+(-3).*b.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^2+(-6).*b.*c.*gamma.^5.*A_s.^3.*B_s.^2.*C_c.*C_s.^2+9.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+3.*b.^2.*c.*gamma.^4.*A_s.^2.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_c.*A_s.^3.*B_s.^3.*C_c.*C_s.^2+(-6).*b.*gamma.^4.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^2+6.*b.*gamma.^4.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^2+2.*c.^3.*gamma.^6.*A_s.^3.*C_s.^3+9.*b.*c.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+6.*b.*c.^3.*gamma.^5.*A_s.^2.*B_s.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_c.*A_s.^3.*B_s.*C_s.^3+6.*c.^2.*gamma.^5.*A_s.^3.*B_c.*B_s.*C_s.^3+9.*b.^2.*c.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+6.*b.^2.*c.^3.*gamma.^4.*A_s.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_c.*A_s.^2.*B_s.^2.*C_s.^3+(-3).*c.*gamma.^4.*A_c.^2.*A_s.^3.*B_s.^2.*C_s.^3+9.*b.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+3.*b.*c.^2.*gamma.^4.*A_s.^2.*B_c.*B_s.^2.*C_s.^3+(-6).*c.*gamma.^4.*A_c.*A_s.^3.*B_c.*B_s.^2.*C_s.^3+6.*c.*gamma.^4.*A_s.^3.*B_c.^2.*B_s.^2.*C_s.^3+2.*b.^3.*c.^3.*gamma.^3.*B_s.^3.*C_s.^3+6.*b.^2.*c.^2.*gamma.^3.*A_c.*A_s.*B_s.^3.*C_s.^3+6.*b.*c.*gamma.^3.*A_c.^2.*A_s.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_c.^3.*A_s.^3.*B_s.^3.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_c.*B_s.^3.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_c.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_c.*B_s.^3.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_c.^2.*B_s.^3.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_c.^2.*B_s.^3.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_c.^3.*B_s.^3.*C_s.^3+(-3).*c.^2.*gamma.^5.*A_s.^3.*B_s.*C_c.*C_s.^3+(-18).*b.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+(-6).*b.*c.^2.*gamma.^4.*A_s.^2.*B_s.^2.*C_c.*C_s.^3+12.*c.*gamma.^4.*A_c.*A_s.^3.*B_s.^2.*C_c.*C_s.^3+(-6).*c.*gamma.^4.*A_s.^3.*B_c.*B_s.^2.*C_c.*C_s.^3+(-3).*b.^2.*c.^2.*gamma.^3.*A_s.*B_s.^3.*C_c.*C_s.^3+(-6).*b.*c.*gamma.^3.*A_c.*A_s.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_c.^2.*A_s.^3.*B_s.^3.*C_c.*C_s.^3+12.*b.*c.*gamma.^3.*A_s.^2.*B_c.*B_s.^3.*C_c.*C_s.^3+12.*gamma.^3.*A_c.*A_s.^3.*B_c.*B_s.^3.*C_c.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.^2.*B_s.^3.*C_c.*C_s.^3+(-3).*c.*gamma.^4.*A_s.^3.*B_s.^2.*C_c.^2.*C_s.^3+(-3).*b.*c.*gamma.^3.*A_s.^2.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_c.*A_s.^3.*B_s.^3.*C_c.^2.*C_s.^3+(-3).*gamma.^3.*A_s.^3.*B_c.*B_s.^3.*C_c.^2.*C_s.^3+2.*gamma.^3.*A_s.^3.*B_s.^3.*C_c.^3.*C_s.^3;
end


beta_1 =  (1/3).*2.^(-1/3).*temp_1.*gamma.^(-2).*A_s.^(-1).*B_s.^(-1) ... 
  +(-1/3).*gamma.^(-2).*A_s.^(-1).*B_s.^(-1).*((-1).*b.*gamma.^2.*A_s ...
  .*B_s+(-1).*c.*gamma.^2.*A_s.*C_s+(-1).*b.*c.*gamma.*B_s.*C_s+(-1) ...
  .*gamma.*A_c.*A_s.*B_s.*C_s+(-1).*gamma.*A_s.*B_c.*B_s.*C_s+2.*gamma ...
  .*A_s.*B_s.*C_c.*C_s) ...
  + (-1/3).*2.^(1/3).*temp_2.*gamma.^(-2) ...
  .*A_s.^(-1).*B_s.^(-1).*((-1).*((-1).*b.*gamma.^2.*A_s.*B_s+(-1) ... 
  .*c.*gamma.^2.*A_s.*C_s+(-1).*b.*c.*gamma.*B_s.*C_s+(-1).*gamma.*A_c ...
  .*A_s.*B_s.*C_s+(-1).*gamma.*A_s.*B_c.*B_s.*C_s+2.*gamma.*A_s.*B_s ...
  .*C_c.*C_s).^2 ...
  + 3.*gamma.^2.*A_s.*B_s.*(b.*c.*gamma.^2.*A_s.*C_s+(-1) ...
  .*c.*gamma.*B_s.*C_s+b.*gamma.*A_c.*A_s.*B_s.*C_s+b.*gamma ...
  .*A_s.*B_c.*B_s.*C_s+(-2).*b.*gamma.*A_s.*B_s.*C_c.*C_s+(-1) ...
  .*b.*gamma.*C_s.^2+c.*gamma.*A_c.*A_s.*C_s.^2+b.*c.*B_c.*B_s.*C_s.^2 ... 
  +A_c.*A_s.*B_c.*B_s.*C_s.^2+(-1).*c.*gamma.*A_s.*C_c.*C_s.^2+(-1) ...
  .*b.*c.*B_s.*C_c.*C_s.^2+(-1).*A_c.*A_s.*B_s.*C_c.*C_s.^2+(-1) ...
  .*A_s.*B_c.*B_s.*C_c.*C_s.^2+A_s.*B_s.*C_c.^2.*C_s.^2));
% 
%  v1 = (1/3).*2.^(-1/3).*gamma.^(-2).*A_s.^(-1).*B_s.^(-1);
%  v2 = (-1/3).*2.^(1/3).*gamma.^(-2) ...
%    .*A_s.^(-1).*B_s.^(-1).*((-1).*((-1).*b.*gamma.^2.*A_s.*B_s+(-1) ... 
%    .*c.*gamma.^2.*A_s.*C_s+(-1).*b.*c.*gamma.*B_s.*C_s+(-1).*gamma.*A_c ...
%    .*A_s.*B_s.*C_s+(-1).*gamma.*A_s.*B_c.*B_s.*C_s+2.*gamma.*A_s.*B_s ...
%    .*C_c.*C_s).^2+3.*gamma.^2.*A_s.*B_s.*(b.*c.*gamma.^2.*A_s.*C_s+(-1) ...
%    .*c.*gamma.*B_s.*C_s+b.*gamma.*A_c.*A_s.*B_s.*C_s+b.*gamma ...
%    .*A_s.*B_c.*B_s.*C_s+(-2).*b.*gamma.*A_s.*B_s.*C_c.*C_s+(-1) ...
%    .*b.*gamma.*C_s.^2+c.*gamma.*A_c.*A_s.*C_s.^2+b.*c.*B_c.*B_s.*C_s.^2 ... 
%    +A_c.*A_s.*B_c.*B_s.*C_s.^2+(-1).*c.*gamma.*A_s.*C_c.*C_s.^2+(-1) ...
%    .*b.*c.*B_s.*C_c.*C_s.^2+(-1).*A_c.*A_s.*B_s.*C_c.*C_s.^2+(-1) ...
%    .*A_s.*B_c.*B_s.*C_c.*C_s.^2+A_s.*B_s.*C_c.^2.*C_s.^2));
 
% disp( sprintf( 'v1 / v2 :: %f  /  %f', v1, v2));
% diff = v2 - (v1 * abs( temp)^2);
% diff_rel = diff / ((abs(v2) + abs(v1)) / 2);
% disp( sprintf( 'diff :: %f /  %f', diff, diff_rel));
% 
% diff = v2 - (v1 * ((k^2 + abs(val)))^(1/3));
% disp( sprintf( 'diff q :: %f', diff));

% second and third solution to the cubic equation
% beta_1 = (-1/3).*gamma.^(-1).*A_s.^(-1).*((-1).*b.*gamma.*A_s+(-1).*b.*c.*C_s+(-1).*A_c.*A_s.*C_s+A_s.*C_c.*C_s)+(1/3).*2.^(-2/3).*(1+sqrt(-1).*sqrt(3)).*gamma.^(-1).*A_s.^(-1).*((-1).*((-1).*b.*gamma.*A_s+(-1).*b.*c.*C_s+(-1).*A_c.*A_s.*C_s+A_s.*C_c.*C_s).^2+3.*gamma.*A_s.*((-1).*c.*C_s+b.*A_c.*A_s.*C_s+(-1).*b.*A_s.*C_c.*C_s)).*((-27).*gamma.^2.*A_s.^2+2.*b.^3.*gamma.^3.*A_s.^3+9.*b.*c.*gamma.^2.*A_s.^2.*C_s+6.*b.^3.*c.*gamma.^2.*A_s.^2.*C_s+(-3).*b.^2.*gamma.^2.*A_c.*A_s.^3.*C_s+3.*b.^2.*gamma.^2.*A_s.^3.*C_c.*C_s+9.*b.*c.^2.*gamma.*A_s.*C_s.^2+6.*b.^3.*c.^2.*gamma.*A_s.*C_s.^2+9.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+3.*b.^2.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+(-3).*b.*gamma.*A_c.^2.*A_s.^3.*C_s.^2+(-9).*c.*gamma.*A_s.^2.*C_c.*C_s.^2+(-3).*b.^2.*c.*gamma.*A_s.^2.*C_c.*C_s.^2+6.*b.*gamma.*A_c.*A_s.^3.*C_c.*C_s.^2+(-3).*b.*gamma.*A_s.^3.*C_c.^2.*C_s.^2+2.*b.^3.*c.^3.*C_s.^3+6.*b.^2.*c.^2.*A_c.*A_s.*C_s.^3+6.*b.*c.*A_c.^2.*A_s.^2.*C_s.^3+2.*A_c.^3.*A_s.^3.*C_s.^3+(-6).*b.^2.*c.^2.*A_s.*C_c.*C_s.^3+(-12).*b.*c.*A_c.*A_s.^2.*C_c.*C_s.^3+(-6).*A_c.^2.*A_s.^3.*C_c.*C_s.^3+6.*b.*c.*A_s.^2.*C_c.^2.*C_s.^3+6.*A_c.*A_s.^3.*C_c.^2.*C_s.^3+(-2).*A_s.^3.*C_c.^3.*C_s.^3+sqrt(((-27).*gamma.^2.*A_s.^2+2.*b.^3.*gamma.^3.*A_s.^3+9.*b.*c.*gamma.^2.*A_s.^2.*C_s+6.*b.^3.*c.*gamma.^2.*A_s.^2.*C_s+(-3).*b.^2.*gamma.^2.*A_c.*A_s.^3.*C_s+3.*b.^2.*gamma.^2.*A_s.^3.*C_c.*C_s+9.*b.*c.^2.*gamma.*A_s.*C_s.^2+6.*b.^3.*c.^2.*gamma.*A_s.*C_s.^2+9.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+3.*b.^2.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+(-3).*b.*gamma.*A_c.^2.*A_s.^3.*C_s.^2+(-9).*c.*gamma.*A_s.^2.*C_c.*C_s.^2+(-3).*b.^2.*c.*gamma.*A_s.^2.*C_c.*C_s.^2+6.*b.*gamma.*A_c.*A_s.^3.*C_c.*C_s.^2+(-3).*b.*gamma.*A_s.^3.*C_c.^2.*C_s.^2+2.*b.^3.*c.^3.*C_s.^3+6.*b.^2.*c.^2.*A_c.*A_s.*C_s.^3+6.*b.*c.*A_c.^2.*A_s.^2.*C_s.^3+2.*A_c.^3.*A_s.^3.*C_s.^3+(-6).*b.^2.*c.^2.*A_s.*C_c.*C_s.^3+(-12).*b.*c.*A_c.*A_s.^2.*C_c.*C_s.^3+(-6).*A_c.^2.*A_s.^3.*C_c.*C_s.^3+6.*b.*c.*A_s.^2.*C_c.^2.*C_s.^3+6.*A_c.*A_s.^3.*C_c.^2.*C_s.^3+(-2).*A_s.^3.*C_c.^3.*C_s.^3).^2+4.*((-1).*((-1).*b.*gamma.*A_s+(-1).*b.*c.*C_s+(-1).*A_c.*A_s.*C_s+A_s.*C_c.*C_s).^2+3.*gamma.*A_s.*((-1).*c.*C_s+b.*A_c.*A_s.*C_s+(-1).*b.*A_s.*C_c.*C_s)).^3)).^(-1/3)+(-1/6).*2.^(-1/3).*(1+(sqrt(-1)*(-1)).*sqrt(3)).*gamma.^(-1).*A_s.^(-1).*((-27).*gamma.^2.*A_s.^2+2.*b.^3.*gamma.^3.*A_s.^3+9.*b.*c.*gamma.^2.*A_s.^2.*C_s+6.*b.^3.*c.*gamma.^2.*A_s.^2.*C_s+(-3).*b.^2.*gamma.^2.*A_c.*A_s.^3.*C_s+3.*b.^2.*gamma.^2.*A_s.^3.*C_c.*C_s+9.*b.*c.^2.*gamma.*A_s.*C_s.^2+6.*b.^3.*c.^2.*gamma.*A_s.*C_s.^2+9.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+3.*b.^2.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+(-3).*b.*gamma.*A_c.^2.*A_s.^3.*C_s.^2+(-9).*c.*gamma.*A_s.^2.*C_c.*C_s.^2+(-3).*b.^2.*c.*gamma.*A_s.^2.*C_c.*C_s.^2+6.*b.*gamma.*A_c.*A_s.^3.*C_c.*C_s.^2+(-3).*b.*gamma.*A_s.^3.*C_c.^2.*C_s.^2+2.*b.^3.*c.^3.*C_s.^3+6.*b.^2.*c.^2.*A_c.*A_s.*C_s.^3+6.*b.*c.*A_c.^2.*A_s.^2.*C_s.^3+2.*A_c.^3.*A_s.^3.*C_s.^3+(-6).*b.^2.*c.^2.*A_s.*C_c.*C_s.^3+(-12).*b.*c.*A_c.*A_s.^2.*C_c.*C_s.^3+(-6).*A_c.^2.*A_s.^3.*C_c.*C_s.^3+6.*b.*c.*A_s.^2.*C_c.^2.*C_s.^3+6.*A_c.*A_s.^3.*C_c.^2.*C_s.^3+(-2).*A_s.^3.*C_c.^3.*C_s.^3+sqrt(((-27).*gamma.^2.*A_s.^2+2.*b.^3.*gamma.^3.*A_s.^3+9.*b.*c.*gamma.^2.*A_s.^2.*C_s+6.*b.^3.*c.*gamma.^2.*A_s.^2.*C_s+(-3).*b.^2.*gamma.^2.*A_c.*A_s.^3.*C_s+3.*b.^2.*gamma.^2.*A_s.^3.*C_c.*C_s+9.*b.*c.^2.*gamma.*A_s.*C_s.^2+6.*b.^3.*c.^2.*gamma.*A_s.*C_s.^2+9.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+3.*b.^2.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+(-3).*b.*gamma.*A_c.^2.*A_s.^3.*C_s.^2+(-9).*c.*gamma.*A_s.^2.*C_c.*C_s.^2+(-3).*b.^2.*c.*gamma.*A_s.^2.*C_c.*C_s.^2+6.*b.*gamma.*A_c.*A_s.^3.*C_c.*C_s.^2+(-3).*b.*gamma.*A_s.^3.*C_c.^2.*C_s.^2+2.*b.^3.*c.^3.*C_s.^3+6.*b.^2.*c.^2.*A_c.*A_s.*C_s.^3+6.*b.*c.*A_c.^2.*A_s.^2.*C_s.^3+2.*A_c.^3.*A_s.^3.*C_s.^3+(-6).*b.^2.*c.^2.*A_s.*C_c.*C_s.^3+(-12).*b.*c.*A_c.*A_s.^2.*C_c.*C_s.^3+(-6).*A_c.^2.*A_s.^3.*C_c.*C_s.^3+6.*b.*c.*A_s.^2.*C_c.^2.*C_s.^3+6.*A_c.*A_s.^3.*C_c.^2.*C_s.^3+(-2).*A_s.^3.*C_c.^3.*C_s.^3).^2+4.*((-1).*((-1).*b.*gamma.*A_s+(-1).*b.*c.*C_s+(-1).*A_c.*A_s.*C_s+A_s.*C_c.*C_s).^2+3.*gamma.*A_s.*((-1).*c.*C_s+b.*A_c.*A_s.*C_s+(-1).*b.*A_s.*C_c.*C_s)).^3)).^(1/3);

% beta_1 = (-1/3).*gamma.^(-1).*A_s.^(-1).*((-1).*b.*gamma.*A_s+(-1).*b.*c.*C_s+(-1).*A_c.*A_s.*C_s+A_s.*C_c.*C_s)+(1/3).*2.^(-2/3).*(1+(sqrt(-1)*(-1)).*sqrt(3)).*gamma.^(-1).*A_s.^(-1).*((-1).*((-1).*b.*gamma.*A_s+(-1).*b.*c.*C_s+(-1).*A_c.*A_s.*C_s+A_s.*C_c.*C_s).^2+3.*gamma.*A_s.*((-1).*c.*C_s+b.*A_c.*A_s.*C_s+(-1).*b.*A_s.*C_c.*C_s)).*((-27).*gamma.^2.*A_s.^2+2.*b.^3.*gamma.^3.*A_s.^3+9.*b.*c.*gamma.^2.*A_s.^2.*C_s+6.*b.^3.*c.*gamma.^2.*A_s.^2.*C_s+(-3).*b.^2.*gamma.^2.*A_c.*A_s.^3.*C_s+3.*b.^2.*gamma.^2.*A_s.^3.*C_c.*C_s+9.*b.*c.^2.*gamma.*A_s.*C_s.^2+6.*b.^3.*c.^2.*gamma.*A_s.*C_s.^2+9.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+3.*b.^2.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+(-3).*b.*gamma.*A_c.^2.*A_s.^3.*C_s.^2+(-9).*c.*gamma.*A_s.^2.*C_c.*C_s.^2+(-3).*b.^2.*c.*gamma.*A_s.^2.*C_c.*C_s.^2+6.*b.*gamma.*A_c.*A_s.^3.*C_c.*C_s.^2+(-3).*b.*gamma.*A_s.^3.*C_c.^2.*C_s.^2+2.*b.^3.*c.^3.*C_s.^3+6.*b.^2.*c.^2.*A_c.*A_s.*C_s.^3+6.*b.*c.*A_c.^2.*A_s.^2.*C_s.^3+2.*A_c.^3.*A_s.^3.*C_s.^3+(-6).*b.^2.*c.^2.*A_s.*C_c.*C_s.^3+(-12).*b.*c.*A_c.*A_s.^2.*C_c.*C_s.^3+(-6).*A_c.^2.*A_s.^3.*C_c.*C_s.^3+6.*b.*c.*A_s.^2.*C_c.^2.*C_s.^3+6.*A_c.*A_s.^3.*C_c.^2.*C_s.^3+(-2).*A_s.^3.*C_c.^3.*C_s.^3+sqrt(((-27).*gamma.^2.*A_s.^2+2.*b.^3.*gamma.^3.*A_s.^3+9.*b.*c.*gamma.^2.*A_s.^2.*C_s+6.*b.^3.*c.*gamma.^2.*A_s.^2.*C_s+(-3).*b.^2.*gamma.^2.*A_c.*A_s.^3.*C_s+3.*b.^2.*gamma.^2.*A_s.^3.*C_c.*C_s+9.*b.*c.^2.*gamma.*A_s.*C_s.^2+6.*b.^3.*c.^2.*gamma.*A_s.*C_s.^2+9.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+3.*b.^2.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+(-3).*b.*gamma.*A_c.^2.*A_s.^3.*C_s.^2+(-9).*c.*gamma.*A_s.^2.*C_c.*C_s.^2+(-3).*b.^2.*c.*gamma.*A_s.^2.*C_c.*C_s.^2+6.*b.*gamma.*A_c.*A_s.^3.*C_c.*C_s.^2+(-3).*b.*gamma.*A_s.^3.*C_c.^2.*C_s.^2+2.*b.^3.*c.^3.*C_s.^3+6.*b.^2.*c.^2.*A_c.*A_s.*C_s.^3+6.*b.*c.*A_c.^2.*A_s.^2.*C_s.^3+2.*A_c.^3.*A_s.^3.*C_s.^3+(-6).*b.^2.*c.^2.*A_s.*C_c.*C_s.^3+(-12).*b.*c.*A_c.*A_s.^2.*C_c.*C_s.^3+(-6).*A_c.^2.*A_s.^3.*C_c.*C_s.^3+6.*b.*c.*A_s.^2.*C_c.^2.*C_s.^3+6.*A_c.*A_s.^3.*C_c.^2.*C_s.^3+(-2).*A_s.^3.*C_c.^3.*C_s.^3).^2+4.*((-1).*((-1).*b.*gamma.*A_s+(-1).*b.*c.*C_s+(-1).*A_c.*A_s.*C_s+A_s.*C_c.*C_s).^2+3.*gamma.*A_s.*((-1).*c.*C_s+b.*A_c.*A_s.*C_s+(-1).*b.*A_s.*C_c.*C_s)).^3)).^(-1/3)+(-1/6).*2.^(-1/3).*(1+sqrt(-1).*sqrt(3)).*gamma.^(-1).*A_s.^(-1).*((-27).*gamma.^2.*A_s.^2+2.*b.^3.*gamma.^3.*A_s.^3+9.*b.*c.*gamma.^2.*A_s.^2.*C_s+6.*b.^3.*c.*gamma.^2.*A_s.^2.*C_s+(-3).*b.^2.*gamma.^2.*A_c.*A_s.^3.*C_s+3.*b.^2.*gamma.^2.*A_s.^3.*C_c.*C_s+9.*b.*c.^2.*gamma.*A_s.*C_s.^2+6.*b.^3.*c.^2.*gamma.*A_s.*C_s.^2+9.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+3.*b.^2.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+(-3).*b.*gamma.*A_c.^2.*A_s.^3.*C_s.^2+(-9).*c.*gamma.*A_s.^2.*C_c.*C_s.^2+(-3).*b.^2.*c.*gamma.*A_s.^2.*C_c.*C_s.^2+6.*b.*gamma.*A_c.*A_s.^3.*C_c.*C_s.^2+(-3).*b.*gamma.*A_s.^3.*C_c.^2.*C_s.^2+2.*b.^3.*c.^3.*C_s.^3+6.*b.^2.*c.^2.*A_c.*A_s.*C_s.^3+6.*b.*c.*A_c.^2.*A_s.^2.*C_s.^3+2.*A_c.^3.*A_s.^3.*C_s.^3+(-6).*b.^2.*c.^2.*A_s.*C_c.*C_s.^3+(-12).*b.*c.*A_c.*A_s.^2.*C_c.*C_s.^3+(-6).*A_c.^2.*A_s.^3.*C_c.*C_s.^3+6.*b.*c.*A_s.^2.*C_c.^2.*C_s.^3+6.*A_c.*A_s.^3.*C_c.^2.*C_s.^3+(-2).*A_s.^3.*C_c.^3.*C_s.^3+sqrt(((-27).*gamma.^2.*A_s.^2+2.*b.^3.*gamma.^3.*A_s.^3+9.*b.*c.*gamma.^2.*A_s.^2.*C_s+6.*b.^3.*c.*gamma.^2.*A_s.^2.*C_s+(-3).*b.^2.*gamma.^2.*A_c.*A_s.^3.*C_s+3.*b.^2.*gamma.^2.*A_s.^3.*C_c.*C_s+9.*b.*c.^2.*gamma.*A_s.*C_s.^2+6.*b.^3.*c.^2.*gamma.*A_s.*C_s.^2+9.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+3.*b.^2.*c.*gamma.*A_c.*A_s.^2.*C_s.^2+(-3).*b.*gamma.*A_c.^2.*A_s.^3.*C_s.^2+(-9).*c.*gamma.*A_s.^2.*C_c.*C_s.^2+(-3).*b.^2.*c.*gamma.*A_s.^2.*C_c.*C_s.^2+6.*b.*gamma.*A_c.*A_s.^3.*C_c.*C_s.^2+(-3).*b.*gamma.*A_s.^3.*C_c.^2.*C_s.^2+2.*b.^3.*c.^3.*C_s.^3+6.*b.^2.*c.^2.*A_c.*A_s.*C_s.^3+6.*b.*c.*A_c.^2.*A_s.^2.*C_s.^3+2.*A_c.^3.*A_s.^3.*C_s.^3+(-6).*b.^2.*c.^2.*A_s.*C_c.*C_s.^3+(-12).*b.*c.*A_c.*A_s.^2.*C_c.*C_s.^3+(-6).*A_c.^2.*A_s.^3.*C_c.*C_s.^3+6.*b.*c.*A_s.^2.*C_c.^2.*C_s.^3+6.*A_c.*A_s.^3.*C_c.^2.*C_s.^3+(-2).*A_s.^3.*C_c.^3.*C_s.^3).^2+4.*((-1).*((-1).*b.*gamma.*A_s+(-1).*b.*c.*C_s+(-1).*A_c.*A_s.*C_s+A_s.*C_c.*C_s).^2+3.*gamma.*A_s.*((-1).*c.*C_s+b.*A_c.*A_s.*C_s+(-1).*b.*A_s.*C_c.*C_s)).^3)).^(1/3);


beta_2 = (c.*C_s+(-1).*b.*A_c.*A_s.*...
  C_s+b.*A_s.*C_c.*C_s+b.*gamma.* ...
  A_s.*beta_1+b.*c.*C_s.*beta_1+A_c ...
  .*A_s.*C_s.*beta_1+(-1).*A_s.* ...
  C_c.*C_s.*beta_1+(-1).*gamma.*A_s.* ...
  beta_1.^2).^(-1).*((-1).*C_s+(-1).*b.*c.* ...
  A_c.*A_s.*C_s+b.*c.*A_s.*C_c ...
  .*C_s+b.*c.*gamma.*A_s.*beta_1+(-1).*b.* ...
  C_s.*beta_1+c.*A_c.*A_s.* ...
  C_s.*beta_1+(-1).*c.*A_s.*C_c.* ...
  C_s.*beta_1+(-1).*c.*gamma.*A_s.* ...
  beta_1.^2);
 
 % disp( sprintf( 'NN :: %f10.10 / %f10.10\n',  beta_1, beta_2));
  
  % values are actually double inverse cot 
  beta_2 = 2 * acot( real(beta_2));
  beta_1 = 2 * acot( real(beta_1));
  
  % plotGraph( A_s, B_s, C_s, A_c, B_c, C_c, b, c, gamma, beta_1, beta_2, st );
 
end

