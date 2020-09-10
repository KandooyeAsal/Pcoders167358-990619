function [deltaSigma , thetaEst] = PCM(signal)

global P

sa1 = P.w' * signal(1:P.nAnt-P.m);
sa2 = P.w' * signal(P.m+1:end);

delta = sa1 - sa2;
Sum = sa1 + sa2;

deltaSigma = delta/Sum;
thetaEst = asind(P.lambda/pi/P.m/P.d * atan(imag(deltaSigma)));

end
