clc
clear
close all

global P

P.Ranges = 5e3:100:6e3;
b_acc = [];
for rr = P.Ranges
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
    P.thetaS = -1+P.res:P.res:1;
    P.x = [0:P.nAnt-1] * P.d;
    P.steer = exp(-1i * 2*pi * P.x' / P.lambda * sind(P.thetaS));
    
    P.thetaD = 1.5;
    snapshot = 1;
    
    thetaEst_acc = [];
    deltaSigma_acc = [];
    for ff = P.freqs
        P.fc = [ff] * 1e9;
        P.lambda = 3e8 ./ P.fc;
        for jj = 1:snapshot
            [signal,thetaD] = TargetGeneration;
            for ii = 1:length(thetaD)
                P.w = ones(P.nAnt-P.m,1);
                [deltaSigma(ii) , thetaEst(ii)] = PCM(signal(:,ii));
%                 P.ht = 60;
                thetaREst(ii) = Geometry(thetaEst(ii));
                P.w = LCMV(thetaEst(ii),thetaREst(ii));
                W(:,ii) = P.w;
                [deltaSigma1(ii) , thetaEst1(ii)] = PCM(signal(:,ii));
            end
        end
        thetaEst_acc = [thetaEst_acc; thetaEst];
        deltaSigma_acc = [deltaSigma_acc; deltaSigma];
    end
    %% calculating b
    b = b_calculator_func(thetaD.', thetaEst_acc.');
    b_acc = [b_acc, b];
end

%%
figure;
plot(P.Ranges, b_acc(1, :), 'b-o', 'DisplayName', 'b1'); hold all
plot(P.Ranges, b_acc(2, :), 'r-x', 'DisplayName', 'b2')
plot(P.Ranges, b_acc(3, :), 'g-s', 'DisplayName', 'b3')
title('Range effect on b')
xlabel('Range(m)')
legend show
grid on


