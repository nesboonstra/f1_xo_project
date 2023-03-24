# f1_xo_project
 Formula 1 Expected Overtakes Project

A repository for a machine learning sports analytics Graduate school project focussed on developing an Expected Overtakes (xO) metric for Formula 1 racing, analogous to the Expected Goals (xG) metric from association football, with the pleasant side-effect of providing a central location for tidy-compliant F1 data.

# Data

## old_data
Safety car, tyres, and weather data collected manually as available by Nick Boonstra in March 2023 for Hybrid Era of racing (i.e. from 2014 on) from [Stats F1](statsf1.com), [Race Fans](racefans.net), and Wikipedia, respectively.

All other data obtained from the vopani "Formula 1 World Championship" [kaggle page](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020).

## tidy_data

Processed by Nick Boonstra for tidy-compliance, consistent snake-case column names. `snakecase`, `stringi`, and `tidyverse` suite of packages used in tidying. (See `xo_tidydata.R` in `Scripts`.)

# Scripts

R scripts used in tidying data, modelling data, etc. Will likely be further differentiated in the future.
