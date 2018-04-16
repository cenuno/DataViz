Data Visualizations
================
Cristian E. Nuno
April 15, 2018

-   [Visualizing Categorical Counts](#visualizing-categorical-counts)
-   [Reshaping `iris` into Tidy Format](#reshaping-iris-into-tidy-format)

Visualizing Categorical Counts
==============================

This week, I spent some time learning about the [`data.table`](https://github.com/Rdatatable/data.table/wiki) package. A lot of folks on Stack Overflow recommended I look into it to speed up my processing time.

At first, I didn't know if the package was being hyped up. But after experimenting, the hype is real: `data.table` performs operations extremely quickly.

At first, the trade-off for this speed is readability. But the folks at `data.table` provide great documentation to help newbies like myself become more familiar with their syntax.

``` r
# load necessary packages
library( data.table )
library( ggplot2 )

# load necessary data
df <- as.data.table( mtcars )

# print object size 
object.size( df )
```

    ## 5608 bytes

``` r
# expand the rows in df
# from 32 to 16 billion
df <- df[ rep( x = 1:nrow( df ), times = 500000), ]

# check dim
dim( df )
```

    ## [1] 16000000       11

``` r
# now size of df is nearly 1.5 GB
object.size( df )
```

    ## 1408002792 bytes

``` r
# count the number of unique values 
# that appear in the `cyl` column
cyl.counts <-
  df[, j = .( Count = .N)
     , by = .(Cylinders = cyl ) ][ order( Cylinders ) ]


# visualize results
ggplot( cyl.counts, aes( x = factor( Cylinders )
                         , y = Count ) ) +
  geom_bar( stat = "identity"
            , aes( fill = factor( Cylinders ) )
            , position = "dodge" ) + 
  labs( title = "Counting Cylinders"
        , subtitle = "There were fewer cars with 6 cylinders than those with 4 or 8 cylinders."
        , caption = "Source: 1974 Motor Trend Car Road Tests"
        , fill = "Cylinder"
        , x = "Cylinder" )
```

![](README_files/figure-markdown_github/DT%20Viz-1.png)

Reshaping `iris` into Tidy Format
=================================

> Tidy datasets are easy to manipulate, model and visualise, and have a specific structure: each variable is a column, each observation is a row, and each type of observational unit is a table. - Hadley Wickham

Using the concepts laid out in [Tidy Data](http://vita.had.co.nz/papers/tidy-data.pdf), I reshape [Edgar Anderson's `iris` Data](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html).

``` r
# load library
library( tidyverse )
```

    ## ── Attaching packages ───────────────────── tidyverse 1.2.1 ──

    ## ✔ tibble  1.4.2     ✔ purrr   0.2.4
    ## ✔ tidyr   0.8.0     ✔ dplyr   0.7.4
    ## ✔ readr   1.1.1     ✔ stringr 1.3.0
    ## ✔ tibble  1.4.2     ✔ forcats 0.3.0

    ## ── Conflicts ──────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::between()   masks data.table::between()
    ## ✖ dplyr::filter()    masks stats::filter()
    ## ✖ dplyr::first()     masks data.table::first()
    ## ✖ dplyr::lag()       masks stats::lag()
    ## ✖ dplyr::last()      masks data.table::last()
    ## ✖ purrr::transpose() masks data.table::transpose()

``` r
# view structure of iris
str( datasets::iris )
```

    ## 'data.frame':    150 obs. of  5 variables:
    ##  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
    ##  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
    ##  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
    ##  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
    ##  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

`iris` contains 150 rows by 5 columns. Each row contains **multiple** measurement values by each observation.

Below demonstrates how to transfrom `iris` so that each row contains **one** measurement value by each observation.

``` r
# reshape iris
# to long format
# where each row represents a measurement
# of type (Length, Width)
# by each part (Sepal, Petal)
# for each Species (setosa, virginica, versicolor)
iris.tidy <-
  iris %>%
  gather( key = "Measure"
          , value = "Value"
          , -Species ) %>% 
  separate( col = Measure
            , into = c("Part", "Measure")
            , sep = "\\." )

# view results
str( iris.tidy )
```

    ## 'data.frame':    600 obs. of  4 variables:
    ##  $ Species: Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Part   : chr  "Sepal" "Sepal" "Sepal" "Sepal" ...
    ##  $ Measure: chr  "Length" "Length" "Length" "Length" ...
    ##  $ Value  : num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...

`iris.tidy` contains 600 rows by 4 columns.

The number of rows in `iris.tidy` grew by 4 because the use of [`gather()`](https://www.rdocumentation.org/packages/tidyr/versions/0.8.0/topics/gather) combined the Sepal.Length, Sepal.Width, Petal.Length, Petal.Width values into the newly created `Value` column.

At the same time, `iris.tidy` retains two important distinctions:

1.  Measurement type - length or width - in the newly created `Measure` column; and

2.  Flower part - sepal or petal - in the newly created `Part` column.

Each row in `iris.tidy` now follows the tenants of being tidy since each row contains **one** measurement value by each observation.

``` r
# visualize results
ggplot( data = iris.tidy
        , aes( x = Measure, y = Value, col = Species ) ) +
  geom_jitter() +
  facet_grid( facets = . ~ Species ) +
  labs( title = "Length and Width Values by Flower Species and Measurement Type"
       , subtitle = "Setosa's sepals tend to be larger than their petals."
       , caption = "Source: Edgar Anderson's Iris Data" )
```

![](README_files/figure-markdown_github/Visualize%20Tidy%20Iris-1.png)
