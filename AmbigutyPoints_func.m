function logic_ind = AmbigutyPoints_func(deltaSigma1)
global P

z_vec = [real(deltaSigma1); imag(deltaSigma1)].';
z_comp = deltaSigma1;

D = pdist(z_vec);
D = squareform(D);

i = 1:size(z_vec, 1);
h_different = pdist(i.');
h_different = squareform(h_different);

A = zeros(size(D));
for i = 1:size(A, 1)
    for j = 1:size(A, 2)
        if abs(i - j) < P.thr_amb_h
            A(i, j) = 100;
        end
    end
end

D = D + A;
amb = (D < P.thr_amb);

[indx, indy] = (ind2sub(size(amb), find(amb == 1)));
ind = indx;
logic_ind = zeros(size(deltaSigma1));
logic_ind(unique(ind)) = 1;
logic_ind = logical(logic_ind);

%% plotting ambiguty area
% figure;
% plot(real(z_comp), imag(z_comp))
% grid on
% hold on
% plot(real(z_comp(logic_ind)), imag(z_comp(logic_ind)), 'o')
% axis equal

end