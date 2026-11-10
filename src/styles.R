# ---------------------------
# Description : style-related elements and functions
# Author : Serge Zaugg
# ---------------------------

# spacing of panels 'wells' and cols
add_custom_css <- function(theme) {
  bs_add_rules(
    theme,
    "
    .well {margin-bottom: 10px;}
    .row {--bs-gutter-x: 10px;}
    .container-fluid {padding-left: 50px; padding-right: 50px;}
    "
  )
}

themes_li <- list(
  "Cerulean" = add_custom_css(bs_theme(version = 5, bootswatch = "cerulean", primary = "#aabbcc", secondary = "#ccddee")),
  "Zephyr" = add_custom_css(bs_theme(version = 5, bootswatch = "zephyr", primary = "#aabbcc", secondary = "#ccddee")),
  "Flatly" = add_custom_css(bs_theme(version = 5, bootswatch = "flatly", primary = "#aabbcc", secondary = "#ccddee")),
  "Morph"  = add_custom_css(bs_theme(version = 5, bootswatch = "morph", primary = "#aabbcc", secondary = "#ccddee"))
)

# custom style for compact cards 
style_cards <- function() {
  tags$style(HTML("
    .card-header,
    .card-body {
      padding-top: 4px;
      padding-bottom: 4px;
      font-size: 16px;
      line-height: 1.2;
    }
  "))
}

