clc
clear
close all

res = 0.05;

p = 100*res:res:20;
f = 0.5;
x = 0.1*(1-p) .* cos(2*pi*f*p);
y = 0.3*(1-p) .* sin(2*pi*f*p) - 1*p;
z_comp = x + 1i*y;
z_vec = [x; y].';

% plot(real(z_comp), imag(z_comp), '-*')
% grid on

thr = 0.3;
thr_h = 5;
D = pdist(z_vec);
D = squareform(D);

i = 1:length(p);
h_different = pdist(i.');
h_different = squareform(h_different);

A = zeros(size(D));
for i = 1:size(A, 1)
    for j = 1:size(A, 2)
        if abs(i - j) < thr_h
            A(i, j) = 100;
        end
    end
end

D = D + A;
amb = (D < thr);
% amb_h = triu(h_different > thr_h);
% [indx, indy] = (ind2sub(size(amb), find(amb == 1)));
% indx = unique(indx);
% [indx_h, indy_h] = (ind2sub(size(amb_h), find(amb_h == 1)));
% indx_h = unique(indx_h);

% ind = intersect(indx, indx_h);

[indx, indy] = (ind2sub(size(amb), find(amb == 1)));
% ind = indx(indx > indy);
ind = indx;

plot(real(z_comp), imag(z_comp), '-*')
grid on
hold on
plot(real(z_comp(ind)), imag(z_comp(ind)), 'ro')

% figure; mesh(amb_h); view(2)

