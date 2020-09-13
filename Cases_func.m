function thetaEst_final = Cases_func(deltaSigma)

global P

for i = 1:size(P.deltaSigma_acc, 1)
dis = abs(P.deltaSigma_acc(i, :) - deltaSigma(i));
[~, Ind_min(i)] = min(dis);
end

%% plotting

% % figure; hold all
% % plot(real(P.deltaSigma_acc(1, :)),imag(P.deltaSigma_acc(1, :)), 'r-x')
% % plot(real(P.deltaSigma_acc(2, :)),imag(P.deltaSigma_acc(2, :)), 'g-x')
% % plot(real(P.deltaSigma_acc(3, :)),imag(P.deltaSigma_acc(3, :)), 'b-x')
% % plot(real(P.deltaSigma_acc(4, :)),imag(P.deltaSigma_acc(4, :)), 'k-x')
% % grid on; title('test ball curve'); xlabel('real(detlaSigma)'); ylabel('imag(deltaSigma)');
% % 
% % plot(real(deltaSigma(1)), imag(deltaSigma(1)), 'h', 'MarkerSize',15,'MarkerEdgeColor','k','MarkerFaceColor','r')
% % plot(real(deltaSigma(2)), imag(deltaSigma(2)), 'h', 'MarkerSize',15,'MarkerEdgeColor','k','MarkerFaceColor','g')
% % plot(real(deltaSigma(3)), imag(deltaSigma(3)), 'h', 'MarkerSize',15,'MarkerEdgeColor','k','MarkerFaceColor','b')
% % plot(real(deltaSigma(4)), imag(deltaSigma(4)), 'h', 'MarkerSize',15,'MarkerEdgeColor','k','MarkerFaceColor','k')
% % 
% % plot(real(P.deltaSigma_acc(1, Ind_min(1))), imag(P.deltaSigma_acc(1, Ind_min(1))), 'p','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','r')
% % plot(real(P.deltaSigma_acc(2, Ind_min(2))), imag(P.deltaSigma_acc(2, Ind_min(2))), 'p','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','g')
% % plot(real(P.deltaSigma_acc(3, Ind_min(3))), imag(P.deltaSigma_acc(3, Ind_min(3))), 'p','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','b')
% % plot(real(P.deltaSigma_acc(4, Ind_min(4))), imag(P.deltaSigma_acc(4, Ind_min(4))), 'p','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','k')
% % 
% % temp1 = P.deltaSigma_acc(1, :);
% % plot(real(temp1(P.logic_ind_acc(1, :))), imag(temp1(P.logic_ind_acc(1, :))), 'ro')
% % temp2 = P.deltaSigma_acc(2, :);
% % plot(real(temp2(P.logic_ind_acc(2, :))), imag(temp2(P.logic_ind_acc(2, :))), 'go')
% % temp3 = P.deltaSigma_acc(3, :);
% % plot(real(temp3(P.logic_ind_acc(3, :))), imag(temp3(P.logic_ind_acc(3, :))), 'bo')
% % temp4 = P.deltaSigma_acc(4, :);
% % plot(real(temp4(P.logic_ind_acc(4, :))), imag(temp4(P.logic_ind_acc(4, :))), 'ko')

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