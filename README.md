
# loadenv

The goal of loadenv is to set up a clean package environment.

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
- Specify CRAN packages by their name on CRAN. Run
  `load_environment(packages)`.

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