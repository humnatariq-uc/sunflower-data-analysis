
# ============================================================
# SUNFLOWER TEMPERATURE STRESS ANALYSIS
# FIGURES 3, 4 AND 5 - IMPROVED FINAL VERSION
# ============================================================

# ------------------------------------------------------------
# 1. INSTALL AND LOAD PACKAGES
# ------------------------------------------------------------

packages <- c("readxl", "dplyr", "tidyr",
              "ggplot2", "scales")

missing_pkgs <- packages[
  !vapply(packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs)
}

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(scales)
})

# ------------------------------------------------------------
# 2. IMPORT DATA
# ------------------------------------------------------------

input_file <- "data/raw/sunflower_raw_data.xlsx"

if (!file.exists(input_file)) {
  stop("Dataset not found. Open the correct RStudio project.")
}

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
dir.create("results", showWarnings = FALSE, recursive = TRUE)

df <- read_excel(input_file)

required_cols <- c(
  "temperature_c", "genotype",
  "shoot_length_cm", "root_length_cm",
  "germination_1", "germination_2",
  "leaf_temp_c", "mortality_raw", "mortality_count"
)

if (!all(required_cols %in% names(df))) {
  stop("Required dataset columns are missing.")
}

df <- df %>%
  mutate(
    Temperature = factor(
      temperature_c,
      levels = c(25, 40, 45),
      labels = c("25°C", "40°C", "45°C")
    ),
    Genotype = factor(
      genotype,
      levels = sort(unique(genotype))
    )
  )

# ------------------------------------------------------------
# 3. COLOR PALETTE AND GRAPHICAL THEME
# ------------------------------------------------------------

temp_colors <- c(
  "25°C" = "#15998C",
  "40°C" = "#D9A441",
  "45°C" = "#E66B50"
)

theme_science <- function(base_size = 16) {
  theme_bw(
    base_size = base_size,
    base_family = "serif"
  ) +
    theme(
      plot.title = element_text(
        face = "bold",
        size = 20,
        hjust = 0.5,
        margin = margin(b = 14)
      ),
      axis.title = element_text(
        size = 16,
        face = "bold",
        color = "black"
      ),
      axis.text = element_text(
        size = 13,
        color = "black"
      ),
      strip.text = element_text(
        size = 15,
        face = "bold",
        color = "black"
      ),
      strip.background = element_rect(
        fill = "#F0F2F2",
        color = "#444444"
      ),
      legend.title = element_text(
        size = 14,
        face = "bold"
      ),
      legend.text = element_text(size = 13),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      plot.margin = margin(15, 20, 15, 15)
    )
}

# Use a new filename when an older PNG is open in Photos
save_figure <- function(plot, filename,
                        width = 12, height = 8) {
  output_path <- file.path("figures", filename)
  
  tryCatch(
    {
      ggsave(
        filename = output_path,
        plot = plot,
        width = width,
        height = height,
        dpi = 300,
        bg = "white",
        device = "png"
      )
      message("Saved: ", output_path)
    },
    error = function(e) {
      warning(
        "Could not save ", filename,
        ". Close the image in Windows Photos and run again. ",
        conditionMessage(e)
      )
    }
  )
}

# ------------------------------------------------------------
# 4. PREPARE LONG-FORM GROWTH DATA
# ------------------------------------------------------------

growth_long <- df %>%
  select(
    Genotype, Temperature,
    shoot_length_cm, root_length_cm
  ) %>%
  pivot_longer(
    cols = c(shoot_length_cm, root_length_cm),
    names_to = "Trait",
    values_to = "Length_cm"
  ) %>%
  mutate(
    Trait = recode(
      Trait,
      shoot_length_cm = "Shoot length",
      root_length_cm = "Root length"
    ),
    Trait = factor(
      Trait,
      levels = c("Root length", "Shoot length")
    )
  )

# ============================================================
# FIGURE 3
# GENOTYPE-WISE GROWTH VARIATION
# ============================================================

