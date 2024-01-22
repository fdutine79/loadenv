
# loadenv

The goal of loadenv is to set up a clean package environment.

## The Problem

Have you ever had questions about which packages are loaded from some
place in your code via `library()`? Did you face masking problems from
certain packages such as `stats::filter()` or `dplyr::filter()`? Would
you want to write clean code, being sure about your packages loaded?

loadenv will solve those problems. loadenv will …

- Clean up your global environment and remove all object, symbols, and
  plots
- Install missing packages from your `packages` list
- Lint and tidy your code to ensure clean coding
- Unload all packages currently loaded
- Load packages from your `packages` list
- Analyse your code for used functions
- Analyse your code for used packages
- Find which loaded packages are not used
- give you a report about packages, which can be removed from the
  `packages` list
- Clean up your global environment and remove all object, symbols, and
  plots

## Installation

You can install the development version of loadenv like so:

``` r
if ("devtools" %in% rownames(installed.packages()) == FALSE) {
  install.packages("devtools")
}
if ("loadenv" %in% rownames(installed.packages()) == FALSE) {
  devtools::install_github("fdutine79/loadenv")
}
```

## Load your environment

Place your installation of loadenv first thing in your code.

- Update the package list `packages` with your own.
- Specify GitHub hosted packages with full host name.
- Specify CRAN packages by their name on CRAN.

Run `load_environment(packages)`.

``` r
packages <- c(
  "fdutine79/autotest",
  "dplyr"
)
loadenv::load_environment(packages)
```

The package installs missing packages, executes linting, and identifies
superfluous packages installed in the environment. It will notify, which
packages can be removed from the environment.
