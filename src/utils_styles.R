# ---------------------------
# Description : style-related elements and functions
# Author : Serge Zaugg
# ---------------------------

app_custom_footer <- function(text) {
  tags$div(
    text,
    class = "app-footer"
  )
}

app_custom_title <- function(text){
  tags$span(
    style = "display: inline-flex; align-items: center; gap: 10px;",
    tags$img(src = "resources/z_logo_blue.png", height = "30px"),
    tags$span(text)
  )
}

themes_li <- list(
  "Cerulean" = (bs_theme(version = 5, bootswatch = "cerulean", primary = "#aabbcc", secondary = "#aabbcc")),
  "Zephyr" = (bs_theme(version = 5, bootswatch = "zephyr", primary = "#aabbcc", secondary = "#ccddee")),
  "Flatly" = (bs_theme(version = 5, bootswatch = "flatly", primary = "#aabbcc", secondary = "#ccddee")),
  "Morph"  = (bs_theme(version = 5, bootswatch = "morph", primary = "#aabbcc", secondary = "#ccddee"))
)

# Precompile
invisible(lapply(themes_li, bs_theme_dependencies))


