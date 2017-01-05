function [l,s,r,lc0,sc0,rc0,lcN,scN,rcN,err,r2,fit] = color_fit_nk_rods(Lc,Sc,Rc,data,L0,S0,R0,Lc00,Sc00,Rc00,Ln0,Sn0,Rn0);
% COLOR_FIT Fit L and S responses to color-exchange-style stims
%
%  [L,S,ERR,R2] = COLOR_FIT(LC,SC,RESPONSES,L0,S0,Lc00,Sc00)
%
%  Finds the best fit to the function
%    R(LC,SC) = ABS(L*LC./(abs(LC)+Lc0)+S*SC./(abs(SC)+Sc0))
%  where *C is the *-cone contrast present in the stimulus and *c0 is the
%  half maximum of the contrast response function.  Contrast
%  should be in the interval [-1 1], where sign indicates relative 
%  contrast phase.  L is constrained to be greater than or equal to zero,
%  so the sign of S indicates phase of S relatively to L.
%
%  L0 and S0 are the initial conditions for the search.
%  ERR is squared error of fit, and R^2 is r squared.
  

% initial conditions
xo = [L0 S0 R0 Lc00 Sc00 Rc00 Ln0 Sn0 Rn0];
options= optimset('Display','off','MaxFunEvals',10000,'TolX',1e-6);
[x] = fminsearch(@(x) color_fit_nk_rods_err(x,Lc,Sc,Rc,data),xo,options);
if x(1)<0, x(1:3) = -x(1:3); end;
l=x(1);s=x(2);r=x(3);
c0Int = [0.1 0.5];
NInt = [1 5];
lc0=c0Int(1)+diff(c0Int)/(1+abs(x(4)));
sc0=c0Int(1)+diff(c0Int)/(1+abs(x(5))); 
rc0=c0Int(1)+diff(c0Int)/(1+abs(x(6))); 
lcN=NInt(1)+diff(NInt)/(1+abs(x(7)));
scN=NInt(1)+diff(NInt)/(1+abs(x(8)));
rcN=NInt(1)+diff(NInt)/(1+abs(x(9)));
[err,fit] = color_fit_nk_rods_err(x,Lc,Sc,Rc,data);
r2 = 1 - err/(sum((data-mean(data)).^2));