function signal = TargetGeneration
global P
re = earthRadius * 4/3;

hr = 15;
R = 5e3;
ht = 10:60;
sigma = 4.3;
e = 80;
sigmaH = 0.4;

N = R^2 - (ht - hr).^2;
D = 4*(hr + re) * (ht + re);
r = 2 * re * asin(sqrt(N./D));
p1 = 2/sqrt(3) * sqrt(re * (ht + hr) + r.^2/4);
zeta = asin(2*re * r .* (ht - hr)./(p1.^3));
r1 = r/2 - p1 .* sin(zeta/3);
r2 = r - r1;

R1 = sqrt(re^2 + (re + hr)^2 - 2*re*(re+hr) * cos(r1/re));
R2 = sqrt(re^2 + (re + ht).^2 - 2*re*(re+ht) .* cos(r2/re));
thetaR = asind(hr./R1 + R1/2/re);
thetaD = asind(((re+ht).^2 - R^2 - (re + hr)^2)/2/R/(re+hr));

psiG = asind(hr./R1 - R1/2/re);
epsC = e - 1i * 60 * P.lambda * sigma;
gamma = (sind(psiG) - sqrt(epsC - cosd(psiG).^2))/(sind(psiG) + sqrt(epsC - cosd(psiG).^2));

deltaPhi = - 2 * pi * (R - (R1 + R2))/P.lambda;
gamma2 = sigmaH * sind(psiG)/P.lambda;
idx = gamma2 <= 0.1;
rhoS(idx) = exp(-2*(2*pi*gamma2(idx)).^2);
rhoS(~idx) = 0.812537./(1 + 2 * (2*pi * gamma2(~idx)).^2);

divergCoef = (1 + 2 * r1 .* r2/re./r/sind(psiG)).^(-0.5);

sd = 1;


sr = gamma * divergCoef * rhoS .* exp(-1i * deltaPhi) * sd;

[~,idxThetaD] = min(abs(P.thetaS - thetaD.'));
[~,idxThetaR] = min(abs(P.thetaS - thetaR));

target = sd * P.steer(:,idxThetaD) + sr * P.steer(:,idxThetaR);

noise = (randn(size(target)) + 1i * randn(size(target)))/sqrt(2*10^P.SNR/10);

signal = target + noise;


end
