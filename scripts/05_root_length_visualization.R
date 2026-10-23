
# =====================================================
# Sunflower Temperature Stress Analysis
# Figure 2: Root Length Across Temperatures
# =====================================================

library(readxl)
library(ggplot2)

# Import data
df <- read_excel("data/raw/sunflower_raw_data.xlsx")

# Set temperature order
df$temperature_c <- factor(
  df$temperature_c,
  levels = c(25, 40, 45)
)

# Create root length boxplot
p2 <- ggplot(
  df,
  aes(
    x = temperature_c,
    y = root_length_cm,
    fill = temperature_c
  )
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
    title = "Effect of Temperature on Sunflower Root Length",
    x = "Temperature (°C)",
    y = "Root length (cm)"
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

# Display graph
print(p2)

# Save high-resolution figure
ggsave(
  filename = "figures/02_root_length_temperature.png",
  plot = p2,
  width = 8,
  height = 6,
  dpi = 300,
  bg = "white"
)
