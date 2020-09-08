clc
clear
close all

L = 3;
K = 20;
h = 20:-1:1;

theta_vec = rand(K, 1);
T = rand(K, L);

b = pinv(T) * theta_vec;