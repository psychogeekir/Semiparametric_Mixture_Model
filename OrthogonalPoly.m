function [ Z, norm2, alpha ] = OrthogonalPoly( x, degree )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

x = x(:);

if degree>=length(x)
    error('Degree of the orthogonal polynomial must be less than the number of observations.')
end

xbar = mean(x);
x = x-xbar;

Poly = cell2mat(arrayfun(@(p) x.^p, 0:degree, 'UniformOutput', 0));
[Q, R] = qr(Poly);
Q(:,size(Poly,2)+1:end) = [];
R(size(Poly,2)+1:end,:) = [];

raw = Q*diag(diag(R));
norm2 = sum(raw.^2);
alpha = sum(bsxfun(@times,raw.^2,x))./norm2+xbar;
alpha = alpha(2:degree+1);

Z = bsxfun(@rdivide,raw,sqrt(norm2));
Z = Z(:,2:degree+1);

norm2 = [1, norm2];

end

