
library(shiny)

ui <- fluidPage(
  
  fluidRow(
    
    # Column 1: 3 stacked panels
    column(
      width = 4,

      wellPanel(
        h4("Panel 1.1 - Simulation parameters"),
        
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
              "val_m_studies", "Number of studies",
              min = 50, max = 200, value = 100, step = 10
            )
          )
        ),
        verbatimTextOutput("calc_results")
      ),
      
      wellPanel(
        # h4("Panel 1.3 - Simulation results"),
        actionButton("btn_rerun", "Simulate a data set"),
        plotOutput("sim_plot")
      )
    ),
    
    # Column 2: 2 stacked panels
    column(
      width = 4,
      
      wellPanel(
        h4("Panel 2.1"),
        plotOutput("resu_plot")
      ),
      
      wellPanel(
        h4("Panel 2.2"),
        textOutput("effective_power"),
        textOutput("true_effect_display"),
        textOutput("meta_mean_from_detected")
      )
    ),
    
    # Column 3: 1 panel
    column(
      width = 4,
      
      wellPanel(
        h4("Panel 3.1")
      )
    )
    
  )
)



server <- function(input, output, session) {
  
  #--------------------------
  output$calc_results <- renderPrint({
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
    # Display results
    cat("Standardized effect size:", round(stand_eff_size, 3), "\n")
    cat("Statistical power:", round(pow_calc_pow, 3), "\n")
  })
  
  

  #--------------------------
    # Simulate only when rerun button is clicked
    sim_results <- eventReactive(input$btn_rerun, {
      
      par_a <- list(
        x = 0,
        n = input$val_n_per_group,
        b0 = 0,
        sd_res0 = input$val_true_sd
      )
      
      par_b <- list(
        x = 1,
        n = input$val_n_per_group,
        b0 = input$val_true_effect,
        sd_res0 = input$val_true_sd
      )
      
      combine_dfs_lin(par_a, par_b)
      
    })
  
  # Plot simulation results
  output$sim_plot <- renderPlot({
    
    req(sim_results())
    
    ggplot(sim_results()) +
      geom_jitter(
        aes(x = group, y = response, color = group),
        width = 0.15,
        height = 0
      )
    
  })
  
  #--------------------------
  
  
  #-------------------------------
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
  
  # Simulate multiple times
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
  
  output$effective_power <- renderText({
    aa <- sum(df_plot()$true_pos) / nrow(df_plot())
    paste("Effective power:", round(aa,2))
  })
  
  # true effect
  output$true_effect_display <- renderText({
    paste("True effect:", input$val_true_effect)
  })
  
  # meta_mean_from_detected
  output$meta_mean_from_detected <- renderText({
    mean_from_det <- df_plot() %>% filter(true_pos == TRUE) %>% pull(estimate) %>% mean()
    paste("Effect from significant:", round(mean_from_det,2))
  })
  
 
  
  
  
  # Plot p-value vs estimate
  output$resu_plot <- renderPlot({
    
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
  
  
  
}









# Run the application 
shinyApp(ui = ui, server = server)
