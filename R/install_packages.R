# Function install_packages -----------------------------------------------

#' Install missing packages from package list
#'
#' @param packages A vector with package names.
#'
#' @importFrom available available_on_cran available_on_github
#' @importFrom devtools install_github
#' @importFrom utils install.packages installed.packages
install_packages <- function(packages) {
  cat(paste0("\U1F6C8", " (Wait)", "\tSearching and installing missing packages\n"))
  start_time <- Sys.time()
  for (i in packages) {
    # Split slash if necessary
    # to get package name
    if (grepl("/", i) == TRUE) {
      p <- strsplit(i, "/")[[1]][2]
    } else {
      p <- i
    }

    if (p %in% rownames(installed.packages()) == FALSE) {
      if (as.logical(available_on_cran(p)[1]) == FALSE) {
        install.packages(p, dependencies = TRUE)
      } else if (as.logical(available_on_github(p)[1]) == FALSE) {
        devtools::install_github(i)
      } else {
        warning(paste0(
          "Package '", i, "' neither found on CRAN nor GitHub\n",
          "Skipping installation"
        ))
      }
    }
  }
  end_time <- Sys.time()

  cat(paste0("\u2714", " (Done)", "\tAll required packages installed ", paste0("(", round(end_time - start_time, 1), "s)"), "\n\n"))
  rm(i, start_time, end_time)
}
