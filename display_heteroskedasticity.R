# Display husing ames data.eteroskedasticity 
#
################################################################################
# Load required software packages.
################################################################################

require( here )                        # To locate project on file system.
require( tidyverse )                   # I live in the tidyverse.


################################################################################
# Create file path used to read the file.
################################################################################

fp <- file.path( here(),                
                 "data",
                 "Ames.csv")
