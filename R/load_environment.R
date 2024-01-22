# Function load_environment -----------------------------------------------

#' Initiates the environment
#'
#' @param packages A vector with package names.
#'
#' @importFrom grDevices dev.list dev.off
#' @importFrom usethis use_tidy_style
#'
#' @export
load_environment <- function(packages) {
  # Clean up
  if (NROW(dev.list()) > 0) {
    dev.off()
  }
  gc()

  # Flush cache
  # Remove GLOBAL variables except 'packages'
  cat("\014")
  rm(list = setdiff(
    ls(
      all.names = TRUE, envir = .GlobalEnv
    ), "packages"
  ), envir = .GlobalEnv, inherits = TRUE)

  # Set options
  options(scipen = 999)
  options(digits = 7)
  options(warn = -1)
  options(max.print = 99999999)

  # Install missing packages
  install_packages(packages)

  # Build new packages vector
  # with GitHub hosts removed
  packages <- gsub(".*/", "", packages)

  # Start linting
  usethis::use_tidy_style()

  # Package maintenance
  prmt_pm <- readline(prompt = cat(paste0(
    "\nYou might want to run package maintenance. Maintaining your packages will let you\n",
    "know if your environment contains only neccessary packages. Maintenance might take\n",
    "two minutes waiting time. Do you want to run package maintenance?\n\n",
    "1: Yes\n",
    "2: No"
  )))

  # Unload packages
  if (as.integer(prmt_pm) == 1) {
    unload_packages()
  }

  # Load packages and get
  # manually loaded packages
  packageload_man <- load_packages(packages)

  # Maintain packages
  if (as.integer(prmt_pm) == 1) {
    maintain_packages(packageload_man)
  }

  # Remove GLOBAL variables
  rm(list = ls(
    all.names = TRUE, envir = .GlobalEnv
  ), envir = .GlobalEnv, inherits = TRUE)

  finish_maintenance()
}


# Function finish_maintenance ---------------------------------------------

#' Finish package maintenance
#'
#' @importFrom crayon bold green
#' @importFrom grDevices dev.set
finish_maintenance <- function() {
  dev.set()
  gc()
  cat(paste0("\n", green(bold("\u2714"), "(Done)"), "\tPackage maintenance finished\n"))
}
