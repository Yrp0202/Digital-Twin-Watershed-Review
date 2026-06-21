# ==============================================================================
# Script for Figure 5c: Water Level Regulation vs. Risk Ratio
# ==============================================================================

library(ggplot2)
library(dplyr)

# 1. Load data
df_control <- read.csv("control_data.csv")
colnames(df_control) <- c("water_level", "risk_ratio", "curve_type")

# Standardize curve types
df_control$curve_type <- as.character(df_control$curve_type)
df_control$curve_type[grepl("10|0.1", df_control$curve_type)] <- "10%"
df_control$curve_type[grepl("50|0.5", df_control$curve_type)] <- "50%"
df_control$curve_type[grepl("90|0.9", df_control$curve_type)] <- "90%"
df_control$curve_type <- factor(df_control$curve_type, levels = c("90%", "50%", "10%"))

# 2. LOESS interpolation for confidence intervals
min_x_force <- 135
max_x_force <- max(df_control$water_level, na.rm = TRUE)
x_seq <- seq(min_x_force, max_x_force, length.out = 100)

mod_10 <- loess(risk_ratio ~ water_level, data = subset(df_control, curve_type == "10%"), span = 0.45)
mod_90 <- loess(risk_ratio ~ water_level, data = subset(df_control, curve_type == "90%"), span = 0.45)

df_ribbon <- data.frame(
  water_level = x_seq,
  risk_10 = predict(mod_10, x_seq),
  risk_90 = predict(mod_90, x_seq)
)

# ==============================================================================
# 3. Plotting
# ==============================================================================
line_colors <- c("90%" = "#D6604D", "50%" = "#2B8CBE", "10%" = "#39933E")

# Define custom dash pattern (dense dashed line)
aesthetic_dash <- "2111"
line_types <- c("90%" = aesthetic_dash, "50%" = "solid", "10%" = aesthetic_dash)

p_control <- ggplot() +
  geom_ribbon(data = df_ribbon, aes(x = water_level, ymin = risk_90, ymax = risk_10), 
              fill = "#E2E6E9", alpha = 0.8) +
  geom_smooth(data = df_control, aes(x = water_level, y = risk_ratio, 
                                     color = curve_type, linetype = curve_type),
              method = "loess", span = 0.45, se = FALSE, size = 1.8) +
  scale_color_manual(values = line_colors) +
  scale_linetype_manual(values = line_types) +
  geom_hline(yintercept = 5, linetype = "dotted", color = "#555555", size = 0.8) +
  
  # Highlight points
  geom_point(aes(x = 143.8, y = 3.5), color = "white", fill = "#D6604D", shape = 21, size = 4.5, stroke = 1.5) +
  geom_point(aes(x = 146.3, y = 4.0), color = "white", fill = "#2B8CBE", shape = 21, size = 4.5, stroke = 1.5) +
  geom_point(aes(x = 147.7, y = 4.5), color = "white", fill = "#39933E", shape = 21, size = 4.5, stroke = 1.5) +
  
  scale_x_continuous(limits = c(135, 160), breaks = seq(135, 160, 5)) +
  coord_cartesian(ylim = c(0, 22)) +
  labs(x = "Water Level (m)", y = "High-Risk Zone Proportion (%)") +
  theme_classic(base_size = 14) +
  theme(
    legend.position = "none",
    axis.line = element_line(size = 1.2, color = "black"),
    axis.ticks = element_line(size = 1.2, color = "black"),
    axis.text = element_text(color = "black", face = "bold", size = 13),
    axis.title = element_text(face = "bold", size = 15),
    plot.margin = margin(t = 15, r = 25, b = 15, l = 15)
  )

# Export PDF
ggsave("Figure_5c_Control_Risk.pdf", plot = p_control, width = 5.0, height = 4.5, dpi = 300)