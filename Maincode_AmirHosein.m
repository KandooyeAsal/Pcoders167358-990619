clc
clear
close all

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
    deltaSigma = [];
    thetaEst = [];
    
    P.ht = ht(h);
    counter = 1;
    for ff = P.freqs 
        P.fc = [ff] * 1e9;
        P.lambda = 3e8 ./ P.fc;
        [signal,thetaD(h)] = TargetGeneration;
        P.w = ones(P.nAnt-P.m,1);
        [deltaSigma(counter) , thetaEst(counter)] = PCM(signal);
        counter = counter + 1;
    end
    
    thetaEst_PCM_CFD(h) = mean(thetaEst);
    thetaEst_PCM_CFD2(h) = sum(thetaEst .* b.');
    deltaSigma(counter) = sum(deltaSigma .* b.');
    
    %% Three Cases
    thetaEst_Cases(h) = Cases_func(deltaSigma);
    
    %% LCMV
    thetaR = Geometry(thetaEst_Cases(h));
    P.w = LCMV(thetaEst_Cases(h), thetaR);
    [deltaSigma1 , thetaEst1(h)] = PCM(signal);
    
end
figure; plot(ht,thetaD, 'DisplayName', 'true angle')
hold all;
% plot(ht, thetaEst_PCM_CFD, 'DisplayName', 'PCM CFD mean')
plot(ht, thetaEst_PCM_CFD2, 'DisplayName', 'PCM CFD b')
plot(ht, thetaEst_Cases, 'DisplayName', 'Cases')
plot(ht, thetaEst1, 'DisplayName', 'LCMV', 'Linewidth', 2)
legend('show', 'Location','southeast')
grid on
xlabel('height(m)')
ylabel('Estimated angle(degree)')


