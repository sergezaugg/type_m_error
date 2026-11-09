# ---------------------------
# Description : main app's entry point
# Author : Serge Zaugg
# ---------------------------

library(shiny)
library(tidyverse)
library(bslib)

source("src/utils_sim.R")
source("src/utils_plots.R")


# bs_theme
# morph, +++   quartz, ++    # litera, ++    # lumen, +  # cosmo, +

ui <- navbarPage(
  title = "How Underpowered Research Undermines Science",
  
  theme = bs_theme(
    version = 5,
    bootswatch = "litera",
  ),
  
  tags$head(
    tags$style(HTML("
    .well {
      margin-bottom: 15px;
    }
  "))
  ),
  
  
  
  # first tab 
  tabPanel(
      "Full Sim",
      fluidRow(
        
        column(
          width = 4,
          
          wellPanel(
            style = "height: 400px;",
            h5("Simulation parameters"),
            
            fluidRow(
              
              column(
                width = 6,
                
                sliderInput(
                  "val_n_per_group", "Sample size per group",
                  min = 5, max = 200, value = 30, step = 1
                ),
                
                sliderInput(
                  "val_true_effect", "True effect",
                  min = 0, max = 1, value = 0.5, step = 0.05
                ),
                
                sliderInput(
                  "val_true_sd", "True SD",
                  min = 0.1, max = 3, value = 1.0, step = 0.1
                )
              ),
              
              column(
                width = 6,
                
                selectInput("val_alpha","Significance level (α)",
                  choices = c("0.01" = 0.01, "0.05" = 0.05, "0.10" = 0.10), selected = "0.05"
                ),
                
                selectInput("val_m_studies","N studies to simulate",
                  choices = c(10, 50, 100, 500), selected = 100
                ),
                
                tableOutput("meta_summary")
                
              )
            ),
          ),
          
          wellPanel(
            style = "height: 350px;",
            h5("Explore simulated datasets"),
            fluidRow(
              column( 
                width = 5,
                actionButton("btn_rerun", "Next data set")
              ),
              column(
                width = 7,
                plotOutput("sim_plot", height = "250px")
              )
            )
          )
        ),
        
        column(
          width = 4,
          
          wellPanel(
            style = "height: 500px;",
            
            fluidRow(
              column(width = 6,
                h5("Simulation result")
              ),
              column(width = 6,
                actionButton("btn_rerun_sim", "Re-run simulation")
              )
            ),
            
            div(style = "height: 15px;"),
            
            plotOutput("resu_plot", height = "400px")
          ),
          
          
          
          wellPanel(
            style = "height: 250px;",

            div(
              style = "display: flex; justify-content: center;",
              tableOutput("true_effect_df")
            ),
            fluidRow(
              column( 
                width = 6,
                h6("From 'significant' studies"),
                tableOutput("meta_from_signif")
              ),
              column(
                width = 6,
                h6("From all studies"),
                tableOutput("meta_from_nonsig")
              )
            )
          )
        ),
        
        
        column(
          width = 4,
          
          wellPanel(
            style = "height: 750px;",
            h5("How Underpowered Research Undermines Science"),
            
            p("Background"),
            p("Quick guide"),
            p("Solution"),
            p("Methods")
            
            
            
            
          )
        )
      )
    ),
    
  
  # second tab    
  tabPanel(
    "About",
    fluidRow()
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
  df_sim_results <- eventReactive(
    eventExpr = input$btn_rerun, 
    ignoreNULL = FALSE, # to run once before button click
    valueExpr = {combine_dfs_lin(par_a(), par_b())}
    )
  
  sim_plot <- reactive({
    render_example_dataset_plot(df = df_sim_results())
  })
  

  #-------------------------------
  # perform the full simulation (Simulate multiple times)
  df_esti_all <- reactive({
    map_dfr(1:as.numeric(input$val_m_studies), function(i) {
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
    })
  }) |>  # do the simulation when any of below items is changed   
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
  
  # Prepare main plot: p-value vs estimate
  resu_plot <- reactive({
    render_sim_result_plot(df = df_plot(), input = input)
  })
  

  # Prepare summary stats from sum results 
  meta_results <- reactive({
    
    effective_power <- sum(df_plot()$true_pos) / nrow(df_plot())
    
    # stats from significant studies subset
    mean_from_sign <- df_plot() %>% filter(true_pos == TRUE) %>% pull(estimate) %>% mean()
    estimated_abs_bias_sign <- mean_from_sign - input$val_true_effect
    estimated_rel_bias_sign <- (estimated_abs_bias_sign / input$val_true_effect)
    
    # stats from all studies 
    mean_from_all <- df_plot() %>% pull(estimate) %>% mean()
    estimated_abs_bias_ns <- mean_from_all - input$val_true_effect
    estimated_rel_bias_ns <- (estimated_abs_bias_ns / input$val_true_effect)
    
    # return as list 
    list(
      effective_power = effective_power,
      true_effect = input$val_true_effect,
      # 
      mean_from_sign = mean_from_sign,
      estimated_abs_bias_sign = estimated_abs_bias_sign,
      estimated_rel_bias_sign = estimated_rel_bias_sign,
      #
      mean_from_all = mean_from_all,
      estimated_abs_bias_ns = estimated_abs_bias_ns,
      estimated_rel_bias_ns = estimated_rel_bias_ns
      
    )
  })
  
  
  
  
  #---------------------
  # map summary stats to output mini-tables 
  
  output$meta_summary <- renderTable({
    data.frame(
      Metric = c("Std. effect size", "Calculated power", "Estimated power"),
      Value = round(c(
        meta_calcul()$stand_eff_size,
        meta_calcul()$pow_calc_pow,
        meta_results()$effective_power
      ), 2)
    )
  }, colnames = FALSE, bordered = FALSE, striped = FALSE)
  
  
  output$true_effect_display <- renderText({
    paste("True effect size:", meta_results()$true_effect)
  })
  
  output$true_effect_df <- renderTable({
    data.frame(
      Metric = c("True effect size"),
      Value = round(c(meta_results()$true_effect), 2)
    )
  }, colnames = FALSE, bordered = FALSE, striped = FALSE)
  

  output$meta_from_signif <- renderTable({
    data.frame(
      Metric = c("Mean effect size", "Absolute bias", "Relative bias"),
      Value = round(c(
        meta_results()$mean_from_sign,
        meta_results()$estimated_abs_bias_sign,
        meta_results()$estimated_rel_bias_sign
      ), 2)
    )
  }, colnames = FALSE, bordered = FALSE, striped = FALSE)
  
  
  output$meta_from_nonsig <- renderTable({
    data.frame(
      Metric = c("Mean effect size", "Absolute bias", "Relative bias"),
      Value = round(c(
        meta_results()$mean_from_all,
        meta_results()$estimated_abs_bias_ns,
        meta_results()$estimated_rel_bias_ns
      ), 2)
    )
  }, colnames = FALSE, bordered = FALSE, striped = FALSE)
  

  
  
  
  #---------------------
  # map plots to output tags 
  
  output$sim_plot  <- renderPlot({sim_plot()})
  
  output$resu_plot <- renderPlot({resu_plot()})
  
  
  
}









# Run the application 
shinyApp(ui = ui, server = server)
