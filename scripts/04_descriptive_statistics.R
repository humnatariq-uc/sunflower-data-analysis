# =====================================================
# Sunflower Temperature Stress Analysis
# Descriptive Statistics: Shoot and Root Length
# =====================================================

# Load packages
library(readxl)
library(dplyr)

# Import dataset
df <- read_excel("data/raw/sunflower_raw_data.xlsx")

# Calculate descriptive statistics
descriptive_table <- df %>%
  group_by(temperature_c) %>%
  summarise(
    N_shoot = sum(!is.na(shoot_length_cm)),
    Mean_shoot = mean(shoot_length_cm, na.rm = TRUE),
    SD_shoot = sd(shoot_length_cm, na.rm = TRUE),
    Min_shoot = min(shoot_length_cm, na.rm = TRUE),
    Max_shoot = max(shoot_length_cm, na.rm = TRUE),
    
    N_root = sum(!is.na(root_length_cm)),
    Mean_root = mean(root_length_cm, na.rm = TRUE),
    SD_root = sd(root_length_cm, na.rm = TRUE),
    Min_root = min(root_length_cm, na.rm = TRUE),
    Max_root = max(root_length_cm, na.rm = TRUE),
    
    .groups = "drop"
  )

# Round results to 2 decimal places
descriptive_table <- descriptive_table %>%
  mutate(across(
    where(is.numeric) & !all_of("temperature_c"),
    ~ round(.x, 2)
  ))

# Display results
print(descriptive_table)

# Save results as CSV
write.csv(
  descriptive_table,
  "results/descriptive_statistics_temperature.csv",
  row.names = FALSE
)View(descriptive_table)