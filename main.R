# =============================================================================
# main.R  |  Run the complete pipeline:  source("main.R")   (working dir = project root)
# =============================================================================
steps <- c(
  "R/01_generate_dataset.R",   # skip this line if you use your own real CSV
  "R/02_import.R",
  "R/03_cleaning.R",
  "R/04_eda.R",
  "R/05_statistics.R",
  "R/06_patterns.R",
  "R/07_anomaly.R",
  "R/08_insights.R"
)
for (s in steps) {
  cat("\n=====", s, "=====\n")
  t0 <- Sys.time()
  source(s, local = new.env())
  cat(sprintf("--> finished in %.1f s\n", as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}
if (requireNamespace("rmarkdown", quietly = TRUE) && rmarkdown::pandoc_available()) {
  rmarkdown::render("report/Noise_Analysis_Report.Rmd", output_dir = "outputs", quiet = TRUE)
  cat("\nReport written to outputs/Noise_Analysis_Report.html\n")
} else cat("\nInstall rmarkdown/pandoc (or use RStudio) to knit report/Noise_Analysis_Report.Rmd\n")
cat("\nPipeline complete. See outputs/ for figures, tables and insights.md\n")
