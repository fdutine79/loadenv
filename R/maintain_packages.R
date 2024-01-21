# Function maintain_packages ----------------------------------------------

#' Maintains the packages
#'
#' @param packageload_man Vector with manually loaded packages.
#'
#' @importFrom crayon bold green red yellow
#'
#' @export
maintain_packages <- function(packageload_man) {
  # Get all loaded packages
  packageload_all <- get_all_loaded_packages()

  # Get used functions
  used_functions <- get_used_functions()

  # Find which loaded packages are used
  used_packages <- get_used_packages(used_functions)

  # Find which loaded packages are not used
  unused_packages_all <- packageload_all[!(packageload_all %in% used_packages)]
  unused_packages_man <- packageload_man[!(packageload_man %in% used_packages)]


  # Report ----------------------------------------------------------------

  l_all <- length(unused_packages_all)
  l_man <- length(unused_packages_man)
  s_all <- ifelse(l_all == 1, "", "s")
  s_man <- ifelse(l_man == 1, "", "s")

  if (l_all > 0) {
    cat(paste0("\n", yellow(bold("\u26A0"), paste0("(", l_all, " Result", s_all, ")")), "\t", l_all, " globally loaded unused package", s_all, " found:\n\t\t"))
    cat(paste(unused_packages_all, collapse = ", "))
  } else {
    cat(paste0("\n", green(bold("\u2714"), paste0("(", l_all, " Result", s_all, ")")), "\t", l_all, " globally loaded unused package", s_all, " found"))
  }
  if (l_man > 0) {
    cat(paste0("\n", red(bold("\u2717"), paste0("(", l_man, " Result", s_man, ")")), "\t", l_man, " manually loaded unused package", s_man, " found:\n\t\t"))
    cat(paste(unused_packages_man, collapse = ", "))
  } else {
    cat(paste0("\n", green(bold("\u2714"), paste0("(", l_man, " Result", s_man, ")")), "\t", l_man, " manually loaded unused package", s_man, " found"))
  }

  if (l_all > 0 || l_man > 0) {
    cat(paste0(
      "\n\nUnused packages were found.",
      ifelse(l_all > 0, "\n\n\tGlobally loaded unused packages might result from dependencies from required packages.\n\tImmediate action might not be neccessary.\n\tPlease make sure, no `library()` function is run in other files than `LoadEnvironment.R`.", ""),
      ifelse(l_man > 0, "\n\n\tManually loaded unused packages should be immediately removed.", "")
    ))

    prmt_pm <- readline(prompt = cat(paste0(
      "\n\nDo you want to proceed anyway?\n\n",
      "1: Yes\n",
      "2: No"
    )))

    if (as.integer(prmt_pm) == 2) {
      cat(paste0(red(bold("\u2717"), "(Stop)"), "\tPlease clean up your environment\n"))
    } else {
      cat(paste0(yellow(bold("\u26A0"), "(Warning)"), "\tEnvironment clean up skipped\n"))
      finish_maintenance()
    }
  } else {
    cat(paste0(green(bold("\u2714"), "(Done)"), "\tEnvironment is clean\n"))
    finish_maintenance()
  }

  rm(
    packageload_all, used_functions, used_packages, unused_packages_all, unused_packages_man,
    l_all, l_man, s_all, s_man, prmt_pm
  )
}


# Function get_all_loaded_packages ----------------------------------------

#' Get all loaded packages
#'
#' @return Vector with all loaded packages.
#'
#' @export
get_all_loaded_packages <- function() {
  packageload_all <- search()
  packageload_all <- search()[(search() %in% packageload_all)] |>
    grep(pattern = "package:", value = TRUE) |>
    gsub(pattern = "package:", replacement = "")

  return(packageload_all)
}


# Function get_used_functions ---------------------------------------------

#' Get used functions
#'
#' @return Vector with used functions.
#'
#' @importFrom crayon blue bold cyan green
#' @importFrom NCmisc list.functions.in.file
#' @importFrom utils setTxtProgressBar txtProgressBar
#'
#' @export
get_used_functions <- function() {
  # Iterate all .R-files
  cat(paste0(blue(bold("\U1F6C8"), "(Wait)"), "\tSearching used functions in packages\n"))

  # Get all files in directory
  all_files <- list.files(".", pattern = "\\.R$", full.names = FALSE, recursive = TRUE)

  # Set progress bar
  start_time <- Sys.time()
  progress_bar <- utils::txtProgressBar(min = 0, max = length(all_files), style = 3, char = "=")
  loop_counter <- 0

  used_functions <- list()
  for (i in all_files) {
    # Update progress bar
    loop_counter <- loop_counter + 1
    setTxtProgressBar(progress_bar, value = loop_counter)

    # Find which packages do used functions belong to
    functions_in_file <- NCmisc::list.functions.in.file(filename = i, alphabetic = FALSE)

    for (u in 1:length(functions_in_file)) {
      uf <- functions_in_file[u]

      if (!is.na(names(used_functions[names(uf)])) == TRUE && !is.null(names(used_functions[names(uf)])) == TRUE) {
        used_functions[[names(uf)]] <- unique(c(used_functions[[names(uf)]], functions_in_file[[u]]))
      } else {
        used_functions[names(uf)] <- functions_in_file[[u]]
      }
    }
  }

  close(progress_bar)
  end_time <- Sys.time()
  cat(paste0(green(bold("\u2714"), "(Done)"), "\tUsed functions in packages found ", cyan(paste0("(", round(end_time - start_time, 1), "s)")), "\n"))
  rm(all_files, u, uf, i, functions_in_file, progress_bar, loop_counter, start_time, end_time)

  return(used_functions)
}


# Function get_used_packages ----------------------------------------------

#' Get used packages
#'
#' @param used_functions Vector with used functions.
#'
#' @return Vector with used packages.
#'
#' @importFrom crayon bold green
#'
#' @export
get_used_packages <- function(used_functions) {
  up <- gsub("c\\(([^]]+))", "\\1", names(used_functions))
  up <- gsub(", ", ",", up)
  up <- gsub('\"', "", up)
  up <- gsub("package:", "", up)
  up <- paste(up, collapse = ",")
  up <- strsplit(up, ",")

  used_packages <- unlist(up)
  rm(up)
  cat(paste0(green(bold("\u2714"), "(Done)"), "\tUsed packages found\n"))

  return(used_packages)
}


# Function finish_maintenance ---------------------------------------------

#' Finish package maintenance
#'
#' @importFrom crayon bold green
#' @importFrom grDevices dev.set
#'
#' @export
#'
#' @examples
#' finish_maintenance()
finish_maintenance <- function() {
  cat("\n")
  dev.set()
  print(R.version)
  gc()
  cat("\n")
  cat(paste0(green(bold("\u2714"), "(Done)"), "\tPackage maintenance finished\n"))
}
