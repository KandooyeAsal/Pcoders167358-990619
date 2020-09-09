function [deltaSigma , thetaEst] = PCM(signal)

global P

w = ones(P.nAnt-P.m,1);

sa1 = w' * signal(1:P.nAnt-P.m);
sa2 = w' * signal(P.m+1:end);

delta = sa1 - sa2;
sigma = sa1 + sa2;

deltaSigma = delta/sigma;
thetaEst = asind(P.lambda/pi/P.m/P.d * atan(imag(deltaSigma)));



end
