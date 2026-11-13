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

# 
# # spacing of panels 'wells' and cols
# add_custom_css <- function(theme) {
#   bs_add_rules(
#     theme,
#     "
#     .well {margin-bottom: 10px;}
#     .row {--bs-gutter-x: 10px;}
#     .container-fluid {padding-left: 50px; padding-right: 50px;}
#     "
#   )
# }

themes_li <- list(
  # "Cerulean" = add_custom_css(bs_theme(version = 5, bootswatch = "cerulean", primary = "#aabbcc", secondary = "#aabbcc")),
  # "Zephyr" = add_custom_css(bs_theme(version = 5, bootswatch = "zephyr", primary = "#aabbcc", secondary = "#ccddee")),
  # "Flatly" = add_custom_css(bs_theme(version = 5, bootswatch = "flatly", primary = "#aabbcc", secondary = "#ccddee")),
  # "Morph"  = add_custom_css(bs_theme(version = 5, bootswatch = "morph", primary = "#aabbcc", secondary = "#ccddee"))
  "Cerulean" = (bs_theme(version = 5, bootswatch = "cerulean", primary = "#aabbcc", secondary = "#aabbcc")),
  "Zephyr" = (bs_theme(version = 5, bootswatch = "zephyr", primary = "#aabbcc", secondary = "#ccddee")),
  "Flatly" = (bs_theme(version = 5, bootswatch = "flatly", primary = "#aabbcc", secondary = "#ccddee")),
  "Morph"  = (bs_theme(version = 5, bootswatch = "morph", primary = "#aabbcc", secondary = "#ccddee"))
)


# Precompile
invisible(lapply(themes_li, bs_theme_dependencies))


