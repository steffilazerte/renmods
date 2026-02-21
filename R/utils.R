#' Title
#'
#' @param path
#'
#' @returns
#'
#' @references
#' - https://www.rfc-editor.org/rfc/rfc1952.html#page-5
#' - https://en.wikipedia.org/wiki/Gzip#File_structure
#' @noRd
#' @examples
extract_date_range <- function(path) {
  con <- file(path, "rb")
  on.exit(close(con))

  # Read the first 200 bytes of raw data from the file to grab metadata
  # https://en.wikipedia.org/wiki/Gzip#File_structure
  meta <- readBin(path, what = "raw", n = 200)
  pos_flag <- 4 # Flags
  pos_xlen <- 11 # XLEN
  skip <- 0

  # Check flag that sets FNAME (whether we have an original file name)
  # First grab the 4 byte which contains the flags
  flag <- meta[pos_flag]

  # The third bit (FNAME position) in flags is represented as 0x08 (2^3)
  # Now assess if 0x08 (the FNAME position) is set in any flag byte
  # This is a 'mask'
  named <- bitwAnd(as.integer(flag), 0x08) == 8
  if (!named) {
    return(NA_character_)
  }

  # Skip ahead to XLEN
  readBin(con, "raw", n = 6)

  # Also check if the FEXTRA flag is set (because we need to skip extra if so)
  extra <- bitwAnd(as.integer(flag), 0x04) == 4
  # TODO: TEST THIS. No file had it so couldn't test
  if (extra) {
    skip <- as.integer(meta[c(pos_xlen, pos_xlen + 1)])
  }

  pos_name <- pos_xlen + skip

  # Finally, read the filename (Null-terminated so we read until we hit NULL/0)
  # Read null-terminated filename
  name <- meta[pos_name:length(meta)]
  name <- name[seq_len(which(name == 0x00)[1])]
  name <- rawToChar(name)

  # Extract date range from name
  date_range <- stringr::str_extract_all(name, "\\d{8}", simplify = TRUE) |>
    strptime("%Y%m%d", tz = "UTC") |>
    as.Date()

  date_range
}


dt_to_char <- function(dates) {
  paste0(dates, collapse = " to ")
}

char_to_dt <- function(dates) {
  dt <- stringr::str_split_1(dates, " to ")
  if (length(dt) == 1) {
    dt <- c("1900-01-01", dt)
  }
  as.Date(dt)
}

which_data_types <- function(dates) {
  cache_meta() |>
    dplyr::mutate(
      in_range = purrr::map_lgl(.data$date_range, \(dt) {
        dt <- char_to_dt(dt)
        !(all(dt < dates) | all(dt > dates))
      })
    ) |>
    dplyr::filter(.data$in_range) |>
    dplyr::pull(.data$type)
}


ask <- function(msg, no_ask = NULL) {
  if (interactive()) {
    cli_alert_warning(msg)
    go <- utils::askYesNo(msg = "", default = TRUE)
    go <- isTRUE(go)
  } else {
    go <- TRUE
    cli_alert_info(no_ask)
  }
  go
}
