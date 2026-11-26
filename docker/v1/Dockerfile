#------------------------
# Applied Stats Playground — Dockerfile
# Author: Serge Zaugg
# Purpose: Build and run the R Shiny application
#------------------------

FROM rocker/shiny:4.5.1

# Application directory
WORKDIR /srv/shiny-server

# Install Linux system dependencies
RUN apt-get update && apt-get install -y \
    libwebp-dev \
    libwebpdemux2 \
    libwebpmux3 \
    && rm -rf /var/lib/apt/lists/*

# Remove default Shiny examples and welcome page
RUN rm -rf /srv/shiny-server/*

# Copy application
COPY . /srv/shiny-server/



# Install renv
RUN R --vanilla -e "install.packages('renv', repos='https://cloud.r-project.org')"

# Avoid symlinks to root user's renv cache
ENV RENV_CONFIG_CACHE_SYMLINKS=FALSE

# Restore R packages
RUN R -e "renv::restore(prompt = FALSE)"

# Shiny Server port
EXPOSE 3838

# rocker/shiny ships a non-root 'shiny' user — run as it
USER shiny 

# command to execute when a container starts
CMD ["/usr/bin/shiny-server"]