# Colored circles = individual observed measurements
# Colored diamonds = observed genotype-temperature means

p3 <- ggplot(
  growth_long,
  aes(
    x = Genotype,
    y = Length_cm,
    color = Temperature
  )
) +
  geom_point(
    position = position_jitterdodge(
      jitter.width = 0.13,
      dodge.width = 0.60,
      seed = 42
    ),
    size = 2.7,
    alpha = 0.85,
    na.rm = TRUE
  ) +
  stat_summary(
    aes(group = Temperature),
    fun = mean,
    geom = "point",
    position = position_dodge(width = 0.60),
    shape = 18,
    size = 4.2,
    show.legend = FALSE,
    na.rm = TRUE
  ) +
  facet_wrap(
    ~ Trait,
    ncol = 1,
    scales = "free_y"
  ) +
  scale_color_manual(values = temp_colors) +
  scale_y_continuous(
    breaks = pretty_breaks(n = 6),
    expand = expansion(mult = c(0.03, 0.08))
  ) +
  labs(
    title = "Sunflower Growth Responses Across Genotypes",
    x = "Genotype",
    y = "Length (cm)",
    color = "Temperature"
  ) +
  theme_science(16) +
  theme(
    legend.position = "bottom",
    panel.grid.major.x = element_blank()
  )

print(p3)

save_figure(
  p3,
  "03_genotype_growth_variation.png",
  width = 13,
  height = 9
)

# ============================================================
# FIGURE 4
# GENOTYPE x TEMPERATURE HEATMAPS
# ============================================================

heatmap_data <- growth_long %>%
  group_by(Genotype, Temperature, Trait) %>%
  summarise(
    N = sum(!is.na(Length_cm)),
    Mean_cm = if (all(is.na(Length_cm))) {
      NA_real_
    } else {
      mean(Length_cm, na.rm = TRUE)
    },
    .groups = "drop"
  ) %>%
  complete(
    Genotype,
    Temperature,
    Trait,
    fill = list(N = 0)
  ) %>%
  mutate(
    Label = ifelse(
      is.na(Mean_cm),
      "NA",
      sprintf("%.2f", Mean_cm)
    )
  )

# Save supporting data
write.csv(
  heatmap_data,
  "results/genotype_temperature_growth_summary.csv",
  row.names = FALSE
)

# Put genotype 1 at the top
heatmap_plot_data <- heatmap_data %>%
  mutate(
    Genotype = factor(
      Genotype,
      levels = rev(levels(Genotype))
    )
  )

p4 <- ggplot(
  heatmap_plot_data,
  aes(
    x = Temperature,
    y = Genotype,
    fill = Mean_cm
  )
) +
  geom_tile(
    color = "white",
    linewidth = 1
  ) +
  geom_text(
    aes(label = Label),
    size = 4.5,
    family = "serif",
    fontface = "bold",
    color = "black"
  ) +
  facet_wrap(
    ~ Trait,
    ncol = 2
  ) +
  scale_fill_gradientn(
    colours = c(
      "#E7F2EE",
      "#B3D8CD",
      "#79B7A7",
      "#388E82",
      "#17675F"
    ),
    na.value = "#E0E0E0",
    name = "Mean (cm)"
  ) +
  labs(
    title = "Genotype-Specific Growth Across Temperatures",
    x = "Temperature",
    y = "Sunflower genotype"
  ) +
  theme_science(16) +
  theme(
    panel.grid = element_blank(),
    legend.position = "right",
    axis.text.x = element_text(
      size = 14,
      face = "bold"
    ),
    axis.text.y = element_text(size = 13),
    strip.text = element_text(
      size = 16,
      face = "bold"
    ),
    legend.key.height = grid::unit(1.5, "cm")
  )

print(p4)

save_figure(
  p4,
  "04_genotype_temperature_heatmap.png",
  width = 13,
  height = 10
)

