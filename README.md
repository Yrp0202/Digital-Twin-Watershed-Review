# Code and Data Repository for: Watershed Digital Twins Review

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![R Version: 4.5.1](https://img.shields.io/badge/R-4.5.1-green.svg)](https://www.r-project.org/)

## 📌 Overview
This repository contains the dataset and R visualization scripts used in the manuscript: **"From descriptive digital twins to closed-loop intelligent agents: adaptive biogeochemical management in river-reservoir systems"**, currently under review at *Water Research*. 

The provided code computationally re-plots and harmonizes the synthesized visualization of the representative operational scenarios discussed in the review, specifically focusing on data-driven perception, SHAP-based diagnostic interpretation, and closed-loop control risks.

## 📂 Repository Structure

### 1. R Scripts (`.R`)
* `Figure_5a_Biomass_Chla.R`: Script for generating the vertical profile of reservoir biomass and chlorophyll-a across different seasonal phases (Bloom, Transition, Baseline).
* `Figure_5b_SHAP_Importance.R`: Script for visualizing SHAP (SHapley Additive exPlanations) feature importance with a custom horizontal gradient.
* `Figure_5c_Control_Risk.R`: Script for plotting the relationship between water level regulation and high-risk zone proportions under varying confidence intervals (10%, 50%, 90%).

### 2. Datasets (`.csv`)
* `bio_data.csv` & `chla_data.csv`: Vertical distribution data for biomass and chlorophyll-a.
* `shap_data.csv`: Feature importance metrics derived from the diagnostic machine learning model.
* `control_data.csv`: Operational boundary data linking hydraulic parameters to risk ratios.

## ⚙️ Prerequisites & Dependencies
To ensure reproducibility, the scripts were developed and tested using **R (Version 4.5.1)**. The following R packages are required:
* `ggplot2` 
* `dplyr`

You can install the dependencies via the R console:
```R
install.packages(c("ggplot2", "dplyr"))
