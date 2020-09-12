function thetaREst = Geometry(thetaDEst)
global P
temp = sind(thetaDEst) * 2 * P.R * (P.re + P.hr) + P.R^2 + (P.re + P.hr)^2;
htEst = sqrt(temp) - P.re;

N = P.R^2 - (htEst - P.hr).^2;
D = 4*(P.hr + P.re) * (htEst + P.re);
r = 2 * P.re * asin(sqrt(N./D));
p1 = 2/sqrt(3) * sqrt(P.re * (htEst + P.hr) + r.^2/4);
zeta = asin(2*P.re * r .* (htEst - P.hr)./(p1.^3));
r1 = r/2 - p1 .* sin(zeta/3);
r2 = r - r1;
% R1 = sqrt(P.re^2 + (P.re + P.hr)^2 - 2*P.re*(P.re+P.hr) * cos(r1/P.re));
% R2 = sqrt(P.re^2 + (P.re + htEst).^2 - 2*P.re*(P.re+htEst) .* cos(r2/P.re));

R1 = sqrt(P.hr^2 + 4 * P.re * (P.re + P.hr) * sin(r1/P.re).^2);
R2 = sqrt(P.ht.^2 + 4 * P.re * (P.re + P.ht) .* sin(r2/P.re).^2);

% thetaREst = asind((P.hr/R1) + (R1/2/P.re));
thetaREst = - asind(((P.re+P.ht).^2 - P.R.^2 - (P.re + P.hr)^2)/2./P.R/(P.re+P.hr));

end
 