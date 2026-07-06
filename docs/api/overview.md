# API Integration Overview

This document describes the external API endpoints integrated into KrishiOS.

---

## 1. Open-Meteo Weather API

We use the free Open-Meteo API to fetch real-time agricultural weather forecasts.

* **Base URL:** `https://api.open-meteo.com/v1/forecast`
* **Query Parameters:**
  - `latitude`: (double) Target latitude location coordinate.
  - `longitude`: (double) Target longitude coordinate.
  - `current`: (comma-separated strings) Requested current data metrics (e.g. `temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m,wind_direction_10m`).
  - `wind_speed_unit`: `kmh`
  - `timezone`: `auto`

### Sample Request
```http
GET https://api.open-meteo.com/v1/forecast?latitude=25.6&longitude=85.1&current=temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m,wind_direction_10m&wind_speed_unit=kmh&timezone=auto
```

### Sample Response Schema
```json
{
  "latitude": 25.6,
  "longitude": 85.1,
  "current": {
    "time": "2026-07-06T15:00",
    "temperature_2m": 31.4,
    "relative_humidity_2m": 72,
    "precipitation": 0.0,
    "wind_speed_10m": 12.5,
    "wind_direction_10m": 180
  }
}
```
