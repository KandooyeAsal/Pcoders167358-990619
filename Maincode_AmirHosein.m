clc
clear
% close all

global P

%% Initial Parameters

P.R = 5e3;
P.ht = 10:0.1:60;
P.hr = 15;

P.nAnt = 30;
P.m = 1;
P.SNR = 18;
P.freqs = [8, 9, 10];
P.fc = [9] * 1e9;
P.lambda = 3e8 ./ P.fc;
P.d = 3e8 / 9e9; % P.98 Thesis

P.res = 0.0001;
P.thetaS = -2+P.res:P.res:2;
P.x = [0:P.nAnt-1] * P.d;
P.steer = exp(-1i * 2*pi * P.x' / P.lambda * sind(P.thetaS));

P.snapshot = 1;

P.thr_amb = 0.001;
P.thr_amb_h = 5;

%% Test ball

[P.deltaSigma_acc, b , P.thetaEst_acc] = test_ball_func;

%% Ambiguty Point

logic_ind_acc = [];
for i = 1:size(P.deltaSigma_acc, 1)
    logic_ind = AmbigutyPoints_func(P.deltaSigma_acc(i, :));
    logic_ind_acc = [logic_ind_acc; logic_ind];
end
P.logic_ind_acc = logic_ind_acc;

%% Target
% creating target
ht = 10:60;
for h = 1:length(ht)
    P.ht = ht(h);
    [signal,thetaD(h)] = TargetGeneration;
    P.w = ones(P.nAnt-P.m,1);
    [deltaSigma , thetaEst] = PCM(signal);
    
    %% Three Cases
    thetaEst = Cases_func(deltaSigma);
    
    %% LCMV
    thetaR = Geometry(thetaEst);
    P.w = LCMV(thetaEst, thetaR);
    [deltaSigma1 , thetaEst1(h)] = PCM(signal);
    
end
figure; plot(ht,thetaD)
hold all; plot(ht,thetaEst1)


