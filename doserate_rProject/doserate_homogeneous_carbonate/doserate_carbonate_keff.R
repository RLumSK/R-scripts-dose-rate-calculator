## Dose rate calculation for carbonates, with the effective k-value, assuming an infinite homogeneous medium

rm(list = ls())

Dr <- read.csv("doserate_homogeneous_carbonate/Template_carbonate_keff.csv", header = TRUE)
# head(Dr)
output_filename <- "doserate_homogeneous_carbonate/Doserate_results_carbonate_keff.csv"

Radon.loss <- 0.0 # for radon loss. 0.2 means 20% of the radon is escaped.
conversion <- read.csv("conversion_data/Liritzis_2013_conversion.csv", header = TRUE)


#################################################################################
### The code below are for the calculations. Select all (ctrl+A), and run.#######
#################################################################################

# load the functions
source("functions/calc_cosmicray.R")
source("functions/calc_dr_alpha_infinite.R")
source("functions/calc_dr_beta_infinite.R")
source("functions/calc_dr_gamma.R")

# calculation
for (i in 1:nrow(Dr)) {
  # alpha efficiency in effective k-values
  keff <- Dr[i, "keff"] # unit
  keff.err <- Dr[i, "keff_err"]

  # geography information
  geo.lat <- Dr[i, "latitude"] # latitude
  geo.lon <- Dr[i, "longitude"] # longitude
  altitude <- Dr[i, "altitude_m"] # altitude，unit m
  depth <- Dr[i, "depth_m"] # the sampling depth from the surface，unit m

  # water
  water <- Dr[i, "water_percent"] / 100
  water.error <- Dr[i, "water_err"] / 100

  # U, Th, K concentrations
  U <- Dr[i, "U_ppm"]
  U.error <- Dr[i, "U_err"]

  Th <- Dr[i, "Th_ppm"]
  Th.error <- Dr[i, "Th_err"]

  K <- Dr[i, "K_percent"]
  K.error <- Dr[i, "K_err"]

  ##########################################################################
  ################################## calculations ##########################

  ############## cosmic ray dose rate ###########
  cosmic <- calc_cosmicray()
  Dr[i, "cosmicray"] <- cosmic[1]
  Dr[i, "cosmicray_err"] <- cosmic[2]

  ################### alpha dose rate ###############
  alpha <- calc_dr_alpha_infinite()
  Dr[i, "alpha"] <- alpha[1]
  Dr[i, "alpha_err"] <- alpha[2]

  #################### beta dose rate  ##############
  beta <- calc_dr_beta_infinite()
  Dr[i, "beta"] <- beta[1]
  Dr[i, "beta_err"] <- beta[2]

  #################### gamma dose rate ##############
  gamma <- calc_dr_gamma()
  Dr[i, "gamma"] <- gamma[1]
  Dr[i, "gamma_err"] <- gamma[2]

  ##################  total dose rate ###############
  doserate <- cosmic[1] + alpha[1] + beta[1] + gamma[1]
  doserate.error <- sqrt(cosmic[2]^2 + alpha[2]^2 + beta[2]^2 + gamma[2]^2)
  Dr[i, "doserate_Gyperka"] <- doserate
  Dr[i, "doserate_err"] <- doserate.error

  if (i == nrow(Dr)) {
    write.csv(Dr, output_filename, row.names = FALSE)
    cat(
      "\n####################### Well done! ##########################\n",
      "Dose rate calculation of", nrow(Dr), "samples is finished.\n",
      "The results are saved in the csv file:\n", output_filename, "\n",
      "The dose rates of the first five samples are shown below:\n\n "
    )
    print(Dr[1:5, c("Sample", "keff", "doserate_Gyperka", "doserate_err")])
  }
}
