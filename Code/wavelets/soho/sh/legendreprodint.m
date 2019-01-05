function [in,inun]=legendreprodint(L1,m1,L2,m2,x0,method)
% [in,inun]=legendreprodint(L1,m1,L2,m2,x0,method)
%
% Evaluates the integral of the product of two Schmidt semi-normalized
% real Legendre polynomials P_lm(x)P_l'm'(x)dx from x to 1. In our
% notation, this is 4*pi*Ylm/sqrt(2l+1)*Yl'm'/sqrt(2l'+1).
%
% \int_{0}^{\theta_0}P_{L1,m1}(\cos(\theta))...
%    P_{L2,m2}(\cos(\theta))\sin(\theta)\,d\theta
% or indeed \int_{x0}^{1}P_{L1,m1}(x)P_{L2,m2}(x)\,dx
%
% The normalization is such that the integration amounts to
% (4-2*(m==0))/(2l+1) over the entire interval from -1 to 1,
% This normalizes the spherical harmonics to 4\pi/(2l+1).
% Note Schmidt contains the sqrt(2) multiplying Xlm.
%
% INPUT:
%
% L1,L2        Angular degrees of the polynomials, L1,L2>=0
% m1,m2        Angular orders of the polynomials, 0<=m<=L
% x0           Single point with lower integration limit
% method      'automatic' Using analytical formula if possible (default)
%             'dumb' Forcing usage of dumb semi-analytical formula
%             'gl'   Exact result by Gauss-Legendre integration, when m1~=m2
%
% OUTPUT:
%
% in           The integrated product. 
% inun         The result multiplied by (2L1+1)/(4-2*(m==0))
%
% EXAMPLE:
%
% legendreprodint('demo1') Wigner recursion vs. Gauss-Legendre, L1=L2, m=0
% legendreprodint('demo2') Wigner recursion vs. Gauss-Legendre, L1~=L2, m=0
% legendreprodint('demo3') Dumb summation vs. Gauss-Legendre, L1=L2, m=0
%
% EXAMPLE: Verify analytical formulas:
%
% L=7; m=0; x1=-0.3;
% I1=legendreprodint(7,0,0,0,-0.3);
% I2=1./(2*L+1)*(indeks(legendre(L-1,x1,'sch'),1)-indeks(legendre(L+1,x1,'sch'),1));
% I3=(1-x1^2)/L/(L+1)*legendrediff(L,x1,'sch');
% [I1-I2 I1-I3 I2-I3]
%
% Last modified by fjsimons-at-alum.mit.edu, 10/20/2006

% Set to 1 if you want to calculate the wigner3j symbols for the diagonal
% elements 
reco=0;

if ~isstr(L1)
  defval('L1',1)
  defval('m1',0)
  defval('L2',2)
  defval('m2',0)
  defval('x0',0)
  defval('method','automatic')

  if length(x0)~=1
    error('Not for multiple limits')
  end
  % Standard spherical harmonics restrictions using LEGENDRE or LIBBRECHT 
  if m1>L1 | m2>L2 | m1<0 | m2<0
    error('Order must be smaller or equal than degree; Real spherical harmonics')
  end
%  disp(sprintf('Legendreprodint using %s',method))

  if m1==0 & m2==0 & ~strcmp(method,'gl')
    % For unequal L1 and L2, may use Byerly's method
    if L1~=L2
      % Analytical method from Byerly (1959) p.172.
      % http://mathworld.wolfram.com/LegendrePolynomial.html
      if L1>255 | L2>255
	PL1=rindeks(libbrecht(L1,x0,'sch'),1);
	PL2=rindeks(libbrecht(L2,x0,'sch'),1);
	PL1m1=rindeks(libbrecht(L1-1*(L1~=0),x0,'sch'),1);
	PL2m1=rindeks(libbrecht(L2-1*(L2~=0),x0,'sch'),1);
      else 
	PL1=rindeks(legendre(L1,x0,'sch'),1);
	PL2=rindeks(legendre(L2,x0,'sch'),1);
	PL1m1=rindeks(legendre(L1-1*(L1~=0),x0,'sch'),1);
	PL2m1=rindeks(legendre(L2-1*(L2~=0),x0,'sch'),1);
      end
      % Calculate integral analytically and fast
      in=-1/(L2*(L2+1)-L1*(L1+1))*...
	 ((L2-L1)*x0.*PL1.*PL2-...
	  L2*PL1.*PL2m1+...
	  L1*PL2.*PL1m1);
    else
      % For equal L1 and L2 and zonal, two methods are available
      switch method
       case 'automatic'
	% \intl_{x}^{1}P_l^2(x)\,dx=\frac{1-x}{2l+1}+\suml_{k=1}^{l}
	% (4k+1)\wigner{l,l,2k,0,0,0}^2\frac{\left[P_{2k-1}-xP_{2k}\right]}{2k+1}.
	% All expansion coefficients at once, for unnormalized Legendre
	% Force the 'recon' value to recompute the whole series
	% W2=wigner3j(L1,L2,2*L1,0,0,0,'recu',reco).^2;
	% Newest thing Oct 20th
	W2=wigner0j(2*L1,L2,L1).^2;
	% First term is zeroth order, we add it explicitly
	in=(1-x0)/(2*L1+1);
	% Only even terms are non-zero
	for k=1:L1
	  j=2*k;
	  if j>255
	    in=in+(2*j+1)*W2(j+1)/(j+1)*...
	       (rindeks(libbrecht(j-1,x0,'sch'),1)-...
		x0*rindeks(libbrecht(j,x0,'sch'),1));
	  else 
	    in=in+(2*j+1)*W2(j+1)/(j+1)*...
	       (rindeks(legendre(j-1,x0,'sch'),1)-...
		x0*rindeks(legendre(j,x0,'sch'),1));
	  end
	end
       case 'dumb' % Need symbolic math toolbox!
	term1=1/(2*L1+1)*(2^(2*L1+1)-(x0+1)^(2*L1+1));
	M=[0:L1-1]';
	% The factorials from (l+1)! up to (2l)!
	% lpmp1=indeks(cumprod([M+1 ; L1+M+1]),L1+1:2*L1);
	% The factorials from 1! all the way up to l! or (l-m)!
	lmm=flipud(cumprod(flipud(L1-M)));
	% pref=factorial(2*L1)./lmm./lpmp1;
	% The products from (l+2)...(2l) which replace (2l)!/(l+m+1)!
	l22l=flipud(cumprod([1 ; 2*L1-M(1:end-1)]));
	pref=l22l./lmm;
	term2=sum(pref.*(-1).^(L1+M+1).*(x0-1).^(L1-M).*(x0+1).^(L1+M+1),1);
	% A little bit of symbolic math here: need toolbox!
	X=sym('(x0^2-1)');
	term3=0;
	for m=0:L1-1
	  term3=term3+(-1)^(m+1)*diff(X^L1,L1+m)*diff(X^L1,L1-m-1);
	end     
	if L1~=0
	  term3=eval(term3)/factorial(L1)^2;
	end
	in=(term1+term2+term3)/(2^(2*L1));
      end  
    end
  else % If 'gl' requested by the user or required by the problem
    % Using Gauss-Legendre integration from
    % http://mathworld.wolfram.com/Legendre-GaussQuadrature.html
    % Formulate the integrand as an inline function
    integrand=inline(sprintf(...
	['rindeks(legendre(%i,x,''sch''),%i).*',...
	'rindeks(legendre(%i,x,''sch''),%i)'],...
	L1,m1+1,L2,m2+1));
    % Calculate the Gauss-Legendre coefficients    
    % Watch out: multiply if m is not 0
    [w,xgl,nsel]=gausslegendrecof(max(L1+L2,200*((m1*m2)~=0)));
    % Calculate integral
    in=gausslegendre([x0 1],integrand,[w(:) xgl(:)]);
    % disp(sprintf('Gauss-Legendre with %i points',nsel))
  end
  inun=in*(2*L1+1)/(4-2*(m1==0));
elseif strcmp(L1,'demo1')
  % For equal L and m=0, Wigner recursive formula vs Gauss-Legendre 
  L1=ceil(20*rand(20,1))+1;
  L2=L1; 
  [m1,m2]=deal(zeros(size(L1))); 
  theta=rand(20,1);
  for index=1:length(L1)
    tic
    inan(index)=legendreprodint(L1(index),m1(index),L2(index),m2(index),...
				cos(theta(index)),'automatic');
    tican(index)=toc; tic
    ingl(index)=legendreprodint(L1(index),m1(index),L2(index),m2(index),...
				cos(theta(index)),'gl');
    ticgl(index)=toc;
  end
  clf
  ah(1)=subplot(121); p{1}=plot(L1+L2,abs(inan-ingl)/eps,'s'); 
  grid on; tl(1)=title('Relative accuracy');
  xl(1)=xlabel('Product degree, equal L'); 
  yl(1)=ylabel(sprintf('abs(error) %s eps','/'));
  ah(2)=subplot(122); p{2}=plot(L1+L2,tican,'bo',L1+L2,ticgl,'kv');
  tl(2)=title('Time Cost'); 
  xl(2)=xlabel('Product degree, equal L');
  yl(2)=ylabel('seconds'); yll=ylim; ylim([0 yll(2)])
  set(p{1},'MarkerF','k','MarkerE','k')
  set(p{2}(1),'MarkerF','k','MarkerE','k')
  set(p{2}(2),'MarkerF','k','MarkerE','k')
  set(ah(2),'YScale','lin')
  l=legend('Wigner 3{\it{j}}','Gauss-Legendre',4);
  grid on; longticks(ah); figdisp('legendreprodint3')
  set([xl yl tl],'FontS',12)
elseif strcmp(L1,'demo2')
  % For unequal L and m=0, Byerlee's formula vs Gauss-Legendre 
  L1=ceil(20*rand(20,1))+1;
  L2=ceil(20*rand(20,1))+1;
  L2(L1==L2)=L2(L1==L2)+1; % Make sure they are definitely different
  [m1,m2]=deal(zeros(size(L1))); 
  [m1,m2]=deal(zeros(size(L1))); 
  theta=rand(20,1);
  for index=1:length(L1)
    tic
    inan(index)=legendreprodint(L1(index),m1(index),L2(index),m2(index),...
				cos(theta(index)),'automatic');
    tican(index)=toc; tic
    ingl(index)=legendreprodint(L1(index),m1(index),L2(index),m2(index),...
				cos(theta(index)),'gl');
    ticgl(index)=toc;
  end
  clf
  ah(1)=subplot(121); p{1}=plot(L1+L2,abs(inan-ingl)/eps,'s'); 
  grid on; tl(1)=title('Relative accuracy');
  xl(1)=xlabel('Product degree, unequal L');
  yl(1)=ylabel(sprintf('abs(error) %s eps','/'));
  ah(2)=subplot(122); p{2}=plot(L1+L2,tican,'bo',L1+L2,ticgl,'kv');
  tl(2)=title('Time Cost'); xl(2)=xlabel('Product degree, unequal L');
  yl(2)=ylabel('seconds');
  yll=ylim; ylim([0 yll(2)])
  set(p{1},'MarkerF','k','MarkerE','k')
  set(p{2}(1),'MarkerF','k','MarkerE','k')
  set(p{2}(2),'MarkerF','k','MarkerE','k')
  set(ah(2),'YScale','lin')
  l=legend('Byerlee','Gauss-Legendre',4);
  grid on; longticks(ah); figdisp('legendreprodint1')
  set([xl yl tl],'FontS',12)
elseif strcmp(L1,'demo3')
  % For equal L and m=0, Dumb summation formula vs Gauss-Legendre 
  L1=ceil(20*rand(20,1))+1;
  L2=L1; 
  [m1,m2]=deal(zeros(size(L1))); 
  theta=rand(20,1);
  for index=1:length(L1)
    tic
    inan(index)=legendreprodint(L1(index),m1(index),L2(index),m2(index),...
				cos(theta(index)),'dumb');
    tican(index)=toc; tic
    ingl(index)=legendreprodint(L1(index),m1(index),L2(index),m2(index),...
				cos(theta(index)),'gl');
    ticgl(index)=toc;
  end
  clf
  ah(1)=subplot(121); p{1}=plot(L1+L2,abs(inan-ingl)/eps,'s'); 
  grid on; tl(1)=title('Relative accuracy');
  xl(1)=xlabel('Product degree, equal L');
  yl(1)=ylabel(sprintf('abs(error) %s eps','/'));
  ah(2)=subplot(122); p{2}=plot(L1+L2,tican,'bo',L1+L2,ticgl,'kv');
  tl(2)=title('Time Cost'); xl(2)=xlabel('Product degree, equal L'); 
  yl(2)=ylabel('seconds'); yll=ylim; ylim([0 yll(2)])
  set(p{1},'MarkerF','k','MarkerE','k')
  set(p{2}(1),'MarkerF','k','MarkerE','k')
  set(p{2}(2),'MarkerF','k','MarkerE','k')
  set(ah(2),'YScale','Log')
  l=legend('Semi-analytical','Gauss-Legendre',2);
  grid on; longticks(ah); figdisp('legendreprodint2')
    set([xl yl tl],'FontS',12)
end


