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

The state vector typically includes the following factors, commonly used in the commodity pricing literature:

- Log spot commodity price  
- Convenience yield  
- Interest rate  
- Volatility of the log-price  
- Long-term mean of the log-price  

The exact specification may vary across model versions.

---

## Commodities Considered

The empirical applications focus primarily on:

- Crude oil  
- Copper  
- Natural gas  

---

## Estimation Methodology

In commodity markets, futures prices are quoted at multiple maturities. These prices are used to infer the latent state variables underlying the model.

The estimation approach is based on:

- A state-space representation of the model  
- Kalman filtering  
- Maximum likelihood estimation (MLE) via the prediction error decomposition  

**Remark:** In several commodity markets the spot price is not directly observable. The state-space formulation naturally accommodates this feature.

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

Parameter estimation is carried out using MATLAB built-in optimization routines, such as:

- `fmincon`

Bound constraints are used to ensure admissibility of the model parameters.

---

## File Structure

