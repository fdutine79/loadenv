# Tests for function load_packages ----------------------------------------

test_that("Vector is correctly returned", {
  expect_equal(load_packages(c("base")), "base")
})