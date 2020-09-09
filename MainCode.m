clc 
clear
close all

global P

P.nAnt = 30;
P.m = 1;
P.SNR = 10;
P.fc = [9] * 1e9;
P.lambda = 3e8 ./ P.fc;
P.d = 3e8 / 9e9 /2; % P.98 Thesis

P.res = 0.1;
P.thetaS = -90+P.res:P.res:90;
P.x = [0:P.nAnt-1] * P.d;
P.steer = exp(-1i * 2*pi * P.x' / P.lambda * sind(P.thetaS));
% P.hr = 15; 
% sd = 1;
% sr = 
P.thetaD = 1.5;

signal = TargetGeneration;

[deltaSigma , thetaEst] = PCM(signal);








