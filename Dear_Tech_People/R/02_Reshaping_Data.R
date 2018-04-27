#
# Author:   Cristian E. Nuno
# Purpose:  Reshape data to long format 
# Date:     April 25, 2018

# load necessary packages
library( tidyverse )

# load necessary data
df <-
  url( "https://github.com/cenuno/DataViz/raw/master/Dear_Tech_People/Write_Data/2018-04-25-clean_data.rds" ) %>%
  gzcon() %>%
  readRDS()

# transfrom df into a list object
# and rename it original
df <-
  list( original = df )

# separate

# end of script #
