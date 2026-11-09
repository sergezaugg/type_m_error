# ---------------------------
# Description : main app's entry point
# Author : Serge Zaugg
# ---------------------------

library(shiny)
library(tidyverse)

source("src/utils_sim.R")


ui <- fluidPage(
  
  fluidRow(
    
    column(
      width = 4,

      wellPanel(
        h4("Simulation parameters"),
        
        fluidRow(
          
          column(
            width = 6,
            
            sliderInput(
              "val_n_per_group", "Sample size per group",
              min = 5, max = 200, value = 30, step = 1
            ),
         
            sliderInput(
              "val_true_effect", "True effect",
              min = 0, max = 2, value = 0.5, step = 0.05
            ),
            
            sliderInput(
              "val_true_sd", "True SD",
              min = 0.1, max = 3, value = 1.0, step = 0.1
            )
          ),
          
          column(
            width = 6,
            
            sliderInput(
              "val_alpha", "Significance level (α)",
              min = 0.01, max = 0.10, value = 0.05, step = 0.01
            ),
            
            sliderInput(
              "val_m_studies", "N studies to simulate",
              min = 50, max = 200, value = 100, step = 10
            )
          )
        ),
      ),
      
      wellPanel(
        # h4("aaaaa"),
        actionButton("btn_rerun", "Simulate a data set"),
        plotOutput("sim_plot")
      )
    ),
    
    column(
      width = 4,
      
      wellPanel(
        h4("Simulation result (Plot)"),
        plotOutput("resu_plot")
      ),
      
      wellPanel(
        h4("Simulation result (Key indicators)"),
        textOutput("stand_eff_size"),
        textOutput("pow_calc_pow"),
        textOutput("effective_power"),
        textOutput("true_effect_display"),
        textOutput("meta_mean_from_detected"),
        textOutput("estimated_bias"),
        textOutput("estimated_rel_bias")
  
      )
    ),
    
    
    column(
      width = 4,
      
      wellPanel(
        h4("Methods ...")
      )
    )
    
  )
)




















server <- function(input, output, session) {
  
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
      sig.level = input$val_alpha,
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
  sim_results <- eventReactive(input$btn_rerun, {
    combine_dfs_lin(par_a(), par_b())
  })
  
  sim_plot <- reactive({
    # req(sim_results()) # prevents the plot from being rendered before the first click
    ggplot(sim_results()) +
      geom_jitter(
        aes(x = group, y = response, color = group),
        width = 0.15,
        height = 0
      )
  })
  

  #-------------------------------
  # perform the full simulation (Simulate multiple times)
  df_esti_all <- reactive(map_dfr(1:input$val_m_studies, function(i) {
    
    df_all <- combine_dfs_lin(par_a(), par_b())
    mod01 <- lm(response ~ group, data = df_all)
    
    tibble(
      iter = i,
      term = names(coef(mod01)),
      estimate = coef(mod01),
      conf_lo = confint(mod01)[, 1],
      conf_up = confint(mod01)[, 2],
      p_value = summary(mod01)$coefficients[, 4]
    )
  }))
  
  # Filter and derive from simulation results
  df_plot <- reactive(
    df_esti_all() %>%
      filter(term == "groupB") %>%
      mutate(
        true_pos = p_value <= input$val_alpha & estimate > 0
      )
  )
  
  # Prepare main plot: p-value vs estimate
  resu_plot <- reactive({
    ggplot(df_plot()) +
      geom_point(aes(x = estimate, y = p_value, color = true_pos)) +
      facet_wrap(~ term, ncol = 1, scales = "free") +
      geom_hline(
        yintercept = input$val_alpha,
        linetype = "dashed",
        color = "orange",
        linewidth = 1.5
      ) +
      geom_vline(
        xintercept = input$val_true_effect,
        linetype = "dotted",
        color = "green",
        linewidth = 1.5
      )
  })
  

  # Prepare summary stats from sum results 
  meta_results <- reactive({
    
    mean_from_det <- df_plot() %>%
      filter(true_pos == TRUE) %>%
      pull(estimate) %>%
      mean()
    
    estimated_bias <- mean_from_det - input$val_true_effect
    
    estimated_rel_bias <- 100*(estimated_bias / input$val_true_effect)
    
    
    effective_power <- sum(df_plot()$true_pos) / nrow(df_plot())
    # return as list 
    list(
      effective_power = effective_power,
      true_effect = input$val_true_effect,
      mean_from_detected = mean_from_det,
      estimated_bias = estimated_bias,
      estimated_rel_bias = estimated_rel_bias
    )
  })
  
  
  
  
  #---------------------
  # map summary stats to output tags 
  
  output$stand_eff_size <- renderText({
    paste("Standardized effect size:", round( meta_calcul()$stand_eff_size,2))
  })
  
  output$pow_calc_pow <- renderText({
    paste("Calculated power:", round( meta_calcul()$pow_calc_pow,2))
  })
  
  output$effective_power <- renderText({
    paste("Effective power:", round( meta_results()$effective_power,2))
  })
  
  output$true_effect_display <- renderText({
    paste("True effect size:", meta_results()$true_effect)
  })
  
  output$meta_mean_from_detected <- renderText({
    paste("Mean effect size from 'significant' studies:", round(meta_results()$mean_from_detected, 2))
  })
  
  output$estimated_bias <- renderText({
    paste("Estimated absolute bias:", round(meta_results()$estimated_bias, 2))
  })  
  
  output$estimated_rel_bias <- renderText({
    paste("Estimated relative bias (%):", round(meta_results()$estimated_rel_bias, 2))
  })  
  
  
  
  #---------------------
  # map plots to output tags 
  
  output$sim_plot  <- renderPlot({sim_plot()})
  
  output$resu_plot <- renderPlot({resu_plot()})
  
  
  
}









# Run the application 
shinyApp(ui = ui, server = server)
