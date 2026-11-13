# ---------------------------
# Description : main app's entry point
# Author : Serge Zaugg
# ---------------------------

library(shiny)
library(tidyverse)
library(bslib)
library(metafor)
library(thematic)

source("src/utils_sim.R")
source("src/utils_plots.R")
source("src/styles.R")
source("pages/text_for_pages.R")

# Tell shiny where to find resources
addResourcePath("resources", "resources")

# Automatically style R plots to match bslib / Shiny themes
thematic_shiny()

ui <- tagList(
  # get CSS styles 
  includeCSS("resources/styles.css"),
  # custom footer note 
  app_custom_footer(text = "v0.9.4-β - © 2026 Serge Zaugg"),
  
  navbarPage(
    # custom formatted title
    title = app_custom_title(text = "Underpowered Research Undermines Science"),
    # main app's theme (initial)
    theme = themes_li$Cerulean,

    #-------------------------
    # (2) pages

    # first page
    tabPanel(
      "Simulate",
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
                  min = 5, max = 200, value = 70, step = 1, ticks = FALSE,
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
              column(width = 2, ),
              # 2nd col
              column(
                width = 5,
                radioButtons("val_alpha", "Significance level (α)",
                  choices = c("0.01" = 0.01, "0.05" = 0.05, "0.10" = 0.10), selected = "0.05",
                  # width = "100px"
                  inline = TRUE
                ),
                radioButtons("val_m_studies", "N studies to simulate",
                  choices = c(10, 50, 100), selected = 100,
                  # width = "100px"
                  inline = TRUE
                ),
                card(
                  height = "70px",
                  padding = 0,
                  card_header("Std. effect size"),
                  card_body(
                    h2(textOutput("stand_eff_size"),
                      style = "color: #0099ff; margin: 0; font-size: 20px;"
                    )
                  )
                ),
                card(
                  height = "70px",
                  padding = 0,
                  card_header("Effective power"),
                  card_body(
                    h2(textOutput("pow_calc_pow"),
                      style = "color: #0099ff; margin: 0; font-size: 20px;"
                    )
                  )
                ),
              )
            ),
          ),
          wellPanel(
            style = "height: 350px;",
            fluidRow(
              column(
                width = 5,
                h5("Explore datasets"),
                div(style = "height: 25px;"),
                p(ptext$info_expl_datasets_tx)
              ),
              column(
                width = 7,
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
              column(
                width = 4,
                h6("Reference"),
                card(
                  height = "70px",
                  padding = 0,
                  card_header("True effect"),
                  card_body(
                    h2(textOutput("true_effect"),
                      style = "color: #0099ff; margin: 0; font-size: 16px;"
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
                  card_header("Pooled effect"),
                  card_body(
                    h2(textOutput("poolmea_from_all"),
                       style = "color: #0099ff; margin: 0; font-size: 16px;"
                    )
                  )
                ),
                
                card(
                  height = "70px",
                  padding = 0,
                  card_header("Bias"),
                  card_body(
                    h2(textOutput("estimated_abs_bias_ns"),
                      style = "color: #0099ff; margin: 0; font-size: 16px;"
                    )
                  )
                )
              ),
              column(
                width = 4,
                h6("'significant' studies"),

                card(
                  height = "70px",
                  padding = 0,
                  card_header("Pooled effect"),
                  card_body(
                    h2(textOutput("poolmea_from_sign"),
                       style = "color: #0099ff; margin: 0; font-size: 16px;"
                    )
                  )
                ),
                
                card(
                  height = "70px",
                  padding = 0,
                  card_header("Bias"),
                  card_body(
                    h2(textOutput("estimated_abs_bias_sign"),
                      style = "color: #0099ff; margin: 0; font-size: 16px;"
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
            h5(ptext$info_mainti_ti),
            h6(ptext$info_background_ti),
            p(ptext$info_background_tx),
            h6(ptext$info_thisapp_ti),
            p(ptext$info_thisapp_tx),
            h6(ptext$info_guide_ti),
            p(ptext$info_guide_tx),
            h6(ptext$info_hint_ti),
            p(ptext$info_hint_tx)
          )
        )
      )
    ),


    # second page
    tabPanel(
      "About",
      fluidRow(
        column(
          width = 4,
          div(
            h5("Author"),
            tags$p(
              "Serge Zaugg (",
              tags$a("LinkedIn",
                href = "https://www.linkedin.com/in/dkifh34rtn345eb5fhrthdbgf45/",
                target = "_blank"
              ),
              ", ",
              tags$a("GitHub",
                href = "https://github.com/sergezaugg",
                target = "_blank"
              ),
              ")"
            )
          ),
          h5("Metods"),
          p("'Effect' represents the true or estimated difference in mean values between groups A and B."),
          p("Pooled effect and 95%-CIs obtained from simple fixed-effect meta-analysis"),
        )
      )
    ),
    
    # second page
    tabPanel(
      "BETA",
      fluidRow(
        column(
          width = 8,
          div(
            h5("This app is in BETA stage"),
            # p("Maybe: "),
            # p("Extend app to binary and count outcomes")
          )
        )
      )
    ),

    # to push all elements below to the right
    nav_spacer(),
    nav_item(p("Theme")),
    nav_item(input_dark_mode(id = "mode", mode = "light")), 

  )
)


server <- function(input, output, session) {
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


# Run the application
shinyApp(ui = ui, server = server)
