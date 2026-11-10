# ---------------------------
# Description : main app's entry point
# Author : Serge Zaugg
# ---------------------------

library(shiny)
library(tidyverse)
library(bslib)

source("src/utils_sim.R")
source("src/utils_plots.R")

# Tell shiny where to find resources
addResourcePath("resources", "resources")



ui <-  tagList(
  navbarPage(
  
  #-------------------------    
  # (1) styling and formats  
  
  # custom formatted title 
  title = tags$span(
    style = "display: inline-flex; align-items: center; gap: 10px;",
    tags$img(src = "resources/z_logo_blue.png", height = "30px"),
    tags$span("Underpowered Research Undermines Science")
  ),
  
  # main app's theme 
  theme = bs_theme(
    version = 5,
    bootswatch = "zephyr", # zephyr, morph, quartz, litera, lumen, cosmo,
    # bg = "#dddddd", 
    # fg = "#000000", 
    primary = "#aabbcc", 
    secondary = "#ccddee"
  ),

  # add static text for version and © at bottom
  tags$div(
    "v0.5.0 - © 2026 Serge Zaugg",
    style = "position: fixed;bottom: 8px; left: 20px;
      font-size: 14px; color: #888888; opacity: 1.0; z-index: 9999;
    "
  ),
  
  # spacing
  tags$head(
    # adds v-space below each wellPanel
    tags$style(HTML(".well {margin-bottom: 10px;}")),
    # adds h-space between columns
    tags$style(HTML(".row {--bs-gutter-x: 10px;}")),
    # adds h-space left and right of main canevas
    tags$style(HTML(".container-fluid {padding-left: 50px; padding-right: 50px;}"))
  ),
  
  

  tags$style(HTML("
  .card-header {
    padding-top: 4px;
    padding-bottom: 4px;
    font-size: 16px;
    line-height: 1.2;
  }
  ")),
  
  tags$style(HTML("
  .card-body {
    padding-top: 4px;
    padding-bottom: 4px;
    font-size: 16px;
    line-height: 1.2;
  }
  ")),

  

  #-------------------------    
  # (2) pages   

  # first page
  tabPanel(
    "Full Sim",
    fluidRow(
      
      column(
        width = 4,
        wellPanel(
          style = "height: 400px;",
          h5("Simulation parameters"),
          div(style = "height: 25px;"),
          fluidRow(
            column(
              width = 5,
              sliderInput(
                "val_n_per_group", "Sample size per group",
                min = 5, max = 200, value = 30, step = 1, ticks = FALSE,
              ),
              sliderInput(
                "val_true_effect", "True effect",
                min = 0, max = 1, value = 0.5, step = 0.05, ticks = FALSE,
              ),
              sliderInput(
                "val_true_sd", "True SD",
                min = 0.1, max = 3, value = 1.5, step = 0.1, ticks = FALSE,
              )
            ),
            # h-space empty columns
            column(width = 2,),
            # 2nd col
            column(
              width = 5,
              radioButtons("val_alpha", "Significance level (α)",
                choices = c("0.01" = 0.01, "0.05" = 0.05, "0.10" = 0.10), selected = "0.05",
                # width = "100px"
                inline = TRUE
              ),
              radioButtons("val_m_studies", "N studies to simulate",
                choices = c(10, 50, 100, 500), selected = 100,
                # width = "100px"
                inline = TRUE
              ),
              tableOutput("meta_summary")
            )
          ),
        ),
        wellPanel(
          style = "height: 350px;",
          fluidRow(
            column(width = 5,
              h5("Explore datasets"),
              p("Inspect a few simulated datasets.
                Each dataset is different due to simlated random error (SD).
                In full simulation, multiples datasets are generated.
                ")       
            ),
            column(width = 7,
              div(
               style = "text-align: right;",
               actionButton("btn_rerun", "Next data set")
              ),
              div(style = "height: 15px;"),
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
            column(
              width = 6,
              h5("Simulation result")
            ),
            column(
              width = 6,
              div(
                style = "text-align: right;",
                actionButton("btn_rerun_sim", "Re-run simulation")
              )
            )
          ),
          div(style = "height: 15px;"),
          plotOutput("resu_plot", height = "400px")
        ),
        wellPanel(
          style = "height: 250px;",
          
          fluidRow(
          
            column(width = 4,
              h6("Reference"),
              card(
                height = "70px",
                padding = 0,
                card_header("True effect"),
                card_body(
                  h2(textOutput("true_effect"),
                     style = "color: #0099ff; margin: 0; font-size: 20px;"
                  )
                )
              ),
            ),
          
            column(
              width = 4,
              h6("All studies"),
              
              card(
                height = "70px",
                padding = 0,
                card_header("Mean effect"),
                card_body(
                  h2(textOutput("mean_from_all"),
                     style = "color: #0099ff; margin: 0; font-size: 20px;"
                  )
                )
              ),
              
              card(
                height = "70px",
                padding = 0,
                card_header("Bias"),
                card_body(
                  h2(textOutput("estimated_abs_bias_ns"),
                     style = "color: #0099ff; margin: 0; font-size: 20px;"
                  )
                )
              )
            ) ,
            
            column(
              width = 4,
              h6("'significant' studies"),
             
              card(
                height = "70px",
                padding = 0,
                card_header("Mean effect"),
                card_body(
                  h2(textOutput("mean_from_sign"),
                    style = "color: #0099ff; margin: 0; font-size: 20px;"
                  )
                )
              ),
              
              card(
                height = "70px",
                padding = 0,
                card_header("Bias"),
                card_body(
                  h2(textOutput("estimated_abs_bias_sign"),
                     style = "color: #0099ff; margin: 0; font-size: 20px;"
                  )
                )
              )
            )
            

            
          )
        )
      ),
      column(
        width = 4,
        wellPanel(
          style = "height: 760px;",
          h5("Underpowered Research Undermines Science"),
          
          h6("Background"),
          p("
          Research is constrained by competition between researchers 
          and the need for fast publication. 
          Consequently, researchers are incentivized to conduct studies with smaller sample sizes.
          The claimed power (typically 80%) is often 
          based on unrealistic assumptions and the effective power is much lower.
          Combined with the selective publication of 'significant' results, 
          this increases the Type M error (Magnitude error), i.e. published results overestimate 
          the true effect.
          "),
          
          h6("This app"),
          p("With this app, you can simulate the above phenomena using simple but formal 
            statistics and assess the severity of the problem."),
          
          h6("Quick guide"),
          p("
            Use the sliders & radio buttons to define the study and sample size.
            Also asses parameters that give effective power below 80%.
            In the results pane, see how estimated effect sizes and p-values are related
            and how selective publication biases the evidence.
            The bottom pane shows evidence under selective publication compared 
            to 'all-studies-published'.
            "),
          
          
          h6("Conclusion"),
          p("Well that is up to you ;-)  
          
          ... as a statistician, I can only say that I have seen 
          how political and strategic reasoning forces wrong assumptions into sample size calculations
          leading to effective power well below the claimed 80%.")
         
        )
      )
    )
  ),


  # second page
  tabPanel(
    "About",
    fluidRow()
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
  df_sim_results <- reactive(
    combine_dfs_lin(par_a(), par_b())
  )

  sim_plot <- reactive({
    render_example_dataset_plot(df = df_sim_results())
  }) |> # do when any of below items is changed
    bindEvent(
      input$btn_rerun,
      input$val_m_studies,
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

  # Prepare main plot: p-value vs estimate
  resu_plot <- reactive({
    render_sim_result_plot(df = df_plot(), input = input)
  })


  # Prepare summary stats from sum results
  meta_results <- reactive({
    effective_power <- sum(df_plot()$true_pos) / nrow(df_plot())

    # stats from significant studies subset
    mean_from_sign <- df_plot() %>%
      filter(true_pos == TRUE) %>%
      pull(estimate) %>%
      mean()
    estimated_abs_bias_sign <- mean_from_sign - input$val_true_effect
    estimated_rel_bias_sign <- (estimated_abs_bias_sign / input$val_true_effect)

    # stats from all studies
    mean_from_all <- df_plot() %>%
      pull(estimate) %>%
      mean()
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

  output$meta_summary <- renderTable(
    {
      data.frame(
        Metric = c("Std. effect size", "Effective power"),
        Value = round(c(
          meta_calcul()$stand_eff_size,
          meta_calcul()$pow_calc_pow
        ), 2)
      )
    },
    colnames = FALSE,
    bordered = FALSE,
    striped = FALSE
  )

  output$true_effect_display <- renderText({
    paste("True effect size:", meta_results()$true_effect)
  })

  # --------
  output$true_effect             <- renderText({sprintf("%.2f", meta_results()$true_effect)})
  output$mean_from_sign          <- renderText({sprintf("%.2f",meta_results()$mean_from_sign)})
  output$estimated_abs_bias_sign <- renderText({sprintf("%.2f",meta_results()$estimated_abs_bias_sign)})
  output$mean_from_all           <- renderText({sprintf("%.2f",meta_results()$mean_from_all)})
  output$estimated_abs_bias_ns   <- renderText({sprintf("%.2f",meta_results()$estimated_abs_bias_ns)})
  

 


 

  #---------------------
  # map plots to output tags

  output$sim_plot <- renderPlot({
    sim_plot()
  })

  output$resu_plot <- renderPlot({
    resu_plot()
  })
}


# Run the application
shinyApp(ui = ui, server = server)
