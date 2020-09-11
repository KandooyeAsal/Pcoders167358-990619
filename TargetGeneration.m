function [signal,thetaD] = TargetGeneration
global P
P.re = earthRadius * 4/3;
sigma = 4.3;
e = 80;
sigmaH = 0.4;

N = P.R.^2 - (P.ht - P.hr).^2;
D = 4*(P.hr + P.re) * (P.ht + P.re);
r = 2 * P.re * asin(sqrt(N./D));
p1 = 2/sqrt(3) * sqrt(P.re * (P.ht + P.hr) + r.^2/4);
zeta = asin(2*P.re * r .* (P.ht - P.hr)./(p1.^3));
r1 = r/2 - p1 .* sin(zeta/3);
r2 = r - r1;

R1 = sqrt(P.re^2 + (P.re + P.hr)^2 - 2*P.re*(P.re+P.hr) * cos(r1/P.re));
R2 = sqrt(P.re^2 + (P.re + P.ht).^2 - 2*P.re*(P.re+P.ht) .* cos(r2/P.re));
thetaR = asind(P.hr./R1 + R1/2/P.re);
thetaD = asind(((P.re+P.ht).^2 - P.R.^2 - (P.re + P.hr)^2)/2./P.R/(P.re+P.hr));

psiG = asind(P.hr./R1 - R1/2/P.re);
epsC = e - 1i * 60 * P.lambda * sigma;
gamma = (sind(psiG) - sqrt(epsC - cosd(psiG).^2))/(sind(psiG) + sqrt(epsC - cosd(psiG).^2));

deltaPhi = - 2 * pi * (P.R - (R1 + R2))/P.lambda;
gamma2 = sigmaH * sind(psiG)/P.lambda;
idx = gamma2 <= 0.1;
rhoS(idx) = exp(-2*(2*pi*gamma2(idx)).^2);
rhoS(~idx) = 0.812537./(1 + 2 * (2*pi * gamma2(~idx)).^2);

divergCoef = (1 + 2 * r1 .* r2/P.re./r/sind(psiG)).^(-0.5);

sd = 1;
sr = gamma * divergCoef * rhoS .* exp(-1i * deltaPhi) * sd;

for i = 1:length(thetaD)
    [~,idxThetaD] = min(abs(P.thetaS - thetaD(i)));
    [~,idxThetaR] = min(abs(P.thetaS - thetaR(i)));
    target = sd * P.steer(:,idxThetaD) + sr(i) * P.steer(:,idxThetaR);
    noise = (randn(size(target)) + 1i * randn(size(target)))/sqrt(2*10^P.SNR/10);
    signal(:,i) = target/max(abs(target)) + noise;
end

end