# ============================================================
# FIGURE 5
# DATA COMPLETENESS ACROSS TEMPERATURE TREATMENTS
# ============================================================

variables_to_check <- c(
  "shoot_length_cm",
  "root_length_cm",
  "germination_1",
  "germination_2",
  "leaf_temp_c",
  "mortality_raw",
  "mortality_count"
)

completeness_data <- df %>%
  select(
    Temperature,
    all_of(variables_to_check)
  ) %>%
  pivot_longer(
    cols = all_of(variables_to_check),
    names_to = "Variable",
    values_to = "Value",
    values_transform = list(Value = as.character)
  ) %>%
  mutate(
    Status = ifelse(
      is.na(Value) | trimws(Value) == "",
      "Missing",
      "Available"
    )
  ) %>%
  count(
    Temperature,
    Variable,
    Status,
    name = "N"
  ) %>%
  complete(
    Temperature,
    Variable,
    Status = c("Available", "Missing"),
    fill = list(N = 0)
  ) %>%
  group_by(Temperature, Variable) %>%
  mutate(
    Percentage = 100 * N / sum(N)
  ) %>%
  ungroup() %>%
  mutate(
    Variable = recode(
      Variable,
      shoot_length_cm = "Shoot length",
      root_length_cm = "Root length",
      germination_1 = "Germination 1",
      germination_2 = "Germination 2",
      leaf_temp_c = "Leaf temperature",
      mortality_raw = "Mortality (raw)",
      mortality_count = "Mortality count"
    ),
    Variable = factor(
      Variable,
      levels = c(
        "Shoot length",
        "Root length",
        "Germination 1",
        "Germination 2",
        "Leaf temperature",
        "Mortality (raw)",
        "Mortality count"
      )
    ),
    Status = factor(
      Status,
      levels = c("Available", "Missing")
    )
  )

# Save supporting data
write.csv(
  completeness_data,
  "results/data_completeness_temperature.csv",
  row.names = FALSE
)

p5 <- ggplot(
  completeness_data,
  aes(
    x = Variable,
    y = Percentage,
    fill = Status
  )
) +
  geom_col(
    width = 0.72,
    color = "white",
    linewidth = 0.5
  ) +
  geom_text(
    aes(
      label = ifelse(
        Percentage >= 12,
        paste0(round(Percentage), "%"),
        ""
      )
    ),
    position = position_stack(vjust = 0.5),
    size = 4.2,
    family = "serif",
    fontface = "bold",
    color = "black"
  ) +
  facet_wrap(
    ~ Temperature,
    nrow = 1
  ) +
  scale_fill_manual(
    values = c(
      "Available" = "#15998C",
      "Missing" = "#E7B0A3"
    )
  ) +
  scale_y_continuous(
    breaks = seq(0, 100, 20),
    labels = function(x) paste0(x, "%"),
    expand = expansion(mult = c(0, 0))
  ) +
  coord_flip(
    ylim = c(0, 100)
  ) +
  labs(
    title = "Data Completeness Across Temperature Treatments",
    x = NULL,
    y = "Percentage of records",
    fill = "Data status"
  ) +
  theme_science(15) +
  theme(
    legend.position = "bottom",
    axis.text.y = element_text(
      size = 12,
      color = "black"
    ),
    strip.text = element_text(
      size = 16,
      face = "bold"
    ),
    panel.grid.major.y = element_blank()
  )

print(p5)

save_figure(
  p5,
  "05_data_completeness_temperature.png",
  width = 14,
  height = 8
)

# ============================================================
# FINAL CHECK
# ============================================================

cat("\nFIGURE GENERATION COMPLETED.\n")

cat("\nFigures:\n")
print(
  list.files(
    "figures",
    pattern = "^0[345]_.*\\.png$"
  )
)

cat("\nSupporting tables:\n")
print(
  list.files(
    "results",
    pattern = "genotype_temperature|data_completeness"
  )
)

cat("\nCheck the figures for correct formatting.\n")
