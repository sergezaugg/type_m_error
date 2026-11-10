# ---------------------------
# Description : function to render plots
# Author : Serge Zaugg
# ---------------------------


render_example_dataset_plot <- function(df) {
  ggplot(df) +
    geom_jitter(
      aes(x = group, y = response, color = group),
      width = 0.15,
      height = 0
    ) +
    theme_classic() +
    theme(
      plot.margin = margin(t = 20, r = 10, b = 10, l = 10),
      panel.border = element_rect(
        color = "black",
        fill = NA,
        linewidth = 0.8
      )
    )
}


render_sim_result_plot <- function(df, input) {
  ggplot(df) +
    geom_point(aes(x = estimate, y = p_value, color = true_pos)) +
    # facet_wrap(~ term, ncol = 1, scales = "free") +
    scale_y_continuous(limits = c(0, 1)) +
    geom_hline(
      yintercept = as.numeric(input$val_alpha),
      linetype = "dotted",
      color = "#992200",
      linewidth = 1.0
    ) +
    annotate(
      "text",
      x = Inf,
      y = as.numeric(input$val_alpha),
      label = paste0("α = ", input$val_alpha),
      hjust = 1.1,
      vjust = -0.5,
      # color = "orange",
      size = 5
    ) +
    geom_vline(
      xintercept = input$val_true_effect,
      linetype = "dotted",
      color = "#009933",
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
      # color = "green",
      size = 5
    ) +
    theme_classic() +
    theme(
      plot.margin = margin(t = 20, r = 10, b = 10, l = 10),
      panel.border = element_rect(
        color = "black",
        fill = NA,
        linewidth = 0.8
      ),
      legend.position = "none"
    )
}
