function thetaEst_final = Cases_func(deltaSigma)

global P

dis = abs(P.deltaSigma_acc - deltaSigma);
[~, Ind_min] = min(dis, [], 2);

%% plotting
figure;
plot(real(P.deltaSigma_acc.'),imag(P.deltaSigma_acc.'), '-x')
grid on; title('test ball curve'); xlabel('real(detlaSigma)'); ylabel('imag(deltaSigma)');
hold on
plot(real(deltaSigma), imag(deltaSigma), 'kh', 'MarkerSize',15,'MarkerEdgeColor','k','MarkerFaceColor','r')

for i = 1:size(P.deltaSigma_acc, 1)
    plot(real(P.deltaSigma_acc(i, Ind_min(i))), imag(P.deltaSigma_acc(i, Ind_min(i))), 'cp','MarkerSize',10,'MarkerEdgeColor','c','MarkerFaceColor',[0.5,0.5,0.5])
end
%%

for i = 1:size(P.deltaSigma_acc, 1)
    ambiguty(i) = P.logic_ind_acc(i, Ind_min(i));
end

if sum(ambiguty) < size(P.deltaSigma_acc, 1)
    thetaEst_mean = 0;
    for i =  1:size(P.deltaSigma_acc, 1)
        if ambiguty(i) == 0
            thetaEst_mean = thetaEst_mean + P.thetaEst_acc(i, Ind_min(i));
        end
    end
    thetaEst_mean = thetaEst_mean / (size(P.deltaSigma_acc, 1) - sum(ambiguty));
    thetaEst_final = thetaEst_mean;
elseif sum(ambiguty) == size(P.deltaSigma_acc, 1)
    thetaEst_final = P.thetaEst_acc(size(P.deltaSigma_acc, 1), Ind_min(size(P.deltaSigma_acc, 1)));
end
end