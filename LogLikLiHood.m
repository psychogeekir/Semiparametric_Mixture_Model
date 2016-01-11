function allLikLiHood = LogLikLiHood( TestData, u, sigma, ksi, df )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

SemiParamData = TestData(TestData<=u);
ParamData = TestData(TestData>u);

%% SemiParametric model
breaks = 40;
DoPlot = 0;
h = LindseyMethod(SemiParamData, u, breaks, df, DoPlot);

% [y, edges] = histcounts(SemiParamData,40);
% zb = ((edges(1:(end-1))+edges(2:end))/2)';
% y = y';
% 
% % orthogonal polynamial and poisson regression
% % R: poly()
% [ mp, norm2, alpha ] = OrthogonalPoly( zb, df );
% mc = glmfit(mp, y, 'poisson'); 
% kh = @(x) exp([ones(length(x(:)),1), OrthogonalPredict( x(:), df, alpha, norm2 )]*mc);
% 
% nc = integral(@(x) kh(x),SemiParamData(1),u,'ArrayValued',1);
% h = @(x) kh(x)/nc;
% 
% histogram(SemiParamData,40,'Normalization','pdf')
% hold on
% plot(0:0.1:u,h(0:0.1:u),'r--')
% hold off
%%
% Semiparametric log likelihood
LogLikLiHood1 = length(SemiParamData)*log(length(SemiParamData)/length(TestData)) + ...
        sum(log(h(SemiParamData)));

% Generalize Pareto Model
% Parametric, sigma > 0, ksi > -0.5
% if ksi == 0
%     ParetoFun = @(x) 1/sigma*exp(-ksi*(x-u)/sigma);
% else
%     ParetoFun = @(x) 1/sigma*(1+ksi*(x-u)/sigma).^(-(1+ksi)/ksi);
% end
% 
% LogLikLiHood2 = length(ParamData)*log(length(ParamData)/length(TestData)) + ...
%         sum(log(ParetoFun(ParamData)));

LogLikLiHood2 = length(ParamData)*log(length(ParamData)/length(TestData)) + ...
        sum(log(gppdf(ParamData, ksi, sigma, u)));

%%
allLikLiHood = LogLikLiHood1 + LogLikLiHood2;

end



