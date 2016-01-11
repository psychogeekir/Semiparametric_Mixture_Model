clc; close all; clear variables
%%
% Danish fire loss data
fileID = fopen('DanishData.txt');
TestData = textscan(fileID, '%*d/%*d/%*d %f', 'HeaderLines', 1, 'TreatAsEmpty', 'NA');
fclose(fileID);
TestData = TestData{1,1};
TestData = sort(TestData);

% translate the data by -1 to be consistent with Cabras and Castellanos
%(2011)
TestData = TestData-1;

%%
% the other data
% TestData = xlsread('data.xlsx');
% TestData = sort(TestData);
% TestData = TestData(TestData>0);

%%
% the degree of the polynomial in Poisson regression
df = 3;

% the upper and lower bounds are determined based on that paper
% if more information is available, this interval can be further narrowd down
a = TestData(df+1);
b = TestData(length(TestData)-2);

% sigma > 0, ksi > -0.5
priori1 = @(sigma, ksi) log(1/sigma*1/(1+ksi)*1/sqrt(1+ksi));
% u follows a uniform distribution through the interval [a,b]
priori2 = @(a, b) log(1/(b-a));

logprior = @(Theta) log( double((Theta(1)>a)&&(Theta(1)<b) &&...
    (Theta(2)>0) &&(Theta(3)>-0.5))) + priori1(Theta(2),Theta(3)) + priori2(a, b);

loglike = @(Theta) posterior( Theta, TestData, priori1, priori2, a, b, df );

%%
% inital guess for Danish fire loss data
Theta_init = [3; 5; 0.5];
% inital guess for the other data
% Theta_init = [8e5; 3.5e4; 0.5];

% find the values leading to the maximum likelihood
[Theta_est,fval] = fminsearch(@(Theta) -loglike(Theta), Theta_init);

%%
M=3; %number of model parameters
Nwalkers=40; %number of walkers/chains.

% first we initialize the ensemble of walkers in a small gaussian ball 
% around the max-likelihood estimate.
minit=bsxfun(@plus,Theta_est,bsxfun(@times,randn(M, Nwalkers),[0.1;0.1;0.1]));


% just check out whether there are all valid value (no Inf or NaN).
t = zeros(Nwalkers, 1);
for i = 1:Nwalkers
    t(i) = loglike(minit(:,i));
end

tic
models=gwmcmc(minit, {logprior loglike}, 200000,  'StepSize', 10, 'Parallel', false); 
toc

%remove 25% burn-in from all chains.
models(:,:,1:end*.25)=[];%crop 25% burn-in

%flatten the chain: analyze all the chains as one
models=models(:,:); 

q = quantile(models, [0.025 0.25 0.50 0.75 0.975], 2);

disp('------------------------------------------------------------------------')
disp('Parameter     0.025         0.25         0.50         0.75        0.975')
disp('------------------------------------------------------------------------')
disp(['   u     ',num2str(q(1,:))])
disp(['  sigma  ',num2str(q(2,:))])
disp(['   ksi   ',num2str(q(3,:))])
disp('------------------------------------------------------------------------')

% save('DanishResult.mat', 'models', 'q')
% save('Result.mat', 'models', 'q')