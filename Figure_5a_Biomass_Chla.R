# ==============================================================================
# Script for Figure 5a: Vertical Profile of Reservoir Biomass and Chlorophyll-a
# ==============================================================================

library(ggplot2)
library(dplyr)

# Set working directory (Update this path to your local directory)
# setwd("path/to/your/directory")

# 1. Load data
df_bio <- read.csv("bio_data.csv")
df_chla <- read.csv("chla_data.csv")

# Standardize column names to prevent special character errors
colnames(df_bio)[3] <- "bio"
colnames(df_chla)[3] <- "chla"

# 2. Data preprocessing
month_levels <- c(9, 6, 2)
month_labels <- c("Sep (Bloom)", "Jun (Transition)", "Feb (Baseline)")

df_bio$month <- factor(df_bio$month, levels = month_levels, labels = month_labels)
df_chla$month <- factor(df_chla$month, levels = month_levels, labels = month_labels)

df_bio <- df_bio %>% arrange(month, elevation)
df_chla <- df_chla %>% arrange(month, elevation)

# 3. Define custom high-contrast color palette
my_colors <- c("Sep (Bloom)" = "#39933E",       # Forest Green
               "Jun (Transition)" = "#2B8CBE",  # Ocean Blue
               "Feb (Baseline)" = "#8C969A")    # Slate Gray

intake_elevation <- 396

# ==============================================================================
# Plotting Module A: Biomass
# ==============================================================================
p_bio <- ggplot(df_bio, aes(x = bio, y = elevation, color = month, fill = month)) +
  geom_point(size = 2.5, alpha = 0.6, shape = 21, stroke = 0.5) +
  geom_smooth(method = "loess", span = 0.8, se = FALSE, size = 1.5, orientation = "y") +
  scale_color_manual(values = my_colors) +
  scale_fill_manual(values = my_colors) +
  geom_hline(yintercept = intake_elevation, linetype = "dashed", color = "#6C7476", size = 0.8, alpha = 0.8) +
  annotate("text", x = max(df_bio$bio, na.rm = TRUE) * 0.5, y = intake_elevation + 1.5, 
           label = "Intake Gate Elevation", color = "#6C7476", fontface = "italic", size = 4) +
  labs(x = "Biomass (mg/L)", y = "Elevation (m)") +
  theme_classic() +
  theme(
    legend.position = "none", # Removed for composite layout
    axis.text = element_text(size = 12, color = "black"),
    axis.title = element_text(size = 14, face = "bold"),
    axis.line = element_line(size = 0.8, color = "black"),
    axis.ticks = element_line(size = 0.8, color = "black"),
    plot.margin = margin(t = 10, r = 20, b = 10, l = 10)
  )

# ==============================================================================
# Plotting Module B: Chlorophyll-a
# ==============================================================================
p_chla <- ggplot(df_chla, aes(x = chla, y = elevation, color = month, fill = month)) +
  geom_point(size = 2.5, alpha = 0.6, shape = 21, stroke = 0.5) +
  geom_smooth(method = "loess", span = 0.8, se = FALSE, size = 1.5, orientation = "y") +
  scale_color_manual(values = my_colors) +
  scale_fill_manual(values = my_colors) +
  geom_hline(yintercept = intake_elevation, linetype = "dashed", color = "#6C7476", size = 0.8, alpha = 0.8) +
  annotate("text", x = max(df_chla$chla, na.rm = TRUE) * 0.5, y = intake_elevation + 1.5, 
           label = "Intake Gate Elevation", color = "#6C7476", fontface = "italic", size = 4) +
  labs(x = expression(bold("Chlorophyll-a (" * mu * "g/L)")), y = "Elevation (m)") +
  theme_classic() +
  theme(
    legend.position = "none", 
    axis.text = element_text(size = 12, color = "black"),
    axis.title = element_text(size = 14, face = "bold"),
    axis.line = element_line(size = 0.8, color = "black"),
    axis.ticks = element_line(size = 0.8, color = "black"),
    plot.margin = margin(t = 10, r = 20, b = 10, l = 10)
  )

# Export high-resolution PDFs
ggsave("Figure_5a_Biomass.pdf", plot = p_bio, width = 4.5, height = 5.5, dpi = 300)
ggsave("Figure_5a_Chla.pdf", plot = p_chla, width = 4.5, height = 5.5, dpi = 300)