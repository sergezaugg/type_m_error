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
source("src/utils_styles.R")
source("pages/text_for_pages.R")
source("src/ui_page01.R")
source("src/ui_page02.R")
source("src/server_page01.R")

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
    # pages
    ui_page01(),
    ui_page02(),
    # to push all elements below to the right
    nav_spacer(),
    nav_item(p("Theme")),
    nav_item(input_dark_mode(id = "mode", mode = "light")), 

  )
)

server <- function(input, output, session) {
  server_page01(input, output, session)
}

# Run the application
shinyApp(ui = ui, server = server)
