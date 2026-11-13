# ---------------------------
# Description : page 2
# Author : Serge Zaugg
# ---------------------------

# second page

ui_page02 <- function(){ 
  
  tabPanel(
    "About",
    fluidRow(
      column(
        width = 12,
        wellPanel(
          style = "height: 760px;",
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
          h5("Methods"),
          ptext$methods_tx
        )
      )
    )
  )
  
}