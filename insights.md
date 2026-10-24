# Key Insights - Urban Noise Pollution Pattern Analysis

## 1. Where is it loudest?
- **Industrial** is the loudest zone (Leq 70.6 dB) and **Silence** the quietest (Leq 47.8 dB), a 22.8 dB gap - roughly 188x the sound energy.
- Top-3 hotspots by composite score: **Railway Station Road** (96), **Central Market** (73), **Old Town Lane** (63).

## 2. When is it loudest?
- Peak hours by zone - Industrial: 17:00 (74.4 dB); Commercial: 17:00 (71.1 dB); Residential: 08:00 (57.9 dB); Silence: 08:00 (50.5 dB).
- Noise is on average 8.0 dB higher by day than by night. Share of hours above the limit: 43% by day vs 51% by night (night limits are 5-10 dB stricter than day limits).
- Industrial noise drops by 6.2 dB at weekends, i.e. it follows working shifts; commercial zones do not quieten.

## 3. Legal compliance (Noise Rules 2000)
- Worst case: **Commercial, night** - 88% of hours exceed the limit.
- 4 of 8 zone-period combinations breach the limit in more than half of all hours.
- Silence zones (hospitals, courts, colleges) exceed their limit in 26% of daytime and 47% of night-time hours.

## 4. What drives noise?
- Traffic is the dominant driver (Spearman rho = 0.80). In the regression each +1 dB of traffic intensity (10*log10 vehicles) adds 0.96 dB, i.e. a doubling of traffic adds about 2.9 dB.
- The model explains 91% of variance on held-out Oct-Dec data (RMSE 3.2 dB), so it generalises in time.
- Rain adds 0.8 dB. Temperature (p = 0.10) and humidity (p = 0.26) have no significant independent effect once traffic is controlled; their raw correlations mostly reflect the shared daily cycle.

## 5. Unusual events
- 36 abnormal noise events detected (5 severe). The 1 Nov festival evening shows up at all residential and commercial stations.
- Validation on injected events: event recall 96%, event precision 64%, hour-level F1 0.82. Lower precision means some alerts are false alarms - tune thresholds in CFG$anomaly.

## 6. Data quality
- 60 duplicate rows, 252 invalid sensor readings and 3164 zone-label inconsistencies were repaired; short gaps were interpolated and long gaps excluded.

## 7. Recommendations
- Prioritise enforcement and traffic management around **Railway Station Road** and **Central Market** (highest hotspot scores).
- Introduce night-time heavy-vehicle restrictions and honking enforcement on commercial corridors.
- Protect silence zones with no-honking signage, speed calming and diversion of through-traffic.
- Use the anomaly detector as a live alert: sustained +10 dB events trigger inspection (construction, generators, gatherings).

## Limitations
- Data are simulated (calibrated to realistic traffic-noise physics); conclusions about a real city require real monitor data.
- Hourly observations are autocorrelated; p-values with n ~ 100,000 are therefore optimistic. Effect sizes and daily-aggregated tests are more trustworthy.
- Traffic and night/day are partly collinear (VIF about 8 and 5), so individual coefficients should be read with care.
- Precision of the anomaly detector depends on thresholds; it flags statistical, not necessarily harmful, events.
