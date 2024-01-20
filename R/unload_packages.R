# Function unload_packages ------------------------------------------------

#' Unloads all but base packages
#'
#' @export
unload_packages <- function() {
  start_time <- Sys.time()
  packages_loaded <- grep(pattern = "package:", value = TRUE, search())
  for (i in packages_loaded) {
    # Exclude base packages
    if (!i %in% c(
      "package:stats", "package:graphics", "package:grDevices",
      "package:utils", "package:datasets", "package:methods",
      "package:base"
    )) {
      detach(i, unload = TRUE, character.only = TRUE, force = TRUE)
    }
  }
  end_time <- Sys.time()
  cat(paste0("\u2714", " (Done)", "\tLoaded packages detached ", paste0("(", round(end_time - start_time, 1), "s)"), "\n"))
  rm(packages_loaded, i, start_time, end_time)
}