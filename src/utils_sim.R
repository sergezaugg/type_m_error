# ---------------------------
# Description : Pure simulation and stats functions
# Author : Serge Zaugg
# ---------------------------

# helper function : simulate data based on b0
simulate_linear_data <- function(par) {
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
  dfs <- dfs %>% mutate(group = factor(group))
  return(dfs)
}


fit_and_prep_mod_summary <- function(data, i){
  mod01 <- lm(response ~ group, data = data)
  tibble(
    iter = i,
    term = names(coef(mod01)),
    estimate = coef(mod01),
    se_value = summary(mod01)$coefficients[, 2], # NEW !
    conf_lo = confint(mod01)[, 1],
    conf_up = confint(mod01)[, 2],
    p_value = summary(mod01)$coefficients[, 4]
  )  
}


pooled_estim_from_fixeff_ma <- function(df){
  # fixed effects meta analysis 
  ma_mod <- rma(
    yi = estimate,
    sei = se_value,
    data = df,
    method = "FE"
  )
  # return 
  list(
    pooled_estimate = as.numeric(coef(ma_mod)),
    ci_lower = ma_mod$ci.lb,
    ci_upper = ma_mod$ci.ub
  )
}






