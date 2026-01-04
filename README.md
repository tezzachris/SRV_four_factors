# A multi-factor model for improved commodity pricing: Calibration and an application to the oil market
Quantitative Finance 

Authors: Christian Tezza, Luca Vincenzo Ballestra 

The models we consider here all possess a quasi-affine formula for the pricing of commodity futures. 

Which factors? Typically in the literature: log-spot commodity price, convenience yield, interest rate, volatility of log-price, long-term mean of log-price
Which commodities? We considered mainly crude-oil, copper, natural gas

## The Estimation Method

In commodity markets future prices at several maturities are quoted. From this prices we can extrapolate the factors/latent variables I described above. The estimation method is usually based on the Kalman filter, and so on likelihood maximation. 
Remark: in some markets the spot commodity price is not quoted. 

In general terms, the code is developed in Matlab language and consists of the following functions:
(a) Starter: provides randomized starter points for the coefficients 
(b) Likelihood prediction error decomposition: casts the model into its state-space form, performs Kalman filtering and computes the log-likelihood.
(c) Obtain the MLEs by repeating (a) and (b) to avoid local minima

Note: For the optmization we rely on Matlab built-in optimizers (e.g. fmincon)
