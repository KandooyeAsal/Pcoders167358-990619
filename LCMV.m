function w = LCMV(thetaD,thetaR)
global P

[~,idxThetaD] = min(abs(P.thetaS - thetaD));
[~,idxThetaR] = min(abs(P.thetaS - thetaR));


g = [1 ; 0];
P1 = [P.steer(1:end-P.m,idxThetaD),P.steer(1:end-P.m,idxThetaR)];
    
w = P1 * inv(P1' * P1) * g;
end