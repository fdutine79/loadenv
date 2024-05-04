# Function install_packages -----------------------------------------------

#' Install missing packages from package list
#'
#' @param packages A vector with package names.
#' @param fast Logical TRUE to skip prompts.
#' @param reinstall Logical for recursive installation (updating packages)
#'
#' @importFrom available available_on_cran available_on_github
#' @importFrom devtools install_github
#' @importFrom gh gh
#' @importFrom utils install.packages installed.packages
install_packages <- function(packages, fast = fast) {
  cat(paste0("\U1F6C8", " (Wait)", "\tSearching and installing missing packages\n"))
  start_time <- Sys.time()
  packages_collector <- c()
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
    } else if (fast == FALSE) {
      # Check packages that need update
      date_local <- as.Date(when_updated(p), format = "%Y-%m-%d")
      if (as.logical(available_on_cran(p)[1]) == FALSE) {
        # for Cran
        date_remote <- as.Date(packageDescription(p)$Date, format = "%Y-%m-%d")
        if (!is.null(date_local) && !is.na(date_local) &&
          !is.null(date_remote) && !is.na(date_remote) &&
          date_local < date_remote) {
          packages_collector <- cbind(packages_collector, p)
        }
      } else if (as.logical(available_on_github(p)[1]) == FALSE) {
        # for GitHub
        date_remote <- as.Date(gh(paste("GET /repos/", i, sep = ""))[["updated_at"]], format = "%Y-%m-%d")
        if (!is.null(date_local) && !is.na(date_local) &&
          !is.null(date_remote) && !is.na(date_remote) &&
          date_local < date_remote) {
          packages_collector <- cbind(packages_collector, i)
        }
      }
    }
  }

  if (length(packages_collector) > 0 && fast == FALSE) {
    prmt_pm <- readline(prompt = cat(paste0(
      "\nThe following packages indicate to be outdated.\n\n",
      paste(packages_collector, collapse = ", "), "\n\n",
      "Do you want to update them now?\n\n",
      "1: Yes\n",
      "2: No"
    )))

    # Update outdated packages
    if (as.integer(prmt_pm) == 1) {
      upgrade_packages(as.character(packages_collector))
    }
  }
  end_time <- Sys.time()

  cat(paste0("\u2714", " (Done)", "\tAll required packages installed ", paste0("(", round(end_time - start_time, 1), "s)"), "\n\n"))
  rm(i, start_time, end_time, packages_collector, date_local, date_remote, prmt_pm)
}


# Function upgrade_packages -----------------------------------------------

#' Upgrades missing packages from package list
#'
#' @param packages A vector with package names.
#'
#' @importFrom available available_on_cran available_on_github
#' @importFrom devtools install_github
#' @importFrom utils install.packages installed.packages
upgrade_packages <- function(packages) {
  cat(paste0("\U1F6C8", " (Wait)", "\tUpgrading packages\n"))
  start_time <- Sys.time()
  unload_packages()
  for (i in packages) {
    # Split slash if necessary
    # to get package name
    if (grepl("/", i) == TRUE) {
      p <- strsplit(i, "/")[[1]][2]
    } else {
      p <- i
    }

    if (as.logical(available_on_cran(p)[1]) == FALSE) {
      install.packages(p, dependencies = TRUE)
    } else if (as.logical(available_on_github(p)[1]) == FALSE) {
      devtools::install_github(i)
    } else {
      warning(paste0(
        "Package '", i, "' neither found on CRAN nor GitHub\n",
        "Skipping upgrade"
      ))
    }

    cat(paste0("\u2714", " (Done)", "\tOutdated package ", p, " upgraded ", "\n\n"))
  }
  end_time <- Sys.time()

  cat(paste0("\u2714", " (Done)", "\tAll outdated packages upgraded ", paste0("(", round(end_time - start_time, 1), "s)"), "\n\n"))
  rm(i, p, start_time, end_time)
}


# Function when_updated ---------------------------------------------------

#' Return the updated date of locally installed packages
#'
#' @description
#' The function relies on that packages will always have DESCRIPTION file.
#' According to the author "that's a safe bet" (Konrad, 2021). See
#' https://stackoverflow.com/questions/68214167/ for details.
#'
#' @param pkg The package name
#' @param lib
#'
#' @return Returns a POSIXct[1:1] format YYYY-MM-DD HH:MM:SS CEST
#'
#' @importFrom fs file_info
when_updated <- function(pkg, lib = .libPaths()[1]) {
  desc_file <- system.file("DESCRIPTION", package = pkg, lib.loc = lib)
  info <- fs::file_info(desc_file)
  info$change_time
}
