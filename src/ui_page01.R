# ---------------------------
# Description : page 1
# Author : Serge Zaugg
# ---------------------------

# first page

ui_page01 <- function() { 
  
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
              radioButtons("val_m_studies", "M studies to simulate",
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
  )
}
