function b = b_calculator_func(theta_vec, T)
T = sort(T, 2);
b = pinv(T) * theta_vec;
end