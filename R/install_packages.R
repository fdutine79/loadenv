# Function install_packages -----------------------------------------------

#' Install missing packages from package list
#'
#' @param packages A vector with package names.
#'
#' @importFrom utils install.packages installed.packages
#'
#' @export
install_packages <- function(packages) {
  cat(paste0("\U1F6C8", " (Wait)", "\tSearching and installing missing packages\n"))
  start_time <- Sys.time()
  for (i in packages) {
    if (i %in% rownames(installed.packages()) == FALSE) {
      install.packages(i, dependencies = TRUE)
    }
  }
  end_time <- Sys.time()

  cat(paste0("\u2714", " (Done)", "\tAll required packages installed ", paste0("(", round(end_time - start_time, 1), "s)"), "\n\n"))
  rm(i, start_time, end_time)
}
