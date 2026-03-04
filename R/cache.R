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

#' Title
#'
#' @param check_only
#'
#' @returns
#'
#' @export
#' @examples
cache_dir <- function(check_only = FALSE) {
  path <- getOption(
    "renmods.cache_dir",
    default = tools::R_user_dir("renmods", which = "data")
  ) |>
    normalizePath(mustWork = FALSE)

  if (check_only) {
    return(dir.exists(path))
  }

  if (!dir.exists(path)) {
    create <- ask(
      "Cache directory does not exist. Create {path}?",
      "Creating cache directory {path}"
    )
    if (create) {
      created <- dir.create(path)
      if (created) cli_alert_success("Successfully created cache directory")
    } else {
      cli_abort("Cannot continue without a cache dir", call = NULL)
    }
  }

  path
}

cache_path <- function(types) {
  types <- check_types(types)
  path <- file.path(cache_dir(), paste0(types, ".csv.gz"))
  path
}

#' Fetch or update cache metadata
#'
#' This is an internal function to prevent users from accidentally updating
#' the last download dates for the cache. Users should use `cache_status()`
#' instead.
#'
#' @param types Character. Types of ENMODS data to check.
#' @param update Logical. Whether or not to update the metadata (assumes data
#' has just been downloaded).
#'
#' @returns
#'
#' @noRd
#' @examples
#' cache_meta()

cache_meta <- function(types = renmods()$types, update = FALSE, reset = FALSE) {
  meta <- read_meta()

  if (!update && !reset) {
    if (!is.null(types)) {
      meta <- dplyr::filter(meta, .data$type %in% .env$types)
    }
    return(meta)
  }

  if (update) {
    f <- cache_path(types)
    f <- f[file.exists(f)]

    dates <- extract_date_range(f)

    meta <- dplyr::rows_upsert(
      meta,
      dplyr::tibble(
        type = types,
        last_downloaded = as.character(round(Sys.time())),
        date_range = dates,
        renmods_version = as.character(utils::packageVersion("renmods")),
        path = f
      ),
      by = "type"
    )
  } else if (reset) {
    meta <- dplyr::rows_upsert(meta, meta_blank(types), by = "type")
  }

  write_meta(meta)
}


#' View cache status
#'
#' @export
#' @examples
#' cache_status()
cache_status <- function() {
  if (cache_dir(check_only = TRUE)) {
    cache_meta()
  } else {
    cli_inform("No cache")
  }
}

#' Title
#'
#' @param types
#'
#' @returns
#'
#' @export
#' @examples
#' \dontrun{
#' # Remove everything including the directory
#' cache_remove()
#'
#' # Remove specific data types
#' cache_remove(types = c("this_yr", "yr_2_5"))
#' }
cache_remove <- function(types = "all") {
  if (!cache_dir(check_only = TRUE)) {
    cli_inform("No cache to remove")
    return(invisible(TRUE))
  }

  if (length(types) == 1 && types == "all") {
    full <- TRUE
    f <- c(
      cache_dir(),
      list.files(
        cache_dir(),
        full.names = TRUE,
        recursive = TRUE,
        include.dirs = TRUE
      )
    )
  } else {
    full <- FALSE
    types <- check_types(types)
    f <- cache_path(types)
  }

  cli_alert_info("Cache to be removed:")
  cli_ul(f)

  remove <- ask(
    "Are you sure you would like to completely these files/folders?",
    "Removing the cache"
  )
  if (remove) {
    unlink(f, recursive = TRUE)
  }
  if (!full) {
    cache_meta()
  } # Ping to update removed file status

  invisible(TRUE)
}
