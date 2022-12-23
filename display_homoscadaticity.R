# display_homoscadasticity.r
#
#######################################################################
# This script demonstrates what homoscadastic behavior looks like and
# how to detect it.
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
# Access Old Faithful data from package alr4 and cast it into a tibble,
# confirm it by displaying the tibble.  Note:  When you display a 
# tibble only the first 10 rows are shown.
#######################################################################

faithful2 <-                              # Access data and convert
  tibble( faithful ) %>%                  # Convert it to a tibble,
  rename( "length" = "eruptions",         # and replace variable ...
          "interval" = "waiting" )        # names with more meaningful
                                          # names.

faithful2                                 # Display tibble.

#######################################################################
# Remark:
# 1. length is the ;length in minutes of an eruption measure in 
#    minutes.
# 2. interval is the the interval to the next eruption measure in 
#     minutes.
#######################################################################


################################################################################
# The first step in any analysis is to plot and look.
################################################################################

p1 <- ggplot( faithful2,
         aes( x = length, 
              y =interval )) + 
    geom_point( ) +
    theme_cowplot() +
    xlab( "Length of eruption(minutes)" ) +
    ylab( "Interrval to next eruption(minutes") +
    ggtitle( "Interval to next eruption versus duration of eruption" ) +
    theme_cowplot()

p1

################################################################################
# Analysis:
# We see that there are two groups in the Old Faithful data.  Perhaps there are
# two different physical mechanisms that control the data.  But it sill looks 
# like 23 will will be able to predict the interval to the next eruption from
# the duration of the current eruption.
################################################################################


################################################################################
# We fit, that is, we estimate the model and display the model results.  We use
# the broom package methods to make the output easier to comprehend.  For this
# example we are not really interested in model per se but in the behavior of
# the residuals.
################################################################################

fit <-                                  # Fit the model
  lm( interval ~ length,
      data = faithful2 )

glance( fit )                           # Display model summary statistics.

tidy( fit )                             # Display fitted equation coefficients.

################################################################################
# The estimated simple linear regression equation is:
#
# interval = 33.5 + 10.7 * interval
#
################################################################################


################################################################################
# We use the broom package function to created the augmented tibble.  This
# tibble will include the fitted values and residuals.  We need these to 
# analyze the model to see if the constant variance assumption is satisfied.
################################################################################

diagnostics <-                            # create augmented tibble.
  augment( fit )

diagnostics                              #  Display it.


################################################################################
# We check for homoscadastic behavior by plotting the residuals versus the 
# fitted values.  If the behavior of the data is homogeneous then the width of
# the residuals show be approximately the same ofver all the values of the
# fitted values.
################################################################################

p2 <-
  ggplot( augmented,
          aes( x = .fitted,
               y = .resid)) +
    geom_point() +
    xlab( "Fitted values(ninutes)" ) +
    ylab( "Residuals(Minutes)" ) +
    ggtitle( "Example of Homoscadastic behavior of residuals" ) +
    theme_cowplot()

p2

################################################################################
# The maximum width of the residuals appears to be approximately the same over
# the the entire ranger of the fitted values.  We conclude that the behavior of
# the residuals is approximate homoscadastic.
################################################################################