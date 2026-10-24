# **Sunflower Growth Responses to Temperature Stress**

![Sunflower experimental design and analysis workflow](figures/00_study_design_workflows.png)

## Project Overview

Temperature stress can influence seedling establishment and growth, potentially affecting sunflower performance under changing environmental conditions. Understanding how sunflower genotypes respond to different temperatures is important for exploring variation in early growth characteristics.

This project investigates sunflower seedling growth across three temperature treatments (25°C, 40°C, and 45°C), focusing on shoot length, root length, and variation among genotypes.

The analysis is being developed as part of the Environmental Data Visualization course at Pontificia Universidad Católica de Chile.

## Research Question

**How do sunflower seedling growth responses vary across temperature treatments and genotypes?**

The exploratory analysis addresses three questions:

1.  How do shoot and root length distributions differ across temperatures?

2.  How do growth responses vary among sunflower genotypes?

3.  How does data completeness affect the interpretation of temperature-related patterns?

## Dataset Description

The dataset contains **168 experimental records**, representing:

- **14 sunflower genotypes**

- **3 temperature treatments:** 25°C, 40°C, and 45°C

- **4 replications per genotype–temperature combination**

The dataset includes shoot length, root length, germination measurements, leaf temperature, and mortality-related variables.

Measurements are not available for every variable under every temperature treatment. Missing observations are retained as missing values rather than automatically replaced with zeros.

## Exploratory Data Analysis

### 1. Shoot Length Across Temperatures

The observed mean shoot lengths were 0.95 cm at 25°C, 1.69 cm at 40°C, and 2.43 cm at 45°C. However, the number of available observations decreased from 56 at 25°C to only 15 at 45°C.

![](figures/01_shoot_length_temperature.png){width="309"}

Consequently, higher observed means at 45°C should not be interpreted as evidence of superior overall growth or heat tolerance.

### 2. Root Length Across Temperatures

The observed mean root lengths were 2.32 cm at 25°C, 2.09 cm at 40°C, and 2.85 cm at 45°C.

![](figures/02_root_length_temperature.png){width="309"}

Differences in sample availability and variability require caution when comparing temperature treatments.

### 3. Genotype-Level Growth Variation

This figure displays individual shoot and root length observations for the 14 sunflower genotypes. Diamond markers represent observed group means.

![](figures/03_genotype_growth_variation.png){width="421"}

The visualization highlights variation among genotypes and across temperature treatments.

### 4. Genotype × Temperature Heatmaps

The heatmaps summarize mean shoot and root length for each genotype–temperature combination.

![](figures/04_genotype_temperature_heatmap.png){width="382"}

Grey cells indicate combinations without available measurements. These patterns highlight the importance of sample availability when interpreting genotype responses.

### 5. Data Completeness

Data completeness varies considerably across temperature treatments.

![](figures/05_data_completeness_temperature.png){width="419"}

Shoot and root length observations are complete at 25°C, nearly complete at 40°C, and available for only approximately 27% of records at 45°C. Germination measurements are available at 25°C but missing at 40°C and 45°C. Mortality-related measurements show a different availability pattern. These differences limit direct comparisons across variables and treatments.

## Preliminary Findings

The exploratory analysis suggests that:

- Observed shoot and root length distributions differ among temperature treatments.

- Growth measurements vary among sunflower genotypes.

- High-temperature groups contain substantially fewer recorded growth measurements.

- Data completeness is an important consideration when interpreting apparent temperature responses.

These findings are descriptive and exploratory. They do not establish statistically significant temperature effects or identify heat-tolerant genotypes.

## Limitations and Next Steps

The reasons for missing measurements have not yet been established. Missing values may reflect measurement procedures, experimental conditions, or biological outcomes, and these possibilities must be evaluated before drawing stronger conclusions.

The next stages will focus on clarifying data completeness, improving genotype comparisons, and developing a coherent interpretation of early sunflower growth responses.

## Repository Structure

- `data/raw/` — Original experimental dataset

- `data/processed/` — Directory reserved for processed datasets

- `scripts/` — Reproducible R analysis and visualization scripts

- `figures/` — Generated scientific figures

- `results/` — Descriptive statistics and supporting CSV tables

- `reports/` — Directory reserved for reports and course activities

## Reproducibility

The analyses use R and the packages `readxl`, `dplyr`, `tidyr`, `ggplot2`, and `scales`.

To reproduce the figures, open the RStudio project and run the relevant scripts from the project root directory. The main visualization scripts are:

- `scripts/03_shoot_length_visualization.R`

- `scripts/04_descriptive_statistics.R`

- `scripts/05_root_length_visualization.R`

- `scripts/06_additional_eda_figures.R`

The figures and tables are generated from the original dataset stored in `data/raw/`.

## Project Status

**First draft — Week 7, Environmental Data Visualization.**

The project is ongoing, and the results presented here are preliminary.
