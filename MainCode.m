clc
clear all
% close all

global P

P.R = 5e3;
P.ht = 10:0.1:60;
P.hr = 15;

P.nAnt = 30;
P.m = 1;
P.SNR = 18;
P.fc = [10] * 1e9;
P.lambda = 3e8 ./ P.fc;
P.d = 3e8 / 9e9; % P.98 Thesis

P.res = 0.0001;
P.thetaS = -1+P.res:P.res:1;
P.x = [0:P.nAnt-1] * P.d;
P.steer = exp(-1i * 2*pi * P.x' / P.lambda * sind(P.thetaS));

P.thetaD = 1.5;
snapshot = 1;
for jj = 1:snapshot
    [signal,thetaD] = TargetGeneration;
    for ii = 1:length(thetaD)
        P.w = ones(P.nAnt-P.m,1);
        [deltaSigma(ii) , thetaEst(ii)] = PCM(signal(:,ii));
        thetaREst(ii) = Geometry(thetaEst(ii));
        P.w = LCMV(thetaEst(ii),thetaREst(ii));
        W(:,ii) = P.w;
        [deltaSigma1(ii) , thetaEst1(ii)] = PCM(signal(:,ii));
    end
end
%%
% figure; plot(P.ht,thetaD)
% hold all; plot(P.ht,round(thetaEst1,2))
% grid on; legend('true Angle','PCM Only')

hold all; plot(real(deltaSigma),imag(deltaSigma))




