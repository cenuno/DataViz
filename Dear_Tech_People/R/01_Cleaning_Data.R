#
# Author:   Cristian E. Nuno
# Purpose:  Clean Data
# Date:     April 25, 2018
#

# load necessary packages
library( tidyverse )

# load necessary data
df <-
  read.csv( file = "https://github.com/cenuno/DataViz/raw/master/Dear_Tech_People/Raw_Data/Dear%20Tech%20People%20-%20Data.csv"
            , header = TRUE
            , na.strings = c("", "unknown", "n/a")
            , stringsAsFactors = FALSE )

# convert date_pulled to a date object
df$date_pulled <-
  as.POSIXct( x = df$date_pulled
              , format = "%m/%d/%y %H:%M"
              , tz = "" ) %>%
  as.character() %>%
  as.Date()

# remove the '*' in American Pop and Google
df$company_name <-
  gsub( pattern = "^\\*"
        , replacement = ""
        , x = df$company_name )

# make both sector and customer base columns 
# Title Case spelling and factor variables
df$sector_1 <-
  str_to_title( string = df$sector_1 ) %>%
  as.factor()

df$sector_2 <-
  str_to_title( string = df$sector_2 ) %>%
  as.factor()

df$customer_base_1 <-
  str_to_title( string = df$customer_base_1 ) %>%
  as.factor()

df$customer_base_2 <-
  str_to_title( string = df$customer_base_2 ) %>%
  as.factor()

# identify which numeric columns
# contain a comma "," value
numeric.columns <-
  colnames( df )[
    which( !colnames( df ) %in% c("date_pulled"
                                  , "company_name"
                                  , "sector_1"
                                  , "sector_2"
                                  , "customer_base_1"
                                  , "customer_base_2"
                                  , "hq_location"
                                  , "sf_based" ) )
  ]

# create T/F indicating which columns contain a comma
df[, numeric.columns ] <-
  map( .x = df[, numeric.columns ]
                  , .f = function( i )
                    if( any( grepl( pattern = ",", x = i ) ) ){
                      gsub( pattern = ","
                            , replacement = ""
                            , x = i ) %>%
                        as.integer()
                    } else{
                      as.integer( i )
                    } )

# export results
setwd( dir = "~/RStudio_All/Visualizations/Dear_Tech_People/Write_Data/" )

saveRDS( object = df
         , file = "2018-04-25-clean_data.rds" ) 

# Session Info
sessionInfo()
# R version 3.4.4 (2018-03-15)
# Platform: x86_64-apple-darwin15.6.0 (64-bit)
# Running under: macOS High Sierra 10.13.2
# 
# Matrix products: default
# BLAS: /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
# LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
# 
# locale:
# [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
# 
# attached base packages:
# [1] stats     graphics  grDevices utils     datasets 
# [6] methods   base     
# 
# other attached packages:
# [1] forcats_0.3.0   stringr_1.3.0   dplyr_0.7.4    
# [4] purrr_0.2.4     readr_1.1.1     tidyr_0.8.0    
# [7] tibble_1.4.2    ggplot2_2.2.1   tidyverse_1.2.1
# 
# loaded via a namespace (and not attached):
# [1] Rcpp_0.12.16     cellranger_1.1.0 pillar_1.2.1    
# [4] compiler_3.4.4   plyr_1.8.4       bindr_0.1.1     
# [7] tools_3.4.4      lubridate_1.7.3  jsonlite_1.5    
# [10] nlme_3.1-131.1   gtable_0.2.0     lattice_0.20-35 
# [13] pkgconfig_2.0.1  rlang_0.2.0      psych_1.7.8     
# [16] cli_1.0.0        rstudioapi_0.7   yaml_2.1.18     
# [19] parallel_3.4.4   haven_1.1.1      bindrcpp_0.2    
# [22] xml2_1.2.0       httr_1.3.1       hms_0.4.2       
# [25] grid_3.4.4       glue_1.2.0       R6_2.2.2        
# [28] readxl_1.0.0     foreign_0.8-69   modelr_0.1.1    
# [31] reshape2_1.4.3   magrittr_1.5     scales_0.5.0    
# [34] rvest_0.3.2      assertthat_0.2.0 mnormt_1.5-5    
# [37] colorspace_1.3-2 stringi_1.1.7    lazyeval_0.2.1  
# [40] munsell_0.4.3    broom_0.4.3      crayon_1.3.4  

# end of script #