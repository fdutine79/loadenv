# Function load_packages --------------------------------------------------

#' Load packages from package lists
#'
#' @param packages A vector with package names.
#'
#' @importFrom crayon bold cyan green
#'
#' @return Vector with manually loaded packages.
#'
#' @export
load_packages <- function(packages) {
  start_time <- Sys.time()
  packageload_man <- packages
  suppressMessages(invisible(
    lapply(packageload_man, library, character.only = TRUE)
  ))
  end_time <- Sys.time()

  cat(paste0(green(bold("\u2714"), "(Done)"), "\tRequired packages loaded ", cyan(paste0("(", round(end_time - start_time, 1), "s)")), "\n"))
  rm(start_time, end_time)

  return(packageload_man)
}
