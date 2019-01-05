function [Y,theta,phi,dems,dels]= shEvalStable(l,m,theta,phi,check,tol,blox)
% [Y,theta,phi,dems,dels]=YLM(l,m,theta,phi,check,tol,blox)
%
% Calculates normalized real spherical harmonics, DT (B.72).
%
% INPUT:
%
% l      degree (0 <= l <= infinity) [default: random]
% m      order (-l <= m <= l)        [default: all orders -l:l]
%        l and m can be vectors, but not both at the same time
% theta  colatitude (0<=theta<=pi) [default: 181 linearly spaced; not NaN!]
% phi    longitude  (0<=theta<=pi) [default: 361 linearly spaced]
% check  1 optional normalization check by Gauss-Legendre quadrature
%        0 no normalization check
% tol    Tolerance for optional normalization checking
% blox   0 Standard (lm) ordering, l=0:L, m=-l:l
%        1 Block-diagonal ordering, m=-L:L, l=abs(m):L
%
% OUTPUT:
%
% Y      The real spherical harmonics at the desired argument(s):
%           As matrix with dimensions of 
%           length(theta) x length(phi) x max(length(m),length(l)) OR
%           (L+1)^2 x (length(theta)*length(phi)) if you put in
%           a degreel=[0 L] and an order []: lists orders -l to l.
% theta  The latitude(s), which you might or not have specified
% phi    The longitude(s), which you might or not have specified
% dems   The orders to which the Ylms belong
% dems   The degrees to which the Ylms belong
%
% See also: XLM
%
% EXAMPLES:
%
% plotplm(ylm(2,-1,[],[],1),[],[],1); colormap(flipud(gray(7)))
% Y=ylm(0:10);
%
% Last modified by fjsimons-at-alum.mit.edu, 01/18/2008

  % Default values
  defval('l',round(rand*10))
  defval('m',[])
  defval('theta',linspace(0,pi,181))
  defval('phi',linspace(0,2*pi,360))
  defval('check',0)
  defval('tol',1e-10)
  defval('blox',0)

  if blox~=0 & blox~=1
    error('Specify valid block-sorting option ''blox''')
  end

  % Make sure phi is a row vector
  phi=phi(:)';

  % Revert back to cos(theta)
  mu=cos(theta);

  % If the degrees go from 0 to some L and m is empty, know what to do
  if min(l)==0 & max(l)>0 & isempty(m)
    [PH,TH]=meshgrid(phi,theta);
    Y=repmat(NaN,(max(l)+1)^2,length(TH(:)));
    for thel=0:max(l)
      theY=reshape(ylm(thel,-thel:thel,theta,phi,check,tol),...
       length(TH(:)),2*thel+1)';
      Y(thel^2+1:(thel+1)^2,:)=theY;
    end
    theta=TH(:);
    phi=PH(:);

    [dems,dels,mz,blkm]=addmout(max(l));
    if blox==1
      Y=Y(blkm,:);
      dems=dems(blkm);
      dels=dels(blkm);
    end
    return
  end

  % Error handling common to PLM, XLM, YLM
  [l,m,mu,check,tol]=pxyerh(l,m,mu,check,tol);

  % Straight to the calculation, check normalization on the XLM
  % Can make this faster, obviously, we're doing twice the work here
  [X,theta,dems]=xlm(l,abs(m),theta,check);

  % Initialize the matrix with the spherical harmonics
  Y=repmat(NaN,[length(theta) length(phi) max(length(m),length(l))]);

  % Make the longitudinal phase: ones, sines or cosines, sqrt(2) or not 
  P=diag(sqrt(2-(m(:)==0)))*...
    cos(m(:)*phi-pi/2*(m(:)>0)*ones(size(phi)));

  % Make the real spherical harmonics
  if prod(size(l))==1 & prod(size(m))==1
   Y=X'*P;
  else
    for index=1:max(length(m),length(m))
      Y(:,:,index)=X(index,:)'*P(index,:);
    end
  end
  
end

