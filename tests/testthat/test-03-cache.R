# Test cache_dir() ------------------------------------------------------------

test_that("cache_dir() creates the dir and returns a path", {
  temp_dir <- withr::local_tempdir()
  withr::local_options(list(renmods.cache_dir = file.path(temp_dir, "renmods")))
  expect_message(path <- cache_dir(), "Creating cache directory")
  expect_type(path, "character")
  expect_true(dir.exists(path))
})

test_that("cache_dir() check_only returns logical", {
  expect_silent(result <- cache_dir(check_only = TRUE))
  expect_type(result, "logical")
  expect_true(result)
})

# Test cache_path() ------------------------------------------------------------

test_that("cache_path() returns correct file paths", {
  expect_silent(result <- cache_path("this_yr"))
  expect_match(result, "this_yr\\.csv\\.gz$")
  expect_true(stringr::str_detect(result, stringr::fixed(cache_dir())))
})

test_that("cache_path() works with multiple types", {
  expect_silent(result <- cache_path(c("this_yr", "yr_2_5")))
  expect_length(result, 2)
  expect_match(result[1], "this_yr\\.csv\\.gz$")
  expect_match(result[2], "yr_2_5\\.csv\\.gz$")
})

test_that("cache_path() expands 'all' to all types", {
  expect_silent(result <- cache_path("all"))
  expect_length(result, length(renmods()$type))
  expect_true(all(stringr::str_detect(
    result,
    paste0(renmods()$type, "\\.csv\\.gz$")
  )))
})


# Test cache_status() ----------------------------------------------------------

test_that("cache_status()", {
  withr::local_options(list(renmods.cache_dir = withr::local_tempdir()))
  cache_dir() # Create the directory

  expect_silent(result <- cache_status())
  expect_s3_class(result, "data.frame")
  expect_named(
    result,
    c("type", "last_downloaded", "date_range", "renmods_version", "path"),
    ignore.order = TRUE
  )
})

# Test cache_remove() -------------------------------------------
test_that("cache_remove()", {
  withr::local_options(list(renmods.cache_dir = withr::local_tempdir()))
  cache_dir() # Create the directory

  expect_message(cache_remove(), "Cache to be removed") |>
    expect_message(cache_dir()) |> # Dir to remove
    expect_message("Removing the cache")
})
