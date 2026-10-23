
# =====================================================
# Sunflower Temperature Stress Analysis
# Figure 1: Shoot Length Across Temperatures
# =====================================================

# Load required packages
library(readxl)
library(ggplot2)

# Import original dataset
df <- read_excel("data/raw/sunflower_raw_data.xlsx")

# Set temperature order
df$temperature_c <- factor(
  df$temperature_c,
  levels = c(25, 40, 45)
)

# Create the figure
p1 <- ggplot(
  df,
  aes(x = temperature_c,
      y = shoot_length_cm,
      fill = temperature_c)
) +
  geom_boxplot(
    width = 0.55,
    alpha = 0.85,
    outlier.shape = 21,
    outlier.size = 2.5,
    color = "black",
    na.rm = TRUE
  ) +
  scale_fill_manual(
    values = c(
      "25" = "#4C8C78",
      "40" = "#D99B45",
      "45" = "#C65D55"
    )
  ) +
  labs(
    title = "Effect of Temperature on Sunflower Shoot Length",
    x = "Temperature (°C)",
    y = "Shoot length (cm)"
  ) +
  theme_bw(base_size = 15, base_family = "serif") +
  theme(
    plot.title = element_text(
      size = 17,
      face = "bold",
      hjust = 0.5
    ),
    axis.title = element_text(size = 15),
    axis.text = element_text(size = 13, color = "black"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    legend.position = "none"
  )

# Display figure
print(p1)

# Save figure to project folder
ggsave(
  filename = "figures/01_shoot_length_temperature.png",
  plot = p1,
  width = 8,
  height = 6,
  dpi = 300,
  bg = "white"
)
