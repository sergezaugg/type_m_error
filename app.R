# ---------------------------
# Description : main app's entry point
# Author : Serge Zaugg
# ---------------------------

library(shiny)
library(tidyverse)
library(bslib)
library(metafor)

source("src/utils_sim.R")
source("src/utils_plots.R")
source("src/utils_styles.R")
source("src/ui_page01.R")
source("src/ui_page02.R")
source("src/server_page01.R")
source("contents/text_for_pages.R")

# Tell shiny where to find contents
addResourcePath("contents", "contents")

ui <- tagList(
  # get CSS styles 
  includeCSS("styles/styles.css"),
  # custom footer note 
  app_custom_footer(text = "v0.9.5-β - © 2026 Serge Zaugg"),
  navbarPage(
    # custom formatted title
    title = app_custom_title(text = "Underpowered Research Undermines Science"),
    # main app's theme (initial)
    theme = themes_li$Cerulean,
    navbar_options = navbar_options(theme = "auto"),
    # pages
    ui_page01(),
    ui_page02(),
    # elements right of navbar
    nav_spacer(),
    nav_item(app_custom_theme_title("Theme")),
    nav_item(input_dark_mode(id = "dark_mode", mode = "light")), 
  )
)

server <- function(input, output, session) {
  server_page01(input, output, session)
}

# Run the application
shinyApp(ui = ui, server = server)
