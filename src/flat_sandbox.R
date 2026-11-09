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
