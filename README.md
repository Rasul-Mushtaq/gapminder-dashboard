# Gapminder Economic & Health Dashboard

[![Live Demo](https://img.shields.io/badge/Live_Demo-shinyapps.io-blue?style=flat&logo=shiny)](https://rasul-mushtaq.shinyapps.io/r_project)
![R Version](https://img.shields.io/badge/R-4.0%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

An interactive R Shiny dashboard for exploring the relationship between wealth, health, and population across 142 countries using the [Gapminder](https://www.gapminder.org/data/) dataset (1952–2007).

## Features

- **Wealth vs. Health Scatter Plot:** Interactive `plotly` bubble chart comparing GDP per capita against life expectancy, with point sizes scaled by population.
- **Log Scale Toggle:** Option to switch between linear and logarithmic scales for GDP per capita.
- **Continent Distribution:** Box plot displaying life expectancy spread across continents.
- **Top 10 Table:** Interactive `DT` datatable listing the most populous countries for the selected year and continent filters.

## Tech Stack

- **Language:** R
- **Framework:** Shiny
- **UI Theme:** `bslib` (Darkly theme)
- **Data Processing:** `dplyr`, `gapminder`
- **Visualization & Tables:** `ggplot2`, `plotly`, `DT`

## Local Setup

1. Clone the repository:

   ```bash
   git clone [https://github.com/Rasul-Mushtaq/gapminder-dashboard.git](https://github.com/Rasul-Mushtaq/gapminder-dashboard.git)
   cd gapminder-dashboard
   ```

2. Install required packages:

   ```R
   install.packages(c("shiny", "bslib", "dplyr", "ggplot2", "gapminder", "plotly", "DT", "rsconnect"))
   ```

3. Run the application:
   ```R
   shiny::runApp()
   ```

## Deployment

Deploy directly to `shinyapps.io` from the R console:

```R
library(rsconnect)
rsconnect::setAccountInfo(name='<ACCOUNT>', token='<TOKEN>', secret='<SECRET>')
rsconnect::deployApp()
```

## Data Source

Data provided by [Gapminder](https://www.gapminder.org/data/)
