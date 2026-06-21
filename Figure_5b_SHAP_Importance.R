# ==============================================================================
# Script for Figure 5b: SHAP Feature Importance with Horizontal Gradient
# ==============================================================================

library(ggplot2)
library(dplyr)

# 1. Load data
df_shap <- read.csv("shap_data.csv")

# Standardize column names
colnames(df_shap)[1] <- "feature"
colnames(df_shap)[2] <- "shap_value"

# 2. Data sorting
df_shap <- df_shap %>% arrange(shap_value)
df_shap$feature <- factor(df_shap$feature, levels = df_shap$feature)

# 3. Segment bars to enable horizontal gradient fill
df_gradient <- data.frame()

for(i in 1:nrow(df_shap)) {
  feat <- as.character(df_shap$feature[i])
  val <- df_shap$shap_value[i]
  seq_val <- seq(0, val, length.out = 200)
  
  temp_df <- data.frame(
    feature_name = feat,
    feature_num = i,
    ymin = seq_val[-200],
    ymax = seq_val[-1],
    fill_val = seq_val[-1]
  )
  df_gradient <- rbind(df_gradient, temp_df)
}

max_shap <- max(df_shap$shap_value)

# ==============================================================================
# 4. Plotting
# ==============================================================================
p_shap <- ggplot(df_gradient) +
  geom_rect(aes(xmin = feature_num - 0.35, xmax = feature_num + 0.35,
                ymin = ymin, ymax = ymax, fill = fill_val)) +
  coord_flip() +
  scale_x_continuous(breaks = 1:nrow(df_shap), labels = df_shap$feature) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  # Custom continuous color gradient
  scale_fill_gradientn(colors = c("#9BD4D3", "#5AB4AC", "#2B8CBE"),
                       limits = c(0, max_shap)) +
  labs(x = "", y = "Mean |SHAP| (Feature Importance)") +
  theme_classic(base_size = 14) +
  theme(
    axis.line = element_line(size = 1, color = "black"),
    axis.ticks = element_line(size = 1, color = "black"),
    axis.text = element_text(color = "black", face = "bold", size = 13),
    axis.title = element_text(face = "bold", size = 14),
    legend.position = "none",
    plot.margin = margin(t = 15, r = 25, b = 15, l = 15)
  )

# Export PDF
ggsave("Figure_5b_SHAP_Importance.pdf", plot = p_shap, width = 5.0, height = 4.5, dpi = 300)