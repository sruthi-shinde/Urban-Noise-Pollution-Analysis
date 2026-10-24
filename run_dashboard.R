# Launch the live dashboard (runs the pipeline first if the data does not exist yet)
if (!file.exists("data/processed/noise_clean.rds")) source("main.R")
shiny::runApp("dashboard", launch.browser = TRUE)
