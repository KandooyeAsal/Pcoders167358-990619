function [deltaSigma_acc, b, thetaEst_acc] = test_ball_func

global P
thetaEst_acc = [];
deltaSigma_acc = [];
for ff = P.freqs
    P.fc = [ff] * 1e9;
    P.lambda = 3e8 ./ P.fc;
    for jj = 1:P.snapshot
        [signal,thetaD] = TargetGeneration;
        for ii = 1:length(thetaD)
            P.w = ones(P.nAnt-P.m,1);
            [deltaSigma(ii) , thetaEst(ii)] = PCM(signal(:,ii));
        end
    end
    thetaEst_acc = [thetaEst_acc; thetaEst];
    deltaSigma_acc = [deltaSigma_acc; deltaSigma];
end
%% calculating b
b = b_calculator_func(thetaD.', thetaEst_acc.');
%% calculating optimal curve
deltaSigma_opt = sum(deltaSigma_acc .* repmat(b, 1, size(deltaSigma_acc, 2)));
deltaSigma_acc = [deltaSigma_acc; deltaSigma_opt];

thetaEst_opt = sum(thetaEst_acc .* repmat(b, 1, size(thetaEst_acc, 2)));
thetaEst_acc = [thetaEst_acc; thetaEst_opt];
end