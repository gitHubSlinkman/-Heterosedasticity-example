# display_homoscadasticity.r
#
#######################################################################
# This script demonstrates what heteroscadasicity behavior looks like
# and how to detect it.
#######################################################################


#######################################################################
# Load required software packages.
#######################################################################

require( here )                        # To locate project on file system.
require( tidyverse )                   # I live in the tidyverse.
require( broom )                       # Converts lm output to tibbles.
require( scales )                      # To provide formatting axis values.
require( cowplot )                     # For professional plots.
require( flextable )                   # For superior table output.
require( alr4 )                        # Provides thee old faithful data.


#######################################################################
# We are going to uses the Ames Iowas residential housing data set to
# study the relationship between a houses sale price and the gross
# size of the living area of the house.  The data is stored in the
# data area of this project.  I downloaded the data from Kaggle.
# You can find it at:
# https://www.kaggle.com/code/ankitnagam/real-estate-in-ames-iowa
#######################################################################


#######################################################################
# The data is located in the data directory of this project. The data 
# is in a csv file.
#######################################################################

fp <- 
  file.path( here(),                    # Construct the file path ro
             "data",                    # the data file.
             "Ames.csv")

ames <-                                 # Read the file into a tibble
  read_csv( fp )                        # using the tidyverse read_csv.

ames                                    # Verify read.

################################################################################
# To get a more readable list of the columns of ames we can use the spec
# function.
################################################################################

spec( ames )

################################################################################
# The variables we will use are:
#
# 1. The response variable is SalePrice.
# 2. The predictor variable that will use is `Gr Liv Area`.

################################################################################
# The first step in any analysis is to plot and look.
################################################################################

p3 <- ggplot( ames,
         aes( x = `Gr Liv Area`, 
              y = SalePrice )) + 
    geom_point( ) +
    theme_cowplot()

p3

################################################################################
# Analysis:
# We see that as the value of gross living area increases the range of the data
# increases.  As we will see that this data is heteroscadastisic.  There is
# a relationship between the variance of the data at a specific predictor value
#  and the mean of the data at that value of the predictor variable.  That is,
# The larger the Gross Living Area is the larger the variability of the data is.
################################################################################


################################################################################
# We fit, that is, we estimate the model and display the model results.  We use
# the broom package methods to make the output easier to comprehend.  For this
# example we are not really interested in model per se but in the behavior of
# the residuals.
################################################################################

fit <-
  lm( SalePrice ~ `Gr Liv Area`,
      data = ames )

glance( fit )                           # Display model summary statistics.

tidy( fit )                             # Display fitted equation coefficients.

################################################################################
# The estimated simple linear regression equation is:
#
# SalePrice = 13290 + 112 * `Gr Liv Area`
#
################################################################################


################################################################################
# We use the broom package function to created the augmented tibble.  This
# tibble will include the fitted values and residuals.  We need these to 
# analyze the model to see if the constant variance assumption is satisfied.
################################################################################

diagnostics <-                          # Construct diagnostics statistics. 
  augment( diagostics )                 

diagnostics                             # Display tibble.



################################################################################
# We check for homoscadastic behavior by plotting the residuals versus the 
# fitted values.  If the behavior of the data is homogeneous then the width of
# the residuals show be approximately the same ofver all the values of the
# fitted values.
################################################################################

p2 <-
  ggplot( diagnostics,
          aes( x = .fitted,
               y = .resid)) +
    geom_point() +
    xlab( "Fitted values(ninutes)" ) +
    ylab( "Residuals(Minutes)" ) +
    ggtitle( "Example of Hheteroscadastic behavior of residuals" ) +
    theme_cowplot()

p2

################################################################################
# We see that the spread of the residuals "fans out ar the fitted value 
# Increases.  This characteristic of heteroscadastic data. 
#
# Note that we see potential outliers in this data.  Where are they?
################################################################################