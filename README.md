This analysis investigates Tesla's weekly stock prices, leveraging time series techniques to forecast future values and explore volatility patterns, with an emphasis on integrating these forecasts into structured options trading strategies. The study begins by preprocessing Tesla's weekly adjusted closing prices, standardizing their frequency, and formatting them as a time series starting in 2010. Exploratory analysis reveals non-constant variance in the data, addressed through log transformations. Differencing methods are then applied to achieve stationarity, with first-order differencing removing trends and second-order differencing eliminating residual patterns. The ACF and PACF plots guide the identification of dependence structures for model selection.

Using diagnostic tools and statistical tests, various ARIMA models are evaluated. The ARIMA(0,2,1) model is selected based on its significant parameters and compliance with residual assumptions. This model is used to forecast weekly prices for four weeks into the future. The forecasts, initially in log-transformed values, are converted back to raw prices using the exponential function. These forecasts are then integrated into specific options strategies, leveraging insights from predicted price levels and volatility.

The analysis employs two well-known options strategies: the bear call spread and the bull put spread. The bear call spread involves selling a call option with a lower strike price ($894) and buying a call option with a higher strike price ($899), anticipating that Tesla's price will stay below $894. Simultaneously, the bull put spread involves selling a put option with a higher strike price ($883) and buying a put option with a lower strike price ($888), anticipating that Tesla's price will remain above $883. Together, these strategies capitalize on the forecasted price movement within a specific range, while managing downside risk through hedging. The annotated visualizations in the analysis plot these strike levels relative to the forecasted prices and their confidence intervals, providing actionable insights for traders.

The model’s performance is assessed through back-testing, comparing predictions to historical data using RMSE. While the model performs well on in-sample data, out-of-sample predictions exhibit higher RMSE, reflecting challenges in forecasting under volatile market conditions. To address non-constant variance observed in the residuals, a GARCH(1,1) model is fitted to the differenced log-transformed data. This volatility model complements ARIMA-based forecasts by accounting for heteroskedasticity, with parameter estimates highlighting significant influences of past errors and volatility.

The integration of forecasting with options trading strategies such as the bear call spread and bull put spread adds significant practical value to the analysis. By using forecasted price ranges and confidence intervals to structure these positions, the study bridges theoretical modeling with real-world financial applications. The analysis provides a comprehensive examination of Tesla's stock price behavior, yielding insights into short-term forecasting, volatility management, and actionable, risk-managed trading strategies.




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


