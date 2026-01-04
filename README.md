# A Multi-Factor Model for Improved Commodity Pricing  
**Calibration and an Application to the Oil Market**  
*Quantitative Finance*

**Authors:** Christian Tezza, Luca Vincenzo Ballestra

---

## Overview

This repository contains MATLAB code for the estimation and calibration of multi-factor commodity pricing models with quasi-affine futures price representations. The framework is designed for empirical applications in commodity markets and supports estimation when the spot price is either observed or unobserved.

The models considered admit a quasi-affine solution for commodity futures prices, where futures prices are expressed as exponential–affine (or quasi-affine) functions of latent state variables.

---

## Model Structure

The state vector includes (in order) the following factors, commonly used in the commodity pricing literature:

- Log spot commodity price  
- Convenience yield  
- Interest rate  
- Volatility of the log-price

---

## Commodities Considered

The empirical application focus primarily on crude oil but can extended to other commodities typically used in the literature such as gold, natural gas and copper.

---

## Estimation Methodology

In commodity markets, futures prices are quoted at multiple maturities. These prices are used to infer the latent state variables underlying the model.

The estimation approach is based on:

- A state-space representation of the model  
- Kalman filtering  
- Maximum likelihood estimation (MLE) via the prediction error decomposition  

**Remark:** In several commodity markets the spot price is not directly observable. The state-space formulation accommodates this feature. 

---

## Code Description

The code is written in MATLAB and consists of `.m` functions implementing the estimation and pricing routines.

### Main Components

- **Starter**  
  Generates randomized initial parameter values to reduce sensitivity to starting points and mitigate convergence to local optima.

- **Log-Likelihood (Kalman Filter)**  
  Casts the model into state-space form, performs Kalman filtering, and computes the log-likelihood using the prediction error decomposition.

- **Estimation Routine**  
  Repeats the likelihood maximization from multiple randomized starting points and selects the parameter vector that maximizes the likelihood.

- **Affine Coefficients**  
  The affine (or quasi-affine) coefficients of the futures price function are obtained by solving a system of ordinary differential equations using Runge–Kutta methods.

---

## Optimization

Parameter estimation is carried out using MATLAB optimization routines, such as:

- `fmincon`

Bound constraints are used to ensure admissibility of the model parameters (correlations, variances).

Note: Optimization Toolbox is required.

---

## File Structure

- `start_param.m % Randomized starting values`
- `loglik.m % Kalman filter log-likelihood`
- `RungeKuttaFuture.m % Runge–Kutta solver for affine coefficients used in log-future price formula`
- `main.m % Main estimation routine`
-- 

## Reference

If you use this code, please cite:
   ```matlab
    Ballestra, L. V. and Tezza, C.
    "A Multi-Factor Model for Improved Commodity Pricing: Calibration and an Application to the Oil Market"
    Quantitative Finance



