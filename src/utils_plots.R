# ---------------------------
# Description : function to render plots
# Author : Serge Zaugg
# ---------------------------

render_example_dataset_plot <- function(df, input) {
  
  # dynamically handle theme 
  dark_mode = identical(input$dark_mode, "dark")
  bg_col <- if (dark_mode) "#000000" else "white"
  fg_col <- if (dark_mode) "#E0E0E0" else "#000000"
  bordr_col <- if (dark_mode) "#cccccc" else "#999999"
  p_col_1 <- if (dark_mode) "#0088ff" else "#0088ff"
  p_col_2 <- if (dark_mode) "#ff5500" else "#ff5500"  
  
  ggplot(df) +
    geom_jitter(
      aes(x = group, y = response, color = group),
      width = 0.15,
      height = 0
    ) +
    theme_minimal() +
    theme(
      plot.margin = margin(t = 20, r = 10, b = 10, l = 10),
      panel.background = element_rect(fill = bg_col),
      plot.background = element_rect(fill = bg_col),
      panel.border = element_rect(fill = NA, color = bordr_col, linewidth = 0.8),
      panel.grid = element_blank(),
      axis.ticks = element_line(color = fg_col),
      axis.text = element_text(color = fg_col, size = 11),
      axis.title = element_text(color = fg_col),
      text = element_text(color = fg_col)
    )
}



render_sim_result_plot <- function(df, input) {
  
  # dynamically handl theme 
  dark_mode = identical(input$dark_mode, "dark")
  bg_col <- if (dark_mode) "#000000" else "white"
  fg_col <- if (dark_mode) "#E0E0E0" else "#000000"
  bordr_col <- if (dark_mode) "#bbbbbb" else "#777777"
  p_col_1 <- if (dark_mode) "#0088ff" else "#0088ff"
  p_col_2 <- if (dark_mode) "#ff5500" else "#ff5500"
  
  ggplot(df) +
    geom_point(aes(x = estimate, y = p_value, color = true_pos)) +
      scale_y_continuous(limits = c(0, 1)) +
      scale_color_manual(values = c("TRUE"  = p_col_1, "FALSE" = p_col_2)
    ) + 
    geom_hline(
      yintercept = as.numeric(input$val_alpha),
      linetype = "dotted",
      color = bordr_col,
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
      color = bordr_col,
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
    theme_minimal() +
    theme(
      plot.margin = margin(t = 20, r = 10, b = 10, l = 10),
      panel.background = element_rect(fill = bg_col),
      plot.background = element_rect(fill = bg_col),
      panel.grid = element_blank(),
      panel.border = element_rect(fill = NA, color = bordr_col, linewidth = 0.8),
      axis.ticks = element_line(color = fg_col),
      axis.text = element_text(color = fg_col, size = 11),
      axis.title = element_text(color = fg_col),
      text = element_text(color = fg_col),
      legend.position = "none"
    )

}





