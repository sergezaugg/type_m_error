# ---------------------------
# Description : sandbox to draft code pieces
# Author : Serge Zaugg
# 
# renv cheatsheet
# renv::init()
# renv::status()   # Check whether lockfile and library are synchronised
# renv::snapshot() # Update renv.lock (uses static code analysis, not the packages currently loaded)
# renv::activate()
# renv::restore()  # Restore packages from renv.lock
# ---------------------------

# mod01 <- lm(response ~ group, data = df_all)
# mod01 %>% summary()
# df_esti <- tibble(
#   term = names(coef(mod01)),
#   estimate = coef(mod01),
#   conf_lo = confint(mod01)[,1],
#   conf_up = confint(mod01)[,2],
#   p_value = summary(mod01)$coefficients[, 4]
# )

# install.packages("styler")
# styler::style_file("pages/page_x_same.R")

source("src/utils_sim.R")
library(tidyverse)

#-------------------------------
# (pannel 1) inputs

val_alpha <- 0.05
val_true_effect <- 0.5
val_true_sd <- 1.0
val_n_per_group <- 30
val_m_studies <- 200

par_a <- list(x=0 ,n=val_n_per_group ,b0=0, sd_res0 = val_true_sd)
par_b <- list(x=1 ,n=val_n_per_group ,b0=0+val_true_effect, sd_res0 = val_true_sd)

#-------------------------------
# (pannel 2) values derived directly from input

# standardized effect size 
stand_eff_size <- val_true_effect / val_true_sd

# power 
pow_calc <- power.t.test(
  delta = val_true_effect,       
  sd = val_true_sd,         
  sig.level = val_alpha,
  n = val_n_per_group,
  type = "two.sample",
  alternative = "two.sided"
)

pow_calc_pow <- pow_calc$power

# to show on panel 
print(stand_eff_size)
print(pow_calc_pow)

#-------------------------------
# (pannles 3) simulate and plot one data set 
df_all <- combine_dfs_lin(par_a, par_b)
ggplot(df_all) +
  geom_jitter(aes(x = group, y = response, color = group), width = 0.15, height = 0)

#-------------------------------
# (server) simulate

# sim multiple times 
df_esti_all <- map_dfr(1:val_m_studies, function(i) {
  df_all <- combine_dfs_lin(par_a, par_b)
  mod01 <- lm(response ~ group, data = df_all)
  tibble(
    iter = i,
    term = names(coef(mod01)),
    estimate = coef(mod01),
    conf_lo = confint(mod01)[,1],
    conf_up = confint(mod01)[,2],
    p_value = summary(mod01)$coefficients[, 4]
  )
})

#-------------------------------
# (server) derive values fro sim results 

# filter and derive from sim result  
df_plot <- df_esti_all %>%
  filter(term == "groupB") %>% 
  mutate(true_pos = p_value <= val_alpha & estimate > 0.0)
# compute derived metrics
effective_power <- sum(df_plot$true_pos) / nrow(df_plot)
# simple meta mean
meta_mean_from_detected <- df_plot %>% filter(true_pos == TRUE) %>% pull(estimate ) %>% mean() 

#-------------------------------
# (4) plot p-val vs estimate   
ggplot(df_plot) +
  geom_point(aes(x = estimate, y = p_value, color = true_pos)) +
  facet_wrap(~ term, ncol = 1, scales = "free") +
  geom_hline(yintercept = val_alpha, linetype = "dashed", color = "orange", linewidth = 1.5) +
  geom_vline(xintercept = val_true_effect, linetype = "dotted", color = "green", linewidth = 1.5)

#-------------------------------
# (5) main sim metrics    
print(val_true_effect)
print(meta_mean_from_detected)
print(effective_power)








