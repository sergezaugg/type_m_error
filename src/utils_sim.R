# ---------------------------
# Description : Pure simulation and stats functions
# Author : Serge Zaugg
# ---------------------------

# helper function : simulate data based on b0 
simulate_linear_data <- function(par){ 
  x <- rep(par$x, par$n) 
  y <- par$b0
  y <- y + rnorm(n = par$n, mean = 0, sd = par$sd_res)
  df <- tibble(predictor = x, response = y)
  return(df)
}

combine_dfs_lin <- function(...) {
  pars <- list(...)
  dfs <- lapply(seq_along(pars), function(i) {
    df <- simulate_linear_data(pars[[i]])
    df$group <- LETTERS[i]
    df
  })
  dfs <- bind_rows(dfs)
  dfs <- dfs %>% mutate(group = factor(group) )
  return(dfs)
}





