# ---------------------------
# Description : server code for page 1
# Author : Serge Zaugg
# ---------------------------



server_page01 <- function(input, output, session) {
 
  observeEvent(input$theme,
               {
                 session$setCurrentTheme(themes_li[[input$theme]])
               },
               ignoreInit = TRUE
  )
  
  #--------------------------
  # wrap user input into reactive lists
  par_a <- reactive(list(
    x = 0,
    n = input$val_n_per_group,
    b0 = 0,
    sd_res0 = input$val_true_sd
  ))
  
  par_b <- reactive(list(
    x = 1,
    n = input$val_n_per_group,
    b0 = input$val_true_effect,
    sd_res0 = input$val_true_sd
  ))
  
  
  #--------------------------
  # summary stats computed directly from inputs
  meta_calcul <- reactive({
    # Standardized effect size
    stand_eff_size <- input$val_true_effect / input$val_true_sd
    # Power calculation
    pow_calc <- power.t.test(
      delta = input$val_true_effect,
      sd = input$val_true_sd,
      sig.level = as.numeric(input$val_alpha),
      n = input$val_n_per_group,
      type = "two.sample",
      alternative = "two.sided"
    )
    pow_calc_pow <- pow_calc$power
    # return as list
    list(
      stand_eff_size = stand_eff_size,
      pow_calc_pow = pow_calc_pow
    )
  })
  
  
  #--------------------------
  # Simulate one realized data set when rerun button clicked
  df_sim_results <- reactive({
    combine_dfs_lin(par_a(), par_b())
  }) |>
    bindEvent(
      input$btn_rerun,
      # input$val_m_studies,
      input$val_n_per_group,
      input$val_true_effect,
      input$val_true_sd,
      ignoreNULL = FALSE
    )
  
  #-------------------------------
  # perform the full simulation (Simulate multiple times)
  df_esti_all <- reactive({
    map_dfr(1:as.numeric(input$val_m_studies), function(i) {
      df_all <- combine_dfs_lin(par_a(), par_b())
      fit_and_prep_mod_summary(data = df_all, i = i)
    })
  }) |> # do the simulation when any of below items is changed
    bindEvent(
      input$btn_rerun_sim,
      input$val_m_studies,
      input$val_n_per_group,
      input$val_true_effect,
      input$val_true_sd,
      ignoreNULL = FALSE
    )
  
  # Filter and derive from simulation results
  df_plot <- reactive(
    df_esti_all() %>%
      filter(term == "groupB") %>%
      mutate(
        true_pos = p_value <= as.numeric(input$val_alpha) & estimate > 0
      )
  )
  
  # Prepare summary stats from sum results
  meta_results <- reactive({
    effective_power <- sum(df_plot()$true_pos) / nrow(df_plot())
    
    # meta-analysis stats from significant studies subset
    if (df_plot()$true_pos %>% sum() > 0){ # spec: capture if not any study was significant  
      ma_res_sign <- df_plot() %>% filter(true_pos == TRUE) %>% pooled_estim_from_fixeff_ma()
      poolmea_from_sign <- sprintf(
        "%.2f (%.2f-%.2f)",
        ma_res_sign$pooled_estimate,
        ma_res_sign$ci_lower,
        ma_res_sign$ci_upper
      )
      mean_from_sign <- ma_res_sign$pooled_estimate
      estimated_abs_bias_sign <- mean_from_sign - input$val_true_effect
      estimated_rel_bias_sign <- (estimated_abs_bias_sign / input$val_true_effect)
    } else {
      poolmea_from_sign <- "Not applicable"
      mean_from_sign <- NA
      estimated_abs_bias_sign <- NA
      estimated_rel_bias_sign <- NA
    }
    
    # meta-analysis stats from all studies
    ma_res_all <- df_plot() %>% pooled_estim_from_fixeff_ma()
    poolmea_from_all <- sprintf(
      "%.2f (%.2f-%.2f)",
      ma_res_all$pooled_estimate,
      ma_res_all$ci_lower,
      ma_res_all$ci_upper
    )
    mean_from_all <- ma_res_all$pooled_estimate
    estimated_abs_bias_ns <- mean_from_all - input$val_true_effect
    estimated_rel_bias_ns <- (estimated_abs_bias_ns / input$val_true_effect)
    
    # return as list
    list(
      effective_power = effective_power,
      true_effect = input$val_true_effect,
      #
      mean_from_sign = mean_from_sign,
      poolmea_from_sign = poolmea_from_sign,
      estimated_abs_bias_sign = estimated_abs_bias_sign,
      estimated_rel_bias_sign = estimated_rel_bias_sign,
      #
      mean_from_all = mean_from_all,
      poolmea_from_all = poolmea_from_all,
      estimated_abs_bias_ns = estimated_abs_bias_ns,
      estimated_rel_bias_ns = estimated_rel_bias_ns
    )
  })
  
  
  #---------------------
  # map summary stats to output tags
  output$stand_eff_size <- renderText({
    sprintf("%.2f", meta_calcul()$stand_eff_size)
  })
  output$pow_calc_pow <- renderText({
    sprintf("%.0f%%", 100 * meta_calcul()$pow_calc_pow)
  })
  output$true_effect <- renderText({
    sprintf("%.2f", meta_results()$true_effect)
  })
  
  
  output$mean_from_sign <- renderText({
    sprintf("%.2f", meta_results()$mean_from_sign)
  })
  output$poolmea_from_sign <- renderText({
    meta_results()$poolmea_from_sign
  })
  output$estimated_abs_bias_sign <- renderText({
    sprintf("%.2f", meta_results()$estimated_abs_bias_sign)
  })
  
  
  output$mean_from_all <- renderText({
    sprintf("%.2f", meta_results()$mean_from_all)
  })
  output$poolmea_from_all <- renderText({
    meta_results()$poolmea_from_all
  })
  output$estimated_abs_bias_ns <- renderText({
    sprintf("%.2f", meta_results()$estimated_abs_bias_ns)
  })
  
  #---------------------
  # map plots to output tags
  
  # Render the plot directly so thematic_get_option("fg") reads the live CSS color
  output$sim_plot <- renderPlot({
    render_example_dataset_plot(df = df_sim_results())
  })
  
  output$resu_plot <- renderPlot({
    render_sim_result_plot(df = df_plot(), input = input)
  })
  
  
  
}




