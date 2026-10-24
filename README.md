# Urban Noise Pollution Pattern Analysis Using R

A complete, reproducible data-analytics pipeline in R that analyses hourly urban noise from 12 monitoring
stations (4 zone types) to find **where** and **when** noise is highest, **what drives it**, whether it
**breaks legal limits**, and which hours are **abnormal**.

```
DATASET -> IMPORT -> CLEANING -> EDA -> STATISTICS -> PATTERNS -> VISUALISATION -> ANOMALY DETECTION -> INSIGHTS -> REPORT
 01          02        03         04     05            06          (all scripts)     07                  08          .Rmd
```

## Quick start (RStudio)
1. Open `urban-noise-analysis.Rproj` (sets the working directory to the project root).
2. `source("main.R")` - installs missing packages, runs all 8 steps (~1 min) and knits the HTML report.
3. Read `outputs/insights.md`, browse `outputs/figures/` (21 charts) and `outputs/tables/` (26 tables), open `outputs/Noise_Analysis_Report.html`.

Requires R >= 4.1. Packages: dplyr, tidyr, ggplot2, readr, tibble, stringr, forcats, lubridate, scales, zoo, broom, corrplot (+ rmarkdown/knitr for the report).

## Live dashboard (Shiny)
```r
install.packages(c("shiny", "plotly", "DT", "bslib"))   # once
source("run_dashboard.R")                               # or shiny::runApp("dashboard")
```
Six tabs, all driven by sidebar filters (zone, station, date range, day/night):
**Overview** (KPIs, 24-h profile, station ranking) | **Patterns** (hour x weekday heatmap, time-of-day, daily trend) |
**Compliance & What-if** (share of hours above legal limits; slider simulates a traffic reduction using the project's regression slope) |
**Hotspots** (live-recomputed hotspot score, map, table) | **Anomalies** (detected events, drill-down chart) |
**Live Monitor** (replays the sensor stream hour by hour with NORMAL / ABOVE LIMIT / ABNORMAL status, 72-hour chart and alert log; start from 1 Nov to watch the festival-night event).
To feed it a real stream, replace the data load at the top of `dashboard/app.R` with `reactivePoll()` over your CSV/database and keep the same columns.
The app sits in its own folder because Shiny automatically runs every script in a folder named `R/`.

## Project structure
| File | Purpose |
|---|---|
| `R/00_setup.R` | packages, `CFG` configuration, legal limits, Leq/L10/L90 helpers, plot helpers |
| `R/01_generate_dataset.R` | simulated 2024 hourly dataset with sensor faults + injected events |
| `R/02_import.R` | typed import, schema check, raw-data profile |
| `R/03_cleaning.R` | timestamp parsing, label fixing, de-duplication, range checks, gap imputation, feature engineering (audit log) |
| `R/04_eda.R` | summary tables, distributions, boxplots vs limits, hourly profile, heatmap, monthly trend |
| `R/05_statistics.R` | Shapiro, Kruskal-Wallis + pairwise Wilcoxon, paired day/night test, weekday/weekend, Spearman correlations, multiple regression with time-based test set, VIF, residual diagnostics, compliance with Wilson CIs |
| `R/06_patterns.R` | peak hours, station fingerprints, seasonal/holiday effects, composite hotspot score, k-means station clusters |
| `R/07_anomaly.R` | 3-method ensemble (robust z, IQR, regression residual), event merging, validation vs ground truth |
| `R/08_insights.R` | auto-generates `outputs/insights.md` from result tables |
| `report/Noise_Analysis_Report.Rmd` | final HTML report |
| `dashboard/app.R`, `run_dashboard.R` | live Shiny dashboard |

## Key methodological choices
- **Leq, not the arithmetic mean.** Decibels are logarithmic; averages use `10*log10(mean(10^(L/10)))`.
- **Legal benchmark.** Limits from the Noise Pollution (Regulation and Control) Rules, 2000 (India): day 06-22, night 22-06.
- **Non-parametric tests** because noise is not normal (Shapiro-Wilk + Q-Q plots); effect sizes reported alongside p-values.
- **Paired tests on station-day aggregates** to reduce the autocorrelation problem of hourly data.
- **Honest regression evaluation**: trained on Jan-Sep, tested on Oct-Dec (no leakage across time). VIF reported.
- **Hotspot score** = 40% mean excess over limit + 40% % hours above limit + 20% Noise Pollution Level (Leq + 2.56 sigma).
- **Anomaly detection validated** against injected events (event recall about 96%, precision about 64%, hour-level F1 about 0.82 with default thresholds).

## Using real data
Real data (for example the CPCB National Ambient Noise Monitoring Network, or your own sound-level-meter logs) needs the 13 columns
`station_id, station_name, zone_type, latitude, longitude, timestamp, noise_db, traffic_count, temperature_c, humidity_pct, wind_speed_ms, rainfall_mm, is_holiday`.
Put the CSV at `data/raw/urban_noise_raw.csv`, set `CFG$column_map` in `R/00_setup.R` if your column names differ, remove `R/01_generate_dataset.R`
from `main.R`, and update `CFG$holidays`/`CFG$train_cutoff`. If you lack traffic or weather columns, fill them with `NA`; the regression and
residual-based anomaly method need them, so drop those terms in `05_statistics.R`/`07_anomaly.R` accordingly. The ground-truth validation
block is skipped automatically when `ground_truth_events.csv` is absent.

## Limitations
Simulated data; autocorrelated hourly observations make p-values optimistic; traffic and night/day are partly collinear; the anomaly
detector trades precision for recall (tune `CFG$anomaly`); coordinates are synthetic.
