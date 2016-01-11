function prob = posterior( Theta, TestData, priori1, priori2, a, b, df )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

u = Theta(1);
sigma = Theta(2);
ksi = Theta(3);

% prob = LogLikLiHood(TestData, u, sigma, ksi, df) + priori1(sigma, ksi) + priori2(a, b);
prob = LogLikLiHood(TestData, u, sigma, ksi, df);
end

