# Time Series Analysis: Forecasting Tesla Stock Prices Using ARIMA

## Overview
This project explores **Time Series Analysis** techniques, particularly the ARIMA model, to forecast Tesla's weekly stock prices. The project investigates the time-ordered data, applies mathematical transformations, and validates models using advanced statistical techniques. The analysis includes parameter estimation, residual diagnostics, and forecasting, with results visualized through various plots.

---

## Advanced Mathematical Theory

### 1. **Autoregressive (AR) Model**
The AR model expresses the current observation as a function of its past values:

$$
X_t = \phi_1 X_{t-1} + \phi_2 X_{t-2} + \cdots + \phi_p X_{t-p} + w_t
$$

- $$\phi_i$$: AR coefficients (estimated using Maximum Likelihood Estimation).
- $$w_t$$: White noise (mean 0, constant variance).

### 2. **Moving Average (MA) Model**
The MA model relates the current observation to past white noise terms:

$$
X_t = w_t + \theta_1 w_{t-1} + \theta_2 w_{t-2} + \cdots + \theta_q w_{t-q}
$$

- $$\theta_i$$: MA coefficients, estimated via Maximum Likelihood Estimation.
- $$w_t$$: Independent and identically distributed white noise terms.

### 3. **Combined ARIMA Model**
ARIMA integrates AR, MA, and differencing ($$d$$) to model non-stationary data:

$$
X_t = \phi_1 X_{t-1} + \cdots + \phi_p X_{t-p} + w_t + \theta_1 w_{t-1} + \cdots + \theta_q w_{t-q}
$$

**Key Features:**
- Differencing:

$$
\Delta X_t = X_t - X_{t-1}
$$

$$
\Delta^2 X_t = \Delta X_t - \Delta X_{t-1}
$$

- Stationarity: Required for accurate ARIMA modeling.

---

## Data Transformation and Differencing

### Log Transformation
Applied to stabilize variance:

$$
Y_t = \log(X_t)
$$

#### Chart: Log-Transformed Tesla Weekly Prices

### Differencing
To remove trends and achieve stationarity:
- First-order differencing:

$$
\Delta Y_t = Y_t - Y_{t-1}
$$

- Second-order differencing:

$$
\Delta^2 Y_t = \Delta Y_t - \Delta Y_{t-1}
$$

#### Chart: First-Order and Second-Order Differenced Data

### Validation of Stationarity
#### Chart: ACF and PACF Plots for Differenced Data
- **ACF (Auto-Correlation Function):** Measures the correlation of a time series with its lagged values:

$$
\rho(h) = \frac{\gamma(h)}{\gamma(0)}
$$

- **PACF (Partial Auto-Correlation Function):** Measures the direct correlation between a time series and its lags, excluding intermediary influences.

---

## Model Selection and Parameter Estimation

### Candidate Models
1. **ARIMA(3, 2, 1):** Initial model with AR(3), MA(1), and second-order differencing.
   - Significant MA parameter ($$p < 0.05$$), insignificant AR terms.

2. **ARIMA(0, 2, 1):** Final selected model.
   - Minimal AIC, significant parameters ($$p < 0.05$$).

#### Mathematical Derivation for Maximum Likelihood Estimation
The parameters ($$\phi$$, $$\theta$$) are estimated by maximizing the likelihood:

$$
L(\phi, \theta) = \prod_{t=1}^T \frac{1}{\sqrt{2\pi\sigma^2}} \exp\left(-\frac{(X_t - \hat{X}_t)^2}{2\sigma^2}\right)
$$

#### Chart: Residual Diagnostics (ACF of Residuals, Q-Q Plot, Histogram)

---


## Forecasting Results

### Log-Scale Forecast
Predicted Tesla weekly log prices for 4 weeks:


$$
\hat{Y}_{t+n} = \phi_1 Y_{t+n-1} + \theta_1 \epsilon_{t+n-1}
$$


### Real-Scale Forecast
Inverse transformation to obtain raw prices:


$$
\hat{X}_{t+n} = \exp(\hat{Y}_{t+n})
$$





---

## Back-Testing and Performance Evaluation

### Root Mean Squared Error (RMSE)
- Back-testing RMSE:

$$
\text{RMSE}_{\text{back-test}} = 0.07
$$

- Forecasting RMSE:

$$
\text{RMSE}_{\text{forecast}} = 62.56
$$

### Observed vs. Predicted Values
#### Chart: Historical vs. Forecasted Tesla Prices

---

## Options Trading Strategy

### Spread Strategies
#### Bear Call Spread
- Sell call at \$894, buy call at \$899.
- Max loss:

$$
\text{Loss}_{\text{max}} = (899 - 894) \times \text{Contracts}
$$

#### Bull Put Spread
- Sell put at \$888, buy put at \$883.
- Max loss:

$$
\text{Loss}_{\text{max}} = (888 - 883) \times \text{Contracts}
$$

---

## Recommendations and Future Work
1. **GARCH Models**:
   - Address non-constant variance observed in residuals.
   - Use ARMA-GARCH hybrid models.
2. **Extended Horizons**:
   - Evaluate long-term forecast accuracy.
3. **Ensemble Models**:
   - Combine ARIMA, GARCH, and regression for improved performance.

---

## References
- Shumway, R., & Stoffer, D. (2017). *Time Series Analysis and Its Applications: With R Examples*. Springer.
- [Yahoo Finance Historical Data](https://finance.yahoo.com/quote/TSLA/history?p=TSLA)


