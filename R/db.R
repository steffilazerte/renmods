# Copyright 2026 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

#' Connect to the RENMODS data
#'
#' Connect to the RENMODS data via Duck DB. Can prefilter the data by either a
#' date range (`dates`) or data types (`types`). `dates` take precedence if both
#' are supplied. Use dplyr's `collect()` function to read in the final data from
#' the connection. The fewer data sources connected to and the smaller the
#' dataset, the quicker the `collect()` function will run.
#'
#' @param dates Character/Dates vector. Start and end dates for filtering data.
#' @param types Character. Type of data to read. One of "all", "this_yr",
#' "yr_2_5", "yr_5_10", or "historical".
#'
#' @returns
#'
#' @export
#' @examples
#' library(dplyr)
#'
#' # All data
#' db <- renmods_connect()
#'
#' # All current data
#' db <- renmods_connect(types = "this_yr")
#'
#' # Use a date range to specify the data
#' db <- renmods_connect(c("2025-01-01", "2025-02-01"))
#' colnames(db) # Get a list of Column names
#' glimpse(db)  # Quick look at the Columns and data
#'
#' db |>
#'   filter(Location_ID %in% c("E327371", "E300230")) |>
#'   select(
#'     "Location_ID", "Location_Name", "Observed_Date_Time",
#'     "Observed_Property_Name", "Result_Value", "Result_Unit",
#'     "Analysis_Method_ID"
#'   ) |>
#' collect()

renmods_connect <- function(dates = NULL, types = "all") {
  if (!is.null(dates)) {
    dates <- check_dates(dates, range = TRUE)
    types <- which_data_types(dates)
  } else if (!is.null(types)) {
    types <- check_types(types)
  } else {
    types <- renmods()$types
  }

  cli_alert_info(
    paste0(
      "Connecting to {.val {types}} data",
      if (!is.null(dates)) " for dates between {dates[1]} and {dates[2]}"
    )
  )

  # Check cache exists
  if (!cache_dir(check_only = TRUE)) {
    cli_abort(
      "No ENMODS data has been downloaded. First try `renmods_update()`",
      call = NULL
    )
  }
  # Check we have all data and that it's up-to-date
  purrr::walk(types, \(t) {
    u <- check_cache(t)
    if (u) renmods_update_(t)
  })

  path <- cache_path(types)

  # https://duckdb.org/docs/stable/data/multiple_files/overview#csv
  sql <- paste0(
    "read_csv(['",
    paste0(path, collapse = "', '"),
    "'], compression = 'gzip', union_by_name = true, filename = true)"
  )

  tbl <- db_connect() |>
    duckdb::tbl_function(sql) |>
    dplyr::filter(
      # !! required because otherwise indexing [1] creates problems with the SQL commands
      # !! means evaluate right away and pass the output on
      .data$Observed_Date_Time >= !!dates[1],
      .data$Observed_Date_Time <= !!dates[2]
    )
}

db_connect <- function() {
  con <- DBI::dbConnect(
    duckdb::duckdb(),
    config = list(
      autoinstall_known_extensions = TRUE,
      autoload_known_extensions = TRUE
    )
  )
  check_db_httpsfs(con)
  con
}
