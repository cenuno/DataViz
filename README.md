Data Visualizations
================
Cristian E. Nuno
April 08, 2018

-   [Reshaping `iris` into Tidy Format](#reshaping-iris-into-tidy-format)

Reshaping `iris` into Tidy Format
=================================

> Tidy datasets are easy to manipulate, model and visualise, and have a specific structure: each variable is a column, each observation is a row, and each type of observational unit is a table. - Hadley Wickham

Using the concepts laid out in [Tidy Data](http://vita.had.co.nz/papers/tidy-data.pdf), I reshape [Edgar Anderson's `iris` Data](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html). I then visualize the results by each species.

``` r
# load library
library( tidyverse )
```

    ## ── Attaching packages ───────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1     ✔ purrr   0.2.4
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.4
    ## ✔ tidyr   0.8.0     ✔ stringr 1.3.0
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ──────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
# reshape iris
# to long format
# where each row represents a measurement
# of type (Length, Width)
# by each part (Sepal, Petal)
# for each Species (setosa, virginica, versicolor)
iris.tidy <-
  iris %>%
  gather( key = "Measure", value = "Value"
          , Sepal.Length, Sepal.Width
          , Petal.Length, Petal.Width ) %>%
  mutate( Part = map_chr( .x = strsplit( x = Measure
                                         , split = "."
                                         , fixed = TRUE )
                           , .f = function( i ) i[[1]] )
          , Measure = map_chr( .x = strsplit( x = Measure
                                                  , split = "."
                                                  , fixed = TRUE )
                                   , .f = function( i ) i[[2]] ) )

# visualize results
ggplot( data = iris.tidy
        , aes( x = Measure, y = Value, col = Species ) ) +
  geom_jitter() +
  facet_grid( facets = . ~ Species )
```

![](README_files/figure-markdown_github/Tidy%20Iris-1.png)
