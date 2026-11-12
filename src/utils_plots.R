# ---------------------------
# Description : function to render plots
# Author : Serge Zaugg
# ---------------------------

render_example_dataset_plot <- function(df) {
  
  fg <- thematic_get_option("fg")
  
  ggplot(df) +
    geom_jitter(
      aes(x = group, y = response, color = group),
      width = 0.15,
      height = 0
    ) +
    theme_minimal() +
    theme(
      plot.margin = margin(t = 20, r = 10, b = 10, l = 10),
      plot.background = element_rect(fill = "transparent", color = NA),
      panel.background = element_rect(fill = "transparent", color = NA),
      panel.grid = element_blank(),
      panel.border = element_rect(fill = NA, color = fg, linewidth = 0.8),
      axis.ticks = element_line(color = fg),
      axis.text = element_text(color = fg, size = 11),
      axis.title = element_text(color = fg),
      text = element_text(color = fg)
    )
}



render_sim_result_plot <- function(df, input) {
  
  fg <- thematic_get_option("fg")
  
  ggplot(df) +
    geom_point(aes(x = estimate, y = p_value, color = true_pos)) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_color_manual(values = c("TRUE"  = "#0088ff","FALSE" = "#ff5500")
    ) + 
    geom_hline(
      yintercept = as.numeric(input$val_alpha),
      linetype = "dotted",
      color = "#888888",
      linewidth = 1.0
    ) +
    annotate(
      "text",
      x = Inf,
      y = as.numeric(input$val_alpha),
      label = paste0("α = ", input$val_alpha),
      hjust = 1.1,
      vjust = -0.5,
      size = 5
    ) +
    geom_vline(
      xintercept = input$val_true_effect,
      linetype = "dotted",
      color = "#888888",
      linewidth = 1.0
    ) +
    annotate(
      "text",
      x = input$val_true_effect,
      y = Inf,
      label = paste0("True effect = ", input$val_true_effect),
      angle = 90,
      hjust = 1.2,
      vjust = 1.5,
      size = 5
    ) +
    # theme_classic() 
    theme_minimal() +
      theme(
        plot.margin = margin(t = 20, r = 10, b = 10, l = 10),
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.background = element_rect(fill = "transparent", color = NA),
        panel.grid = element_blank(),
        panel.border = element_rect(fill = NA, color = fg, linewidth = 0.8),
        axis.ticks = element_line(color = fg),
        axis.text = element_text(color = fg, size = 11),
        axis.title = element_text(color = fg),
        text = element_text(color = fg),
        legend.position = "none"
      )

}





