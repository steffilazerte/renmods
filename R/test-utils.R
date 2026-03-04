# For test mocking of base functions
file.exists <- NULL

skip_if_no_cache <- function() {
  if (!cache_dir(check_only = TRUE)) {
    testthat::skip("No cache directory exists")
  }

  status <- cache_status()
  has_data <- any(!is.na(status$path) & file.exists(status$path))

  if (!has_data) {
    skip("No cached data available. Run renmods_update() to download data.")
  }
}

skip_if_no_type <- function(type) {
  skip_if_no_cache()

  path <- cache_path(type)
  if (!file.exists(path)) {
    testthat::skip(paste0(
      "No cached data for type '",
      type,
      "'. Run renmods_update('",
      type,
      "')"
    ))
  }
}
