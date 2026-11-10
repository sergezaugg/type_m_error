

# 
# 
# style_card_header <- function() {
#   tags$style(HTML("
#     .card-header {
#       padding-top: 4px;
#       padding-bottom: 4px;
#       font-size: 16px;
#       line-height: 1.2;
#     }
#   "))
# }

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
