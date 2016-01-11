function h = LindseyMethod(Data, u, breaks, df, DoPlot)
% based on the study of Efron and Tibshirani (1996) (Using specially designed exponential 
% families for density estimation)


% INPUT
% Data: sorted data in ascending order
% u: threshold
% breaks: breaks in histcounts. According to Efron and Tibshirani (1996),
% this method is insensitive to the discretization
% df: the degree of the orthogonal polynomial used

% OUTPUT
% h: density estimator function

if nargin<5
    DoPlot = 0;
end

[y, edges] = histcounts(Data, breaks); % function needs to be changed according to the version of the MATLAB
zb = ((edges(1:(end-1))+edges(2:end))/2)';
y = y';

% orthogonal polynamial and poisson regression
% R: poly()
[ mp, norm2, alpha ] = OrthogonalPoly( zb, df );
mc = glmfit(mp, y, 'poisson'); 
kh = @(x) exp([ones(length(x(:)),1), OrthogonalPredict( x(:), df, alpha, norm2 )]*mc);

nc = integral(@(x) kh(x), Data(1), u, 'ArrayValued', 1);
h = @(x) kh(x)/nc;

if DoPlot
    histogram(Data,breaks,'Normalization','pdf')
    hold on
    plot(0:0.1:u,h(0:0.1:u),'r--')
    hold off
    legend('Original', 'Fitted')
end

end