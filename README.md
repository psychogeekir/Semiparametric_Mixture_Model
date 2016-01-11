# README
-------------------------------------------

This code is trying to replicate the work of Cabras and Castellanos (2011) (A Bayesian approach for estimating extreme quantiles under a semiparametric mixture model) using MATLAB language.

## 1. Data

`DanishData.txt': Danish fire loss data

'data.xlsx': the other data

## 2. Program

`TestCase.m`: main file

`LogLikLiHood.m`: for computing the log likelihood, including the following sub functions

- `LindseyMethod.m`: for implementing the Lindsey method in the paper
- `OrthogonalPoly.m`: for computing the orthogonal polynomials, corresponding to the “poly()” in R
- `OrthogonalPredict.m`: for predicting the value of orthogonal polynomial for new data, corresponding to the “predict()” in R

`posterior.m`: for computing the posterior probability. There are some adjustments, which may cause confusion.

`gwmcmc.m`: for implementing the Markov Chain Monte Carlo simulation. The original code is written by Aslak Grinsted and can be found [here](https://github.com/grinsted/gwmcmc).
