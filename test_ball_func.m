function [deltaSigma_acc, b, thetaEst_acc] = test_ball_func

global P
thetaEst_acc = [];
deltaSigma_acc = [];
for ff = P.freqs
    P.fc = [ff] * 1e9;
    P.lambda = 3e8 ./ P.fc;
    P.steer = exp(-1i * 2*pi * P.x' / P.lambda * sind(P.thetaS));
    
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
% b = [0.29 0.3 0.4].' - 0.1;
%% calculating optimal curve
[thetaEst_acc, I] = sort(thetaEst_acc, 1);
for iii = 1:size(deltaSigma_acc, 2)
    deltaSigma_acc1(:, iii) = deltaSigma_acc(I(:, iii), iii);
end

thetaEst_opt = sum(thetaEst_acc .* repmat(b, 1, size(thetaEst_acc, 2)));
thetaEst_acc = [thetaEst_acc; thetaEst_opt];

deltaSigma_opt = sum(deltaSigma_acc1 .* repmat(b, 1, size(deltaSigma_acc1, 2)));
deltaSigma_acc = [deltaSigma_acc; deltaSigma_opt];

%%
figure;
plot(real(deltaSigma_acc.'),imag(deltaSigma_acc.'))
hold all; plot(real(deltaSigma_opt),imag(deltaSigma_opt))
grid on; title('test ball curve'); xlabel('real(detlaSigma)'); ylabel('imag(deltaSigma)');

end