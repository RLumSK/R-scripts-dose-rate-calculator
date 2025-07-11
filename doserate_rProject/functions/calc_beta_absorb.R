# function for beta absorption factor, suitable for coarse grains between 20 um and 1000 um, data from Guerin (2012)

calc_beta_absorb <- function() {
  grain <- (grain.min + grain.max) / 2

  if (mineral == "fsp") {
    f_absorb_U <- function(x) {
      y <- 0.01505 + 0.6178 * (1 - exp(-x / 1273.14)) + 0.03534 * (1 - exp(-x / 44.40)) # fitted in Origin
    }

    f_absorb_Th <- function(x) {
      y <- 0.02003 + 0.5690 * (1 - exp(-x / 1128.41)) + 0.10357 * (1 - exp(-x / 95.99)) # fitted in Origin
    }

    absorb.K <- -6.86E-4 + 3.66E-4 * grain # fitted in Origin
    absorb.K.err <- (3.66E-4 * (grain.max - grain.min)) / 2
  }

  if (mineral == "qz") {
    f_absorb_U <- function(x) {
      y <- 0.01410 + 0.6065 * (1 - exp(-x / 1185.9)) + 0.03485 * (1 - exp(-x / 38.82)) # fitted in Origin
    }

    f_absorb_Th <- function(x) {
      y <- 0.01995 + 0.5614 * (1 - exp(-x / 1136.5)) + 0.1008 * (1 - exp(-x / 90.65)) # fitted in Origin
    }

    absorb.K <- -3.38E-4 + 3.78E-4 * grain # fitted in Origin
    absorb.K.err <- (3.78E-4 * (grain.max - grain.min)) / 2
  }

  absorb.U <- f_absorb_U(grain)
  absorb.U.err <- 0.5 * (f_absorb_U(grain.max) - f_absorb_U(grain.min))

  absorb.Th <- f_absorb_Th(grain)
  absorb.Th.err <- 0.5 * (f_absorb_Th(grain.max) - f_absorb_Th(grain.min))

  # absorb.Rb is fitted from Readhead(2002), unit in µGy/a/(ppm Rb), for internal dose, it includes the conversion factor
  f_absorb_Rb <- function(x) {
    y <- 0.2596 * (1 - exp(-x / 101.8)) + 0.0927 * (1 - exp(-x / 633)) # fitted in Origin
  }

  absorb.Rb <- f_absorb_Rb(grain)
  absorb.Rb.err <- 0.5 * (f_absorb_Rb(grain.max) - f_absorb_Rb(grain.min))

  c(absorb.U, absorb.U.err, absorb.Th, absorb.Th.err, absorb.K, absorb.K.err, absorb.Rb, absorb.Rb.err)
}
