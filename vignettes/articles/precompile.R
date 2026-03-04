# Precompile vignettes that require downloaded data
# Run this script manually before building the package

# Ensure renmods is loaded
devtools::load_all()

# Files to precompile
vignettes <- c("renmods")

# NOTE: This precompiles but does not fix figure locations, if figures are included
# in future, will need to do that.
for (v in vignettes) {
  message("Precompiling ", v, ".Rmd")

  input_file <- file.path("vignettes/articles", paste0(v, ".Rmd.orig"))
  output_file <- file.path("vignettes/articles", paste0(v, ".Rmd"))

  # Knit the .Rmd.orig to create .Rmd with output
  knitr::knit(
    input = input_file,
    output = output_file,
    envir = new.env()
  )
}
